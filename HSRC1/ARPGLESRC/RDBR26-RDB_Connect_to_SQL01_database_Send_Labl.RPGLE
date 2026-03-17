     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR24
      // LEC          2022/07/08
      // This program connects to SQL01 Database and Inserts Records
      // from the Label workfile - AB#WP2L.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAB#WP2L   IF   E           K DISK
     FFGBPL01   IF   E           K DISK

     D Id              S             10I 0
     D rc              S             10I 0
     D Count           S             10I 0
     D @ErrId          S              7A
     D @ErrText        S            100A
     D  SysDate        S               Z   inz(Z'2001-01-01-00.00.00.000000')   DEFAULT Value
     D  LoadDate       S             26A
     D  SysDateISO     S               D   inz(*SYS) datfmt(*iso)               system date (date)
     D  SysDate80      S              8S 0                                      ship date (num)
     D ##compid        S             10A
     D ##custid        S             10A
     D ##NONY          S              4S 0

     D                SDS
     D  #PGM                   1     10
     D  #WSID                244    253
     D  #USER                254    263

     D                 DS
     D  DTTM                   1     20
     D  YYYY                   1      4
     D  MM                     5      6
     D  DD                     7      8
     D  HH                     9     10
     D  NN                    11     12
     D  SS                    13     14
     D  MS                    15     20

     C     *entry        PList
     C                   Parm                    DateTime         20

     C                   Eval      DTTM = DateTime
     C                   MoveL     SysDateISO    SysDate80

      /FREE

             LoadDate = YYYY + '-' + MM + '-' + DD + '-' + HH + '.' +
                        NN + '.' + SS + '.' + MS;

             SysDate = %timestamp(LoadDate);

      //     Connect to the remote system using the Id created in the SQL01 database
      //     configuration screen (RDBCFG)

         Id = RdbConnect('SQL01');
          If Id >= 0;

      //     After the connection is established, read record from master label file...

            SetLL *start AB#WP2L;

            DoW NOT %eof;

             Read AB#WP2L;

             If %eof(AB#WP2L);
                Leave;
             EndIf;

         //     get customer name from delivery code master...
             If B2SMEI = *blanks;
                ##NONY = %dec(H2NONY:4:0);
                Chain ##NONY FGBPL01;
                ##custid = B2SMEI;
             EndIf;

         //     Then, prepare the SQL statement.
               rc = RdbPrepStmt(Id:
                  'insert into [PrintLabel].[dbo].[PrintLabel_AB#WP2L] +
                  (ComputerName, CustomerID, WSID, L2TYPE, Supplier,  +
                  L2SIRK, L2SIRD, ShipDate, UserPart, OrderNumber,    +
                  SerialNumber,KanbanNumber,RouteCode,WHLocation,FTLocation, +
                  CustomerCode,DeliveryCode,Factory,DockCode,AbsoluteNumber, +
                  LocationA,PalletNumber,TotalPallets,LocationD,QtyShipped,  +
                  Destination, ASN, AS400LoadDate) +
                      values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                   rc = RdbSetStr(Id: 1: ##compid);
                   rc = RdbSetStr(Id: 2: ##custid);
                   rc = RdbSetStr(Id: 3: #USER);
                   rc = RdbSetStr(Id: 4: L2TYPE);
                   rc = RdbSetStr(Id: 5: L2SIRE);
                   rc = RdbSetStr(Id: 6: L2SIRK);
                   rc = RdbSetStr(Id: 7: L2SIRD);
                   rc = RdbSetStr(Id: 8: L2NYMD);
                   rc = RdbSetStr(Id: 9: L2MHIN);
                   rc = RdbSetStr(Id: 10: L2ODRN);
                   rc = RdbSetStr(Id: 11: L2SERI);
                   rc = RdbSetStr(Id: 12: L2SBAN);
                   rc = RdbSetStr(Id: 13: L2MNAM);
                   rc = RdbSetStr(Id: 14: L2WHLC);
                   rc = RdbSetStr(Id: 15: L2FTLC);
                   rc = RdbSetStr(Id: 16: L2TOKU);
                   rc = RdbSetStr(Id: 17: H2NONY);
                   rc = RdbSetStr(Id: 18: H2NKOJ);
                   rc = RdbSetStr(Id: 19: H2NUKE);
                   rc = RdbSetStr(Id: 20: H2ZETI);
                   rc = RdbSetStr(Id: 21: H2LOC1);
                   rc = RdbSetStr(Id: 22: H2LOC2);
                   rc = RdbSetStr(Id: 23: H2LOC3);
                   rc = RdbSetStr(Id: 24: H2LOC4);
                   rc = RdbSetStr(Id: 25: H2SYOS);
                   rc = RdbSetStr(Id: 26: H2CNAM);
                   rc = RdbSetStr(Id: 27: H2SERL);
                   rc = RdbSetDate(Id: 28: SysDate);

         //     Execute the prepared SQL statement.
                   rc = RdbPrepExec(Id);
                    If rc < 0;
                       RdbError(@ErrId: @ErrText);
                    EndIf;

                  RdbFreeStmt(Id);

            EndDo;


          EndIf;

         *InLR = *On;
         Return;

      /END-FREE

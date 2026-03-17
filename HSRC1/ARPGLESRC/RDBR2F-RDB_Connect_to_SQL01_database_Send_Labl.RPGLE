     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR2F
      // LEC          2022/07/11
      // This program connects to SQL01 Database and Inserts Records
      // from the Label workfile - AB#WP2F.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAB#WP2F   IF   E           K DISK
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

      //     After the connection is established, read record from part master.

            SetLL *start AB#WP2F;

            DoW NOT %eof;

             Read AB#WP2F;

             If %eof(AB#WP2F);
                Leave;
             EndIf;

         //     get customer name from delivery code master...
             If B2SMEI = *blanks;
                ##NONY = %dec(F2NONY:4:0);
                Chain ##NONY FGBPL01;
                ##custid = B2SMEI;
             EndIf;

         //     Then, prepare the SQL statement.
               rc = RdbPrepStmt(Id:
                  'insert into ﾛPrintLabelﾜ.ﾛdboﾜ.ﾛPrintLabel_AB#WP2Fﾜ +
                  (ComputerName,CustomerID,WSID,From1,From2,From3,From4, +
                  From5,To1,To2,To3,To4,PlantID,BarCode2D,Quantity,      +
                  MaterialHandling,Reference,PartNumber,LicensePlate,    +
                  ShipDate,ContainerType,Weight,Ref1,Ref2,Ref3,Ref4,     +
                  Absolute,KanbanNumber,Location1,Location2,Location3,   +
                  Location4,CustomerNumber,SerialNumber,ShipTo,Factory,  +
                  Dock,Ref5,AS400LoadDate) +
                      values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                   rc = RdbSetStr(Id: 1: ##compid);
                   rc = RdbSetStr(Id: 2: ##custid);
                   rc = RdbSetStr(Id: 3: #USER);
                   rc = RdbSetStr(Id: 4: F2FAD1);
                   rc = RdbSetStr(Id: 5: F2FAD2);
                   rc = RdbSetStr(Id: 6: F2FAD3);
                   rc = RdbSetStr(Id: 7: F2FAD4);
                   rc = RdbSetStr(Id: 8: F2FAD5);
                   rc = RdbSetStr(Id: 9: F2TAD1);
                   rc = RdbSetStr(Id: 10: F2TAD2);
                   rc = RdbSetStr(Id: 11: F2TAD3);
                   rc = RdbSetStr(Id: 12: F2TAD4);
                   rc = RdbSetStr(Id: 13: F2PLNT);
                   rc = RdbSetStr(Id: 14: F22DBR);
                   rc = RdbSetStr(Id: 15: F2SYOS);
                   rc = RdbSetStr(Id: 16: F2MHND);
                   rc = RdbSetStr(Id: 17: F2REFR);
                   rc = RdbSetStr(Id: 18: F2MHIN);
                   rc = RdbSetStr(Id: 19: F2LCPL);
                   rc = RdbSetStr(Id: 20: F2SHDT);
                   rc = RdbSetStr(Id: 21: F2CNTY);
                   rc = RdbSetStr(Id: 22: F2WEIG);
                   rc = RdbSetStr(Id: 23: F2REF1);
                   rc = RdbSetStr(Id: 24: F2REF2);
                   rc = RdbSetStr(Id: 25: F2REF3);
                   rc = RdbSetStr(Id: 26: F2REF4);
                   rc = RdbSetStr(Id: 27: F2ZETI);
                   rc = RdbSetStr(Id: 28: F2SBAN);
                   rc = RdbSetStr(Id: 29: F2LOC1);
                   rc = RdbSetStr(Id: 30: F2LOC2);
                   rc = RdbSetStr(Id: 31: F2LOC3);
                   rc = RdbSetStr(Id: 32: F2LOC4);
                   rc = RdbSetStr(Id: 33: F2CNAM);
                   rc = RdbSetStr(Id: 34: F2SERL);
                   rc = RdbSetStr(Id: 35: F2NONY);
                   rc = RdbSetStr(Id: 36: F2NKOJ);
                   rc = RdbSetStr(Id: 37: F2NUKE);
                   rc = RdbSetStr(Id: 38: F2REF5);
                   rc = RdbSetDate(Id: 39:SysDate);

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

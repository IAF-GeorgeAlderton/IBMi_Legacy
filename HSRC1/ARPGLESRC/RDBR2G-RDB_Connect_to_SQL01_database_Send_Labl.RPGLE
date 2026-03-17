     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR2G
      // LEC          2022/07/14
      // This program connects to SQL01 Database and Inserts Records
      // from the Label workfile - AB#WP2G.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAB#WP2G   IF   E           K DISK
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

            SetLL *start AB#WP2G;

            DoW NOT %eof;

             Read AB#WP2G;

             If %eof(AB#WP2G);
                Leave;
             EndIf;

         //     get customer name from delivery code master...
             If B2SMEI = *blanks;
                ##NONY = %dec(G2NONY:4:0);
                Chain ##NONY FGBPL01;
                ##custid = B2SMEI;
             EndIf;

         //     Then, prepare the SQL statement.
               rc = RdbPrepStmt(Id:
                  'insert into ﾛPrintLabelﾜ.ﾛdboﾜ.ﾛPrintLabel_AB#WP2Gﾜ +
                  (ComputerName,CustomerID,WSID,                         +
                  IssueID,OrderID,PaymentID,SupplierCode,PartNumber,     +
                  OrderNumber,KanbanNumber,QTY,SerialNumber,             +
                  MainRoute,SubRoute,CrossRoute,ShipDate,Bin,Dock,       +
                  CustomerPart,DrawingSpec,Filler,QRCode,Location1,      +
                  Location2,Location3,Location4,CustomerName,            +
                  PartDesc,StoreAddress,SerialNumber1,ShipTo,Dock1,      +
                  PartID,AS400LoadDate) +
                      values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                   rc = RdbSetStr(Id:  1: ##compid);
                   rc = RdbSetStr(Id:  2: ##custid);
                   rc = RdbSetStr(Id:  3: #USER);
                   rc = RdbSetStr(Id:  4: G2KNID);
                   rc = RdbSetStr(Id:  5: G2ORID);
                   rc = RdbSetStr(Id:  6: G2PYID);
                   rc = RdbSetStr(Id:  7: G2SUPL);
                   rc = RdbSetStr(Id:  8: G2SHIN);
                   rc = RdbSetStr(Id:  9: G2ORDR);
                   rc = RdbSetStr(Id: 10: G2SBAN);
                   rc = RdbSetStr(Id: 11: G2QTY);
                   rc = RdbSetStr(Id: 12: G2KSEQ);
                   rc = RdbSetStr(Id: 13: G2MROT);
                   rc = RdbSetStr(Id: 14: G2SROT);
                   rc = RdbSetStr(Id: 15: G2CRRT);
                   rc = RdbSetStr(Id: 16: G2SHDT);
                   rc = RdbSetStr(Id: 17: G2BIN);
                   rc = RdbSetStr(Id: 18: G2DOCK);
                   rc = RdbSetStr(Id: 19: G2MHIN);
                   rc = RdbSetStr(Id: 20: G2SPEC);
                   rc = RdbSetStr(Id: 21: G2FILR);
                   rc = RdbSetStr(Id: 22: G2QRCD);
                   rc = RdbSetStr(Id: 23: G2LOC1);
                   rc = RdbSetStr(Id: 24: G2LOC2);
                   rc = RdbSetStr(Id: 25: G2LOC3);
                   rc = RdbSetStr(Id: 26: G2LOC4);
                   rc = RdbSetStr(Id: 27: G2CNAM);
                   rc = RdbSetStr(Id: 28: G2PNAM);
                   rc = RdbSetStr(Id: 29: G2ADDR);
                   rc = RdbSetStr(Id: 30: G2SERL);
                   rc = RdbSetStr(Id: 31: G2NONY);
                   rc = RdbSetStr(Id: 32: G2NUKE);
                   rc = RdbSetStr(Id: 33: G2ZETI);
                   rc = RdbSetDate(Id: 34:SysDate);
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

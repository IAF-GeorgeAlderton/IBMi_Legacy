     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR2N
      // LEC          2022/07/15
      // This program connects to SQL01 Database and Inserts Records
      // from the Label workfile - AB#WP2N.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAB#WP2N   IF   E           K DISK
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

            SetLL *start AB#WP2N;

            DoW NOT %eof;

             Read AB#WP2N;

             If %eof(AB#WP2N);
                Leave;
             EndIf;

         //     get customer name from delivery code master...
             If B2SMEI = *blanks;
                ##NONY = %dec(EKDELY:4:0);
                Chain ##NONY FGBPL01;
                ##custid = B2SMEI;
             EndIf;

         //     Then, prepare the SQL statement.
               rc = RdbPrepStmt(Id:
                  'insert into ﾛPrintLabelﾜ.ﾛdboﾜ.ﾛPrintLabel_AB#WP2Nﾜ +
                  (ComputerName,CustomerID,WSID,PartNumber,KanbanNumber, +
                  Quantity,StoreAddress,SupplierName,DockCode,           +
                  Customer,CrossdockRoute,Supplier,SupplierFactory,      +
                  LinesideAddress,PartName,SubRouteNumber,               +
                  MainDirectRoute,ShipDate,ShipTime,OrderNumber,         +
                  InternalPart,Location1,Location2,Location3,Location4,  +
                  Delivery,Factory,AbsoluteNumber,QuantityContainers,    +
                  CustomerName,BIN,SerialNumber,SerialNumber5,           +
                  AS400LoadDate) +
                      values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                   rc = RdbSetStr(Id:  1: ##compid);
                   rc = RdbSetStr(Id:  2: ##custid);
                   rc = RdbSetStr(Id:  3: #USER);
                   rc = RdbSetStr(Id:  4: EKPART);
                   rc = RdbSetStr(Id:  5: EKSBAN);
                   rc = RdbSetStr(Id:  6: EKQTYC);
                   rc = RdbSetStr(Id:  7: EKSTAD);
                   rc = RdbSetStr(Id:  8: EKSUNM);
                   rc = RdbSetStr(Id:  9: EKNUKE);
                   rc = RdbSetStr(Id: 10: EKCUNM);
                   rc = RdbSetStr(Id: 11: EKMANC);
                   rc = RdbSetStr(Id: 12: EKSIRE);
                   rc = RdbSetStr(Id: 13: EKSIRK);
                   rc = RdbSetStr(Id: 14: EKLIAD);
                   rc = RdbSetStr(Id: 15: EKPANM);
                   rc = RdbSetStr(Id: 16: EKSUB#);
                   rc = RdbSetStr(Id: 17: EKMAN#);
                   rc = RdbSetStr(Id: 18: EKSHDT);
                   rc = RdbSetStr(Id: 19: EKNOTM);
                   rc = RdbSetStr(Id: 20: EKORDR);
                   rc = RdbSetStr(Id: 21: EKIPAR);
                   rc = RdbSetStr(Id: 22: EKLOC1);
                   rc = RdbSetStr(Id: 23: EKLOC2);
                   rc = RdbSetStr(Id: 24: EKLOC3);
                   rc = RdbSetStr(Id: 25: EKLOC4);
                   rc = RdbSetStr(Id: 26: EKDELY);
                   rc = RdbSetStr(Id: 27: EKFACT);
                   rc = RdbSetStr(Id: 28: EKZETI);
                   rc = RdbSetStr(Id: 29: EKUNIT);
                   rc = RdbSetStr(Id: 30: EKCNAM);
                   rc = RdbSetStr(Id: 31: EKNOBN);
                   rc = RdbSetStr(Id: 32: @@SERL);
                   rc = RdbSetStr(Id: 33: EKSER5);
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

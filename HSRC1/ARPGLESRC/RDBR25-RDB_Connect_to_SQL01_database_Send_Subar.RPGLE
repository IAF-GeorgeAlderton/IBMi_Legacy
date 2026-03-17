     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR25
      // LEC          2022/06/25
      // This program connects to SQL01 Database and Inserts Records
      // from the Subaru Manifest workfile - AB#WP43.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAB#WP43   IF   E           K DISK
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

      //     After the connection is established, read record from label file.

            SetLL *start AB#WP43;

            DoW NOT %eof;

             Read AB#WP43;

             If %eof(AB#WP43);
                Leave;
             EndIf;

         //     get customer name from delivery code master...
             If B2SMEI = *blanks;
                Chain WNONY FGBPL01;
                ##custid = B2SMEI;
             EndIf;

         //     Then, prepare the SQL statement.
               rc = RdbPrepStmt(Id:
                  'insert into [PrintLabel].[dbo].[PrintLabel_AB#WP43] +
                  (ComputerName,CustomerID,WSID,CustomerNumber,DeliveryCode, +
                  OrderNumber,SupplierCode,ShopCode,RouteCode,ShipDate, +
                  ShipTime,ShuttleRunCD1,ShuttleRunDate1,ShuttleRunTime1, +
                  ShuttleRunCD2,ShuttleRunDate2,ShuttleRunTime2,UnloadDate, +
                  UnloadTime,DeliveryCycle,PalletCode,KanbanNumber, +
                  PalletNumber,TotalPallets,KanbanQty,SpecialRackCode, +
                  Filler1,Filler2,AS400LoadDate) +
                      values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?)');

         //     Set the value of the statement parameters
                   rc = RdbSetStr(Id: 1: ##compid);
                   rc = RdbSetStr(Id: 2: ##custid);
                   rc = RdbSetStr(Id: 3: #USER);
                   rc = RdbSetStr(Id: 4: %char(WTOKU));
                   rc = RdbSetStr(Id: 5: %char(WNONY));
                   rc = RdbSetStr(Id: 6: WODCD);
                   rc = RdbSetStr(Id: 7: WSIRE);
                   rc = RdbSetStr(Id: 8: WMANC);
                   rc = RdbSetStr(Id: 9: WEECS);
                   rc = RdbSetStr(Id: 10: %char(WNODT));
                   rc = RdbSetStr(Id: 11: %char(WNOTM));
                   rc = RdbSetStr(Id: 12: WSRC1);
                   rc = RdbSetStr(Id: 13: %char(WSRD1));
                   rc = RdbSetStr(Id: 14: %char(WSRT1));
                   rc = RdbSetStr(Id: 15: WSRC2);
                   rc = RdbSetStr(Id: 16: %char(WSRD2));
                   rc = RdbSetStr(Id: 17: %char(WSRT2));
                   rc = RdbSetStr(Id: 18: %char(WULDT));
                   rc = RdbSetStr(Id: 19: %char(WULTM));
                   rc = RdbSetStr(Id: 20: WWHLC);
                   rc = RdbSetStr(Id: 21: WFTLC);
                   rc = RdbSetStr(Id: 22: WSBAN);
                   rc = RdbSetStr(Id: 23: WPLT#);
                   rc = RdbSetStr(Id: 24: WTOTP);
                   rc = RdbSetStr(Id: 25: %char(WSYOS));
                   rc = RdbSetStr(Id: 26: WSRCOD);
                   rc = RdbSetStr(Id: 27: WFIL1);
                   rc = RdbSetStr(Id: 28: %char(WFIL2));
                   rc = RdbSetDate(Id: 29: SysDate);

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

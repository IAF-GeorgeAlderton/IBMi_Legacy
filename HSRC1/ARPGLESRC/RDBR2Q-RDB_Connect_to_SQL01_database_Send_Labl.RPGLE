     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR2Q
      // LEC          2022/07/12
      // This program connects to SQL01 Database and Inserts Records
      // from the Label workfile - AB#WP2Q.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAB#WP2Q   IF   E           K DISK
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

            SetLL *start AB#WP2Q;

            DoW NOT %eof;

             Read AB#WP2Q;

             If %eof(AB#WP2Q);
                Leave;
             EndIf;

         //     get customer name from delivery code master...
             If B2SMEI = *blanks;
                ##NONY = %dec(I2DELY:4:0);
                Chain ##NONY FGBPL01;
                ##custid = B2SMEI;
             EndIf;

         //     Then, prepare the SQL statement.
               rc = RdbPrepStmt(Id:
                  'insert into ﾛPrintLabelﾜ.ﾛdboﾜ.ﾛPrintLabel_AB#WP2Qﾜ +
                  (ComputerName,CustomerID,WSID,HomePosition,            +
                  Overflow,Delivery,Factory,PartNumber,Supplier,         +
                  PartName,ShipDate,SerialNumber,Location1,              +
                  Location2,Location3,Location4,CaseNumber,CaseQty,      +
                  AS400LoadDate,OrderNumber,IAFPartNumber,PgmName)       +
                      values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                   rc = RdbSetStr(Id: 1: ##compid);
                   rc = RdbSetStr(Id: 2: ##custid);
                   rc = RdbSetStr(Id:  3: #USER);
                   rc = RdbSetStr(Id:  4: I2LVL);
                   rc = RdbSetStr(Id:  5: I2OVFL);
                   rc = RdbSetStr(Id:  6: I2DELY);
                   rc = RdbSetStr(Id:  7: I2FACT);
                   rc = RdbSetStr(Id:  8: I2PART);
                   rc = RdbSetStr(Id:  9: I2SIRE);
                   rc = RdbSetStr(Id: 10: I2PNAM);
                   rc = RdbSetStr(Id: 11: I2SHDT);
                   rc = RdbSetStr(Id: 12: I2SERL);
                   rc = RdbSetStr(Id: 13: I2LOC1);
                   rc = RdbSetStr(Id: 14: I2LOC2);
                   rc = RdbSetStr(Id: 15: I2LOC3);
                   rc = RdbSetStr(Id: 16: I2LOC4);
                   rc = RdbSetStr(Id: 17: I2CASE);
                   rc = RdbSetStr(Id: 18: I2CQTY);
                   rc = RdbSetDate(Id: 19: SysDate);
                   rc = RdbSetStr(Id: 20: I2ODRN);
                   rc = RdbSetStr(Id: 21: I2IPAR);
                   rc = RdbSetStr(Id: 22: I2PGM);

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

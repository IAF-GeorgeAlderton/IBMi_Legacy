     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR24
      // LEC          2022/07/05
      // This program connects to SQL01 Database and Inserts Records
      // from the Label workfile - AB#WP2I.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAB#WP2I   IF   E           K DISK
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

            SetLL *start AB#WP2I;

            DoW NOT %eof;

             Read AB#WP2I;

             If %eof(AB#WP2I);
                Leave;
             EndIf;

         //     get customer name from delivery code master...
             If B2SMEI = *blanks;
               IF I2DELY <> *blanks;
                ##NONY = %dec(I2DELY:4:0);
               EndIf;
                Chain ##NONY FGBPL01;
                ##custid = B2SMEI;
             EndIf;

         //     Then, prepare the SQL statement.
               rc = RdbPrepStmt(Id:
                  'insert into [PrintLabel].[dbo].[PrintLabel_AB#WP2I] +
                  (ComputerName,CustomerID,WSID,PartNumber,KanbanNumber, +
                  QTY,DockCode,StoreAddress,Supplier,PartName, +
                  InternalPartNumber,ShipDate,SerialNumber,OrderNumber,  +
                  DummyField,Location1,Location2,Location3,Location4, +
                  Delivery,Factory,AbsoluteNumber,QTYContainer,CustomerName, +
                  Weight,SerialNumber1,SBan5,SBan10,ReleaseNumber,Title1, +
                  Field1,FieldA,FieldB,FieldC,FieldD,AS400LoadDate) +
                      values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                   rc = RdbSetStr(Id: 1: ##compid);
                   rc = RdbSetStr(Id: 2: ##custid);
                   rc = RdbSetStr(Id: 3: #USER);
                   rc = RdbSetStr(Id: 4: I2PART);
                   rc = RdbSetStr(Id: 5: I2SBAN);
                   rc = RdbSetStr(Id: 6: I2QTY);
                   rc = RdbSetStr(Id: 7: I2DOCK);
                   rc = RdbSetStr(Id: 8: I2ADDR);
                   rc = RdbSetStr(Id: 9: I2SIRE);
                   rc = RdbSetStr(Id: 10: I2PNAM);
                   rc = RdbSetStr(Id: 11: I2IPAR);
                   rc = RdbSetStr(Id: 12: I2SHDT);
                   rc = RdbSetStr(Id: 13: I2SEQ#);
                   rc = RdbSetStr(Id: 14: I2ORDR);
                   rc = RdbSetStr(Id: 15: I2DUMY);
                   rc = RdbSetStr(Id: 16: I2LOC1);
                   rc = RdbSetStr(Id: 17: I2LOC2);
                   rc = RdbSetStr(Id: 18: I2LOC3);
                   rc = RdbSetStr(Id: 19: I2LOC4);
                   rc = RdbSetStr(Id: 20: I2DELY);
                   rc = RdbSetStr(Id: 21: I2FACT);
                   rc = RdbSetStr(Id: 22: I2ZETI);
                   rc = RdbSetStr(Id: 23: I2UNIT);
                   rc = RdbSetStr(Id: 24: I2CNAM);
                   rc = RdbSetStr(Id: 25: I2WEIT);
                   rc = RdbSetStr(Id: 26: I2SERL);
                   rc = RdbSetStr(Id: 27: I2SBN5);
                   rc = RdbSetStr(Id: 28: I2SB10);
                   rc = RdbSetStr(Id: 29: I2RELS);
                   rc = RdbSetStr(Id: 30: I2TTL1);
                   rc = RdbSetStr(Id: 31: I2FLD1);
                   rc = RdbSetStr(Id: 32: I2FLDA);
                   rc = RdbSetStr(Id: 33: I2FLDB);
                   rc = RdbSetStr(Id: 34: I2FLDC);
                   rc = RdbSetStr(Id: 35: I2FLDD);
                   rc = RdbSetDate(Id: 36: SysDate);

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

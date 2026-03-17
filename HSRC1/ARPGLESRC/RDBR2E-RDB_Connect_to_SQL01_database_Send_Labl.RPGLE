     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR2E
      // LEC          2022/07/13
      // This program connects to SQL01 Database and Inserts Records
      // from the Label workfile - AB#WP2E.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAB#WP2E   IF   E           K DISK
       //  FFGBPL01   IF   E           K DISK

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

            SetLL *start AB#WP2E;

            DoW NOT %eof;

             Read AB#WP2E;

             If %eof(AB#WP2E);
                Leave;
             EndIf;

         //     get customer name from delivery code master...
         //  If B2SMEI = *blanks;
         //     ##NONY = %dec(xxxxxx:4:0);
         //     Chain ##NONY FGBPL01;
         //     ##custid = B2SMEI;
         //  EndIf;

                ##custid = E2CNAM;

         //     Then, prepare the SQL statement.
               rc = RdbPrepStmt(Id:
                  'insert into ﾛPrintLabelﾜ.ﾛdboﾜ.ﾛPrintLabel_AB#WP2Eﾜ +
                  (ComputerName,CustomerID,WSID,From1,From2,From3,From4, +
                  From5,To1,To2,To3,To4,PlantID,MaterialHandling,        +
                  Part1,TotQty1,NumberOfContainers1,QPC1,                +
                  Part2,TotQty2,NumberOfContainers2,QPC2,                +
                  Part3,TotQty3,NumberOfContainers3,QPC3,                +
                  Part4,TotQty4,NumberOfContainers4,QPC4,                +
                  Part5,TotQty5,NumberOfContainers5,QPC5,                +
                  Part6,TotQty6,NumberOfContainers6,QPC6,                +
                  Part7,TotQty7,NumberOfContainers7,QPC7,                +
                  Part8,TotQty8,NumberOfContainers8,QPC8,LicensePlate,   +
                  Weight,BarCode2D,CustomerName,SerialNumber,            +
                  AS400LoadDate                                          +
                      values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  +
                             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                   rc = RdbSetStr(Id:  1: ##compid);
                   rc = RdbSetStr(Id:  2: ##custid);
                   rc = RdbSetStr(Id:  3: #USER);
                   rc = RdbSetStr(Id:  4: E2FAD1);
                   rc = RdbSetStr(Id:  5: E2FAD2);
                   rc = RdbSetStr(Id:  6: E2FAD3);
                   rc = RdbSetStr(Id:  7: E2FAD4);
                   rc = RdbSetStr(Id:  8: E2FAD5);
                   rc = RdbSetStr(Id:  9: E2TAD1);
                   rc = RdbSetStr(Id: 10: E2TAD2);
                   rc = RdbSetStr(Id: 11: E2TAD3);
                   rc = RdbSetStr(Id: 12: E2TAD4);
                   rc = RdbSetStr(Id: 13: E2PLNT);
                   rc = RdbSetStr(Id: 14: E2MHND);
                   rc = RdbSetStr(Id: 15: E2MHN1);
                   rc = RdbSetStr(Id: 16: E2TQY1);
                   rc = RdbSetStr(Id: 17: E2PAC1);
                   rc = RdbSetStr(Id: 18: E2PQY1);
                   rc = RdbSetStr(Id: 19: E2MHN2);
                   rc = RdbSetStr(Id: 20: E2TQY2);
                   rc = RdbSetStr(Id: 21: E2PAC2);
                   rc = RdbSetStr(Id: 22: E2PQY2);
                   rc = RdbSetStr(Id: 23: E2MHN3);
                   rc = RdbSetStr(Id: 24: E2TQY3);
                   rc = RdbSetStr(Id: 25: E2PAC3);
                   rc = RdbSetStr(Id: 26: E2PQY3);
                   rc = RdbSetStr(Id: 27: E2MHN4);
                   rc = RdbSetStr(Id: 28: E2TQY4);
                   rc = RdbSetStr(Id: 29: E2PAC4);
                   rc = RdbSetStr(Id: 30: E2PQY4);
                   rc = RdbSetStr(Id: 31: E2MHN5);
                   rc = RdbSetStr(Id: 32: E2TQY5);
                   rc = RdbSetStr(Id: 33: E2PAC5);
                   rc = RdbSetStr(Id: 34: E2PQY5);
                   rc = RdbSetStr(Id: 35: E2MHN6);
                   rc = RdbSetStr(Id: 36: E2TQY6);
                   rc = RdbSetStr(Id: 37: E2PAC6);
                   rc = RdbSetStr(Id: 38: E2PQY6);
                   rc = RdbSetStr(Id: 39: E2MHN7);
                   rc = RdbSetStr(Id: 40: E2TQY7);
                   rc = RdbSetStr(Id: 41: E2PAC7);
                   rc = RdbSetStr(Id: 42: E2PQY7);
                   rc = RdbSetStr(Id: 43: E2MHN8);
                   rc = RdbSetStr(Id: 44: E2TQY8);
                   rc = RdbSetStr(Id: 45: E2PAC8);
                   rc = RdbSetStr(Id: 46: E2PQY8);
                   rc = RdbSetStr(Id: 47: E2LCPL);
                   rc = RdbSetStr(Id: 48: E2WEIG);
                   rc = RdbSetStr(Id: 49: E22DBR);
                   rc = RdbSetStr(Id: 50: E2CNAM);
                   rc = RdbSetStr(Id: 51: E2SERL);
                   rc = RdbSetDate(Id: 52: SysDate);

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

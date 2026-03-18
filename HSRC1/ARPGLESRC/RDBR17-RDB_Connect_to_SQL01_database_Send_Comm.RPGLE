     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR17
      // LEC          2021/09/16
      // This program connects to SQL01 Database and Inserts Records
      // from the Part Master into Toyota_Final_Location.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FFAAPL10   IF   E           K DISK

     D Id              S             10I 0
     D rc              S             10I 0
     D Count           S             10I 0
     D @ErrId          S              7A
     D @ErrText        S            100A
     D  SysDate        S               Z   inz(Z'2001-01-01-00.00.00.000000')   DEFAULT Value
     D  SysDateISO     S               D   inz(*SYS) datfmt(*iso)               system date (date)
     D  SysDate80      S              8S 0                                      ship date (num)

      ***  customer part number
     D                 DS
     D  ##mhin                 1     20
     D  B7MHN1                 1      5
     D  B7MHN2                 6     10
     D  B7MHN3                11     15
     D  B7MHN4                16     20

     D  ##shin                 1     12
     D  B7SHN1                 1      5
     D  B7SHN2                 6     10
     D  B7SHN3                11     12

      /FREE

             SysDate = %timestamp();

      //     Connect to the remote system using the Id created in the SQL01 database
      //     configuration screen (RDBCFG)

         Id = RdbConnect('SQL01');
          If Id >= 0;

      //     After the connection is established, read record from part master.

            SetLL *start FAAPL10;

            DoW NOT %eof;

             Read FAAPL10;

             If %eof(FAAPL10);
                Leave;
             EndIf;

             If B7SKBN <> *blank;
                Iter;
             EndIf;

         //     Then, prepare the SQL statement.
                   rc = RdbPrepStmt(Id:
                      'insert into dbo.Toyota_Common_Part  +
                      (CustomerNumber, DeliveryCode, Factory, +
                      DockCode, CustomerPartNumber, +
                      IAFPartNumber, EffectiveDate) +
                      values(?, ?, ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                   rc = RdbSetNum(Id: 1: B7TOKU);
                   rc = RdbSetNum(Id: 2: B7NONY);
                   rc = RdbSetStr(Id: 3: B7NKJO);
                   rc = RdbSetStr(Id: 4: B7NUKE);
                   rc = RdbSetStr(Id: 5: ##mhin);
                   rc = RdbSetStr(Id: 6: ##shin);
                   rc = RdbSetDate(Id: 7: SysDate);

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

     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR04
      // LEC          2019/07/31
      // This program connects to IAF Database SQL server and Inserts Records
      // from the Pallet Condition File - AM#PP45 into Toyota_PalletReturns
      // table.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAM#PL45   IF   E           K DISK

     D Id              S             10I 0
     D rc              S             10I 0
     D OK              S              2    inz('OK')
     D  SysDateISO     S               D   inz(*SYS) datfmt(*iso)               system date (date)
     D  ScanDt80       S              8S 0                                      scan date (num)

     C     *Entry        PList
     C                   Parm                    In_ScanDt         8

      *** If scan date in was not specified, then calculate it.
     C                   If        In_ScanDt = *blanks
     C                   SubDur    1:*days       SysDateISO
     C                   MoveL     SysDateISO    ScanDt80
     C                   Else
     C                   MoveL     In_ScanDt     ScanDt80
     C                   EndIf

     C     Key           KList
     C                   KFld                    ScanDt80

      /FREE

      //     Connect to the remote system using the Id created in the IAF database
      //     configuration screen (RDBCFG)

         Id = RdbConnect('IAFDB');
          If Id >= 0;

      //     After the connection is established, read record from pallet condition file.

            Chain Key AM#PL45;

                DoW NOT %eof;

                  If D1SNAM = 'IAF';

                //     Then, prepare the SQL statement.
                  rc = RdbPrepStmt(Id:
                      'insert into dbo.Toyota_PalletReturns +
                      (NAMC, CompanyName, OrderNumber, DockCode, +
                      PalletCode, Cycle, Received, Damaged) +
                      values(?, ?, ?, ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                  rc = RdbSetStr(Id: 1: d1namc);
                  rc = RdbSetStr(Id: 2: d1name);
                  rc = RdbSetStr(Id: 3: d1ord#);
                  rc = RdbSetStr(Id: 4: d1nuke);
                  rc = RdbSetStr(Id: 5: d1palt);
                  rc = RdbSetStr(Id: 6: d1mrso);
                  rc = RdbSetStr(Id: 7: d1recv);
                  rc = RdbSetStr(Id: 8: d1damg);

         //     Execute the prepared SQL statement.
                  rc = RdbPrepExec(Id);

                  RdbFreeStmt(Id);

                  EndIf;

                ReadE Key AM#PL45;

                EndDo;


          EndIf;

         *InLR = *On;
         Return;

      /END-FREE

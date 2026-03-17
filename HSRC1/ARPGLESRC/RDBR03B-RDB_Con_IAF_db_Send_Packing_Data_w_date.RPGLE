     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR03B
      // LEC          2019/08/19
      // This program connects to IAF Database SQL server and Inserts Records
      // from the Packing File - AM#PP01 into Toyota_PackingData table.
      //   This pgm is same as RDBR03 but uses a date range passed in.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAM#PL0B   IF   E           K DISK

     D Id              S             10I 0
     D rc              S             10I 0
     D Count           S             10I 0
     D OK              S              2    inz('OK')
     D  SysDateISO     S               D   inz(*SYS) datfmt(*iso)               system date (date)
     D  ShipDt80       S              8S 0                                      ship date (num)
     D  kanban#        S              4                                         ship date (num)

      *** If ship date in was not specified, then calculate it.
     C                   If        In_ShipFr = *blanks Or In_ShipTo = *blanks
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf

     C     *Entry        PList
     C                   Parm                    In_ShipFr         8
     C                   Parm                    In_ShipTo         8

     C     Key           KList
     C                   KFld                    In_ShipFr

      /FREE

      //     Connect to the remote system using the Id created in the IAF database
      //     configuration screen (RDBCFG)

         Id = RdbConnect('IAFDB');
          If Id >= 0;

      //     After the connection is established, read record from packing file.

            Chain Key AM#PL0B;

                DoW NOT %eof;

                  If r1shid > In_ShipTo;
                     Leave;
                  EndIf;

                  If r1skjy = *blank and r1hnte = 'OK';

                     kanban# = %subst(R12D:39:4);

                //     Then, prepare the SQL statement.
                  rc = RdbPrepStmt(Id:
                      'insert into dbo.Toyota_PackingData +
                      (CompanyName, ShipDate, ShipTime, DockCode, +
                      OrderNumber, PalletCode, IAFPalletCode, Kanban) +
                      values(?, ?, ?, ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                  rc = RdbSetStr(Id: 1: r1smei);
                  rc = RdbSetStr(Id: 2: r1shid);
                  rc = RdbSetStr(Id: 3: r1shit);
                  rc = RdbSetStr(Id: 4: r1dock);
                  rc = RdbSetStr(Id: 5: r1ord#);
                  rc = RdbSetStr(Id: 6: r1palt);
                  rc = RdbSetStr(Id: 7: r1iafp);
                  rc = RdbSetStr(Id: 8: kanban#);

         //     Execute the prepared SQL statement.
                  rc = RdbPrepExec(Id);

                  RdbFreeStmt(Id);

                  EndIf;

                Read AM#PL0B;

                EndDo;


          EndIf;

         *InLR = *On;
         Return;

      /END-FREE

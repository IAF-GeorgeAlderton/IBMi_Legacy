     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR13
      // LEC          2021/06/02
      // This program connects to SQL01 Database and Inserts Records
      // from the Packing File - AM#PP01 into Toyota_PackingData table.
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
     D  cycle#         S              5                                         ship date (num)

      *** If ship date in was not specified, then calculate it.
     C                   If        In_ShipDt = *blanks
     C                   SubDur    1:*days       SysDateISO
     C                   MoveL     SysDateISO    ShipDt80
     C                   MoveL     ShipDt80      In_ShipDt
     C                   EndIf

     C     *Entry        PList
     C                   Parm                    In_ShipDt         8

     C     Key           KList
     C                   KFld                    In_ShipDt

      /FREE

      //     Connect to the remote system using the Id created in the SQL01 database
      //     configuration screen (RDBCFG)

         Id = RdbConnect('SQL01');
          If Id >= 0;

      //     After the connection is established, read record from packing file.

            Chain Key AM#PL0B;

                DoW NOT %eof;

                  If r1skjy = *blank and r1hnte = 'OK';

                     kanban# = %subst(R12D:39:4);
                     cycle# = %subst(R1MFBC:39:2);

                //     Then, prepare the SQL statement.
                  rc = RdbPrepStmt(Id:
                      'insert into dbo.Toyota_PackingData +
                      (CompanyName, ShipDate, ShipTime, DockCode, +
                      OrderNumber, PalletCode, IAFPalletCode, Kanban, +
                      Cycle) values(?, ?, ?, ?, ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                  rc = RdbSetStr(Id: 1: r1smei);
                  rc = RdbSetStr(Id: 2: r1shid);
                  rc = RdbSetStr(Id: 3: r1shit);
                  rc = RdbSetStr(Id: 4: r1dock);
                  rc = RdbSetStr(Id: 5: r1ord#);
                  rc = RdbSetStr(Id: 6: r1palt);
                  rc = RdbSetStr(Id: 7: r1iafp);
                  rc = RdbSetStr(Id: 8: kanban#);
                  rc = RdbSetStr(Id: 9: cycle#);

         //     Execute the prepared SQL statement.
                  rc = RdbPrepExec(Id);

                  RdbFreeStmt(Id);

                  EndIf;

                ReadE Key AM#PL0B;

                EndDo;


          EndIf;

         *InLR = *On;
         Return;

      /END-FREE

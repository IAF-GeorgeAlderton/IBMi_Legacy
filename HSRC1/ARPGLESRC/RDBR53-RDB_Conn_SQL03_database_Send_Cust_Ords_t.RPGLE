     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR53
      // LEC          2024/01/17
      // This program connects to SQL03 Database and Inserts Records
      // from the Cust Orders into ???????????????????????????
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAB#PL10C  IF   E           K DISK

     D Id              S             10I 0
     D rc              S             10I 0
     D Count           S             10I 0
     D @ErrId          S              7A
     D @ErrText        S            100A
     D ##mhin          S             20A
     D ##locn          S              6A
     D  SysDate        S               Z   inz(Z'2001-01-01-00.00.00.000000')   DEFAULT Value
     D  SysDateISO     S               D   inz(*SYS) datfmt(*iso)               system date (date)
     D  SysDate80      S              8S 0                                      ship date (num)

      ***  part number
     D                 DS
     D  A2BHB                  1     12
     D  A2BHB1                 1      5
     D  A2BHB2                 6     10
     D  A2BHB3                11     12

      ***  location change date
     D                 DS
     D  LocChgDat              1      8  0
     D  A2TRYY                 1      4  0
     D  A2TRMM                 5      6  0
     D  A2TRDD                 7      8  0

     C                   MoveL     SysDateISO    SysDate80

      /FREE

             SysDate = %timestamp();

      //     Connect to the remote system using the Id created in the SQL03 database
      //     configuration screen (RDBCFG)

         Id = RdbConnect('SQL03');
          If Id >= 0;

      //     After the connection is established, read record from part master.

            SetLL *start AB#PL10C;

            DoW NOT %eof;

             Read AB#PL10C;

             If %eof(AB#PL10C);
                Leave;
             EndIf;

             If A2GSKD <> *blank;
                Iter;
             EndIf;

             If LocChgDat > SysDate80;
                ##locn = A2KTRK + A2KTRT + A2KTRR + A2KTRD;
             Else;
                ##locn = A2STRK + A2STRT + A2STRR + A2STRD;
             EndIf;


         //     Then, prepare the SQL statement.
                   rc = RdbPrepStmt(Id:
                      'insert into dbo.Toyota_Final_Location +
                      (IAFPartNumber, IAFPartDescription, IAFFinalLocation, +
                      CustomerPartNumber, EffectiveDate)  +
                      values(?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                   rc = RdbSetStr(Id: 1: A2BHB);
                   rc = RdbSetStr(Id: 2: A2SMEI);
                   rc = RdbSetStr(Id: 3: ##locn);
                   rc = RdbSetStr(Id: 4: ##mhin);
                   rc = RdbSetDate(Id: 5: SysDate);

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

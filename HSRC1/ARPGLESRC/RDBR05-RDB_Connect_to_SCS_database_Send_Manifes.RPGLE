     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR05
      // LEC          2020/07/15
      // This program connects to SCS Database SQL server and Inserts a record
      // containing Manifest Barcode.

      // LEC          2020/07/15  Write to log file if connection error
      // LEC          2020/11/11  Call pgm to send email if error is for a Time-out
      //************************************************************************
     FALBPL30   IF   E           K DISK
     FAB#PPCT   UF A E           K DISK
     FAM#PP60   O  A E             DISK
     FAM#PP61   O  A E             DISK
      /COPY *LIBL/RDBSRC,RDBPROTO

     D Id              S             10I 0
     D rc              S             10I 0
     D Count           S             10I 0
     D RawLen          S             10I 0
     D Status          S             20    inz('Scanned pallet')
     D Kind            S             10    inz('pallet')
     D IntExec         S             10
     D Trigger         S             10I 0 inz(1)
     D  SysDate        S               Z   inz(Z'2001-01-01-00.00.00.000000')   DEFAULT Value
     D WKCD            S              6S 0
     D KEY1            S              8
     D KEY2            S              8
     D SEQ#            S             11
     D SDate           S              8S 0
     D STime           S              6S 0
     D @ErrId          S              7A
     D @ErrText        S            100A
     D Pos             S              5S 0
     D @FileName       S             10A   inz('AM#PP61')

     D MFBC            DS
     D   Field1                1      1
     D   Field2                2      2
     D   Dock1                 3      5
     D   NAMC                  1      5
     D   Supplier              6     10
     D   Dock2                11     12
     D   Order#               13     24
     D   Load                 25     33
     D   PalCode              37     38
     D   MROS                 39     40
     D   SkidId               41     44
     D   Filler               45     50

      /FREE
         dcl-pr AM#C405 extpgm ;
           Parm1 char(10) ;
         end-pr ;
      /END-FREE

      *** If manifest barcode was not passed in as parameter, end program.
     C                   If        In_MFBC = *blanks
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf

     C     *Entry        PList
     C                   Parm                    In_MFBC          50
     C                   Parm                    In_WKCD           6

      /FREE

             SysDate = %timestamp();
             SDate = %dec(%date():*iso);
             STime = %dec(%time():*hms);

      //     Connect to the remote system using the Id created in the SCS database
      //     configuration screen (RDBCFG)

         Id = RdbConnect('IAFSCS');
          If Id >= 0;

      //     After the connection is established....


      //    initialize ...
             RawLen = %len(In_MFBC);
             MFBC = In_MFBC;
      //   get worker name...
             WKCD = %dec(In_WKCD:6:0);
             chain (WKCD) ALBPL30;
                  If %found(ALBPL30) and ALSKJY = *blank;
                  M1USNM = ALWKNM;
                  EndIf;

      //   get next sequence number...
             KEY1 = 'TSCS';
             KEY2 = NAMC;
             chain (KEY1 : KEY2) AB#PPCT;
                  If %found(AB#PPCT);
                  CTNBR1 += 1;
                  Update AB#PPCT1;
                  SEQ# = %char(%editc(CTNBR1:'X'));
                  Else;
                  CTKEY1 = KEY1;
                  CTKEY2 = KEY2;
                  CTCHR1 = 'Sequence#';
                  CTNBR1 = 1;
                  Write AB#PPCT1;
                  SEQ# = %char(%editc(CTNBR1:'X'));
                  EndIf;

      //     write output record to record transaction...
                  M1SSHZ = SDate;
                  M1SSTI = Stime;
                  M1USCD = In_WKCD;
                  M12D   = In_MFBC;
                  M1NAMC = NAMC;
                  M1SUPP = Supplier;
                  M1NUKE = Dock2;
                  M1ORD# = Order#;
                  M1MRTE = Load;
                  M1DOCK = *blanks;
                  M1PALT = PalCode;
                  M1MRSO = MROS;
                  M1SKID = SkidId;
                  EvalR M1SEQ# = SEQ#;
                  Write AM#PP601;

      //     insert record into table...
      //     prepare the SQL statement...
                  rc = RdbPrepStmt(Id:
                      'insert into dbo.manifest_label_scan_sync_trigger +
                      (raw, raw_length, status, kind, field01, field02, +
                      dock1, supplier, dock2, order_number, load, +
                      palletization_code, mros, skid_id, user_id, +
                      as400_reference, +
                      integrate_execution_id, db_trigger, created_datetime) +
                      values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,+
                       ?, ?, ?)');
      //     Set the value of the statement parameters.
                  rc = RdbSetStr(Id: 1: In_MFBC);
                  rc = RdbSetNum(Id: 2: RawLen);
                  rc = RdbSetStr(Id: 3: Status);
                  rc = RdbSetStr(Id: 4: Kind);
                  rc = RdbSetStr(Id: 5: Field1);
                  rc = RdbSetStr(Id: 6: Field2);
                  rc = RdbSetStr(Id: 7: Dock1);
                  rc = RdbSetStr(Id: 8: Supplier);
                  rc = RdbSetStr(Id: 9: Dock2);
                  rc = RdbSetStr(Id: 10: Order#);
                  rc = RdbSetStr(Id: 11: Load);
                  rc = RdbSetStr(Id: 12: PalCode);
                  rc = RdbSetStr(Id: 13: MROS);
                  rc = RdbSetStr(Id: 14: SkidId);
                  rc = RdbSetStr(Id: 15: In_WKCD);
                  rc = RdbSetStr(Id: 16: SEQ#);
                  rc = RdbSetStr(Id: 17: IntExec);
                  rc = RdbSetNum(Id: 18: Trigger);
                  rc = RdbSetDate(Id: 19: SysDate);

      //     Execute the prepared SQL statement to insert record into table...
                  rc = RdbPrepExec(Id);

                  RdbFreeStmt(Id);

          Else;
             MFBC   = In_MFBC;
             MESSHZ = SDate;
             MESSTI = STime;
             MEUSCD = In_WKCD;
             ME2D   = In_MFBC;
             MENAMC = NAMC;
             MESUPP = Supplier;
             MENUKE = Dock2;
             MEORD# = Order#;
             MEMRTE = Load;
             MEPALT = PalCode;
             MEMRSO = MROS;
             MESKID = SkidId;
             RdbError(@ErrId: @ErrText);
             MEERID = @ErrId;
             MEERTX = @ErrText;
             Write AM#PP611;
              Pos = %scan('Time-out' : MEERTX);
              If Pos > *zero;
              // call pgm to send email with critical error message...
              AM#C405(@FileName) ;
              EndIf;
          EndIf;

          //
          //     Close the connection to the remote system.
          RdbClose(Id);

         *InLR = *On;
         Return;

      /END-FREE

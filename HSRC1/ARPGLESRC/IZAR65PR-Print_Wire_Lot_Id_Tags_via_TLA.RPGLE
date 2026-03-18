     H DftActgrp(*No) Option(*SrcStmt:*NoDebugIO)
      *-------------------------------------------------------------------------
      *
      *   Label Name:    IZAR65PR
      *   Description:   Print Wire Lot Id Tags via TLA
      *
      *   Created By:    LEC
      *   Creation Date: 10/02/2025
      *
      *-------------------------------------------------------------------------
     FFGBPL01   IF   E           K DISK
     FIZAPP65L  O  A E           K DISK

      *-------------------------------------------------------------------------
      *   B a r c o d e 4 0 0   P a r a m e t e r s
      *-------------------------------------------------------------------------
     D  LblNam         S              8
     D  Across         S              2P 0 inz(01)
     D  LblDev         S             10
     D  LblQty         S              4P 0 inz(0001)
     D  Demand         S              1    inz('N')
     D  Perset         S              4P 0 inz(0001)

     D  @BaseLot       S              5
     D  @NumTags       S              2S 0
     D  @ChkDigit      S              1
     D  @LOTN          S              8
     D  @X             S              2S 0
     D  @Seq           S              2

      *-------------------------------------------------------------------------
      *   V a r i a b l e   D a t a
      *-------------------------------------------------------------------------
     D  MrgDta         DS          4096
     D   LTHEAT             0001   0010
     D   LTISDT             0011   0020
     D   LTMATL             0021   0035
     D   LTDIAM             0036   0040  2
     D   LTSUNM             0041   0055
     D   LTLOTB             0056   0065
     D   LTLOTH             0066   0075
     D   LTQANO             0076   0082

     D                SDS
     D  #PGM                   1      8
     D  #WSID                244    253
     D  #USER                254    263
     D                 DS
     D  WSDT                   1     14  0
     D  WSTIME                 1      6  0
     D  WSDATE                 7     14  0

     D                 DS
     D QABC                    1     75
     D  QATYPE                 1      3
     D  QAQA#                  4     10
     D  QAMATL                11     25
     D  QADIAM                26     30S 2
     D  QAHEAT                31     40
     D  QAWGT                 41     45S 1
     D  QASUPP                46     49S 0
     D  QAPRDT                50     57S 0
     D  QAISDT                58     65S 0
     D  QAMFG#                66     72
     D  QACOIL                73     74
     D  QATGID                75     75

     D                 DS
     D ##QAQA                  1      7
     D  ##QACCD                1      1
     D  ##QASEQ                4      7

     D  ##MDY          S               D   inz(*SYS) datfmt(*usa)               system date (date)
     D  ##MDY80        S              8  0

     C     *Entry        PList
     C                   Parm                    ##QABC           75
     C                   Parm                    @LBLN             8
     C                   Parm                    @OUTQ            10

      **------------------------------------------------------------------------
      *          M a i n   P r o c e s s i n g
      **------------------------------------------------------------------------

     C                   Time                    WSDT
     C                   Move      ##MDY         ##MDY80

     C                   Eval      QABC = ##QABC
     C                   Eval      ##QAQA = QAQA#

      * get supplier name...
     C     QASUPP        Chain     FGBPL01                            51
     C                   If        *In51 = *Off
     C                   Eval      LTSUNM = B2SMEI
     C                   EndIf

      * get outq name...
     C                   If        @OUTQ  = *blanks
     C                   Eval      LblDev = 'QPRINT'
     C                   Else
     C                   Eval      LblDev = @OUTQ
     C                   EndIf

      * get label name...
     C                   If        @LBLN  = *blanks
     C                   Eval      LblNam = 'LOTID'
     C                   Else
     C                   Eval      LblNam = @LBLN
     C                   EndIf

     C                   Exsr      $OvrSR

      * get info from qa barcode...
     C                   Eval      LTHEAT = QAHEAT
     C                   Eval      LTMATL = QAMATL
     C                   Eval      LTDIAM = QADIAM

      * get issue date...
     C                   Eval      LTISDT = %char(%editw(##MDY80:'  /  /    '))

      * get base lot id...
     C                   Eval      @BaseLot = ##QACCD + ##QASEQ

      * determine how many lot tags are needed...
     C                   If        QAWGT >= 2000
     C                   Eval      @NumTags = 96
     C                   Else
     C                   Eval      @NumTags = 54
     C                   EndIf

     C                   Do        @NumTags      @X

     C                   Eval      @Seq = %char(%editc(@X:'X'))
     C                   Eval      @LOTN = @BaseLot + @Seq

      * get check digit...
     C                   Eval      PAREA = @LOTN
     C                   Eval      PCHK  = *blank
     C                   Eval      PRTCD = *blank
     C                   Call      'ALBRCC'
     C                   Parm                    PAREA           100
     C                   Parm      '007'         PBYTE             3
     C                   Parm                    PCHK              1
     C                   Parm                    PRTCD             1

      * lot id = base lot + check digit...
     C                   Eval      @ChkDigit = PCHK
     C                   Eval      @LOTN = %trim(@LOTN) + @ChkDigit

      * set lot id fields...
     C                   Eval      LTLOTB = @LOTN
     C                   Eval      LTLOTH = %subst(@LOTN:1:5) + '-' +
     C                             %subst(@LOTN:6:2) + '-' + %subst(@LOTN:8:1)
     C                   Eval      LTQANO = %subst(@LOTN:1:7)

      * print lot id tag...
     C                   Exsr      $LabelSR

      * write info to audit file for traceability...
     C                   Exsr      $WrtAudit

     C                   EndDo

      * close label spool file...
     C                   Clear                   MrgDta
     C                   Eval      LblQty = *zero
     C                   Eval      Demand = 'Y'
     C                   Exsr      $LabelSR

     C                   Eval      *InLR = *On
     C                   Return

      *-------------------------------------------------------------------------
      *          Write Lot Id Tag data to Audit File...
      *-------------------------------------------------------------------------
     C     $WrtAudit     Begsr

     C                   Eval      LGISDT = WSDATE
     C                   Eval      LGISTM = WSTIME
     C                   Eval      LGUSER = #USER
     C                   Eval      LGSUPP = QASUPP
     C                   Eval      LGLOTN = @LOTN
     C                   Eval      LGMATL = LTMATL
     C                   Eval      LGDIAM = LTDIAM
     C                   Eval      LGHEAT = LTHEAT
     C                   Eval      LGQRCD = ##QABC

     C                   Write     IZAPP65LR
     C                   Clear                   IZAPP65LR

     C                   Endsr

      *-------------------------------------------------------------------------
      *          Call Barcode400 Label Print Program
      *-------------------------------------------------------------------------
     C     $LabelSR      Begsr

     C                   Call      'Z7XI4096'
     C                   Parm                    Lblnam
     C                   Parm                    Across
     C                   Parm                    Lbldev
     C                   Parm                    Lblqty
     C                   Parm                    Demand
     C                   Parm                    Mrgdta
     C                   Parm                    Perset

     C                   Endsr

      *-------------------------------------------------------------------------
      *          Override Barcode400 Printer File
      *-------------------------------------------------------------------------
     C     $OvrSR        Begsr
     C                   Eval      CmdLen = 120

      *
      *Override Prtf
     C                   Monitor
     C                   Eval      Cmd = 'OVRPRTF FILE(BCLABELS) OUTQ(' +
     C                             %trim(LblDev)  + ') FORMTYPE(*STD)  +
     C                              EXPDATE(*DAYS) DAYS(14)  +
     C                             OVRSCOPE(*CALLLVL) SAVE(*YES)'

     C                   Call      'QCMDEXC'
     C                   Parm                    Cmd             120
     C                   Parm                    CmdLen           15 5
     C                   On-Error
     C                   EndMon

     C                   Endsr




      **------------------------------------------------------------------------
      *           P a r a m e t e r    N o t e s :
      **------------------------------------------------------------------------
      *
      *  LBLQTY  PERSET
      *
      *    If your label has an INCREMENTING #:
      *      -The "LblQty" becomes the number of "SETS" of labels.
      *      -The "Perset" filed becomes the number of labels Per Set.
      *
      *    If your label DOES NOT HAVE AN INCREMENTING #:
      *      -LblQty = label quantity field;
      *      -Perset = 1;
      *
      *       FOR EXAMPLE:  You may want two sets of labels, each set
      *       containing five labels(1 of 5, 2 of 5,.....)
      *            LblQty = 2;
      *            Perset = 5;
      *-----------------------------------------------------------------
      *  DEMAND
      *
      *   "D"  Close the spool file but leave the program and Barcode400
      *        files open.
      *        Labels print IMMEDIATELY.
      *        All Barcode400 Files are open in memory and are not closed
      *        until a "Y" is passed to the program.
      *
      *   "Y"  Close program, as a result the spool file closes.
      *        Labels print IMMEDIATELY.
      *
      *   "N"  Leave the spool file, program, and Barcode400 files open.
      *        LABELS ARE ACCUMULATED IN SPOOL FILE.
      *        Spool file, program, and program files will not close
      *        until a "Y" is passed to the program.
      *-----------------------------------------------------------------
      *  LblNam
      *
      *     This is the name of the label you wish to print.
      *-----------------------------------------------------------------
      *  Across
      *
      *     Number of labels across the form.
      *------------------------------------------------------------------
      *  MrgDta
      *
      *     Data structure(above) containing variable data to be printed
      *     on the label.
      *------------------------------------------------------------------
      *  LblDev
      *
      *     Name of "OUTQ" (e.g...P1, P2, QPRINT)
      *     This entry WILL NOT RE-DIRECT the output, it is used by the
      *     label print program to determine how the data should be sent
      *    to the printer.
      *------------------------------------------------------------------

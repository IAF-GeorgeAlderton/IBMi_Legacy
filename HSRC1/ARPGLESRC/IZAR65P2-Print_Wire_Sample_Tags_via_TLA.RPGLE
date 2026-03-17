     H DftActgrp(*No) Option(*SrcStmt:*NoDebugIO)
      *-------------------------------------------------------------------------
      *
      *   Label Name:    IZAR65P2
      *   Description:   Print Wire Sample Tags via TLA
      *
      *   Created By:    LEC
      *   Creation Date: 10/28/2025
      *
      *-------------------------------------------------------------------------
     FIZAPP65   IF   E           K DISK

      *-------------------------------------------------------------------------
      *   B a r c o d e 4 0 0   P a r a m e t e r s
      *-------------------------------------------------------------------------
     D  LblNam         S              8    inz('WIRESAMP')
     D  Across         S              2P 0 inz(01)
     D  LblDev         S             10
     D  LblQty         S              4P 0 inz(0002)
     D  Demand         S              1    inz('Y')
     D  Perset         S              4P 0 inz(0001)
     D  IssDate        S             10

      *-------------------------------------------------------------------------
      *   V a r i a b l e   D a t a
      *-------------------------------------------------------------------------
     D  MrgDta         DS          4096
     D   IWSUPP             0001   0025
     D   IWMATN             0026   0050
     D   IWDIAM             0051   0055  2
     D   IWPONO             0056   0070
     D   IWHEAT             0071   0080
     D   IWSERL             0081   0095
     D   IWGRDS             0096   0115
     D   IWWGT              0116   0120  1
     D   IWMCH#             0121   0130
     D   IWPRDT             0131   0138  0
     D   IWSHDT             0139   0146  0
     D   IWMFG#             0147   0156
     D   IWCOIL             0157   0158
     D   IWMTYP             0159   0168
     D   IWTTYP             0169   0183
     D   IWRSLT             0184   0188  1
     D   IWJOB              0189   0198
     D   IWFLD1             0199   0203
     D   IWFLD2             0204   0213
     D   IWFLD3             0214   0228
     D   IWFLD4             0229   0248

     D                SDS
     D  #PGM                   1      8
     D  #WSID                244    253
     D  #USER                254    263
     D                 DS
     D  WSDT                   1     14  0
     D  WSTIME                 1      6  0
     D  WSDATE                 7     14  0

     D                 DS
     D  ##MDY          S               D   inz(*SYS) datfmt(*usa)               system date (date)
     D  ##MDY80        S              8  0

     C     *Entry        PList
     C                   Parm                    SERIAL           15
     C                   Parm                    #OUTQ            10

      **------------------------------------------------------------------------
      *          M a i n   P r o c e s s i n g
      **------------------------------------------------------------------------

     C                   Time                    WSDT
     C                   Move      ##MDY         ##MDY80
     C                   Eval      LblDev = #OUTQ

     C                   Exsr      $OvrSR

      * get info from serial number...
     C     SERIAL        Chain     IZAPP65
     C                   If        %found

      * get issue date...
     C                   Eval      IssDate = %char(%editw(##MDY80:'  /  /    '))

      * print wire sample tags...
     C                   Exsr      $LabelSR
     C                   EndIf

     C                   Eval      *InLR = *On
     C                   Return

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

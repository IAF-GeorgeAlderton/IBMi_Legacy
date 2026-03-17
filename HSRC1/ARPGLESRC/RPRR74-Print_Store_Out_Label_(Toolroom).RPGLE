      *
      *-------------------------------------------------------------------------
      *
      *   Program Name:  RPRR74
      *   Description:   Print Store Out Label (Toolroom)
      *
      *   Created By:    LEC
      *   Creation Date: 06/30/2021
      *
      *
      *-------------------------------------------------------------------------
     H DATEDIT(*YMD/)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     FAB#PPCT   IF   E           K DISK
     FECSWP74   IF   F  256        DISK

     D  @@PGM          S              8    inz('RPRR74')
     D  @@LBFM         S             10
     D  @@OUTQ         S             10

      *-------------------------------------------------------------------------
      *   B a r c o d e 4 0 0   P a r a m e t e r s
      *-------------------------------------------------------------------------
     D  LblNam         S              8
     D  Across         S              2P 0 inz(01)
     D  LblDev         S             10
     D  LblQty         S              4P 0 inz(0001)
     D  Demand         S              1    inz('N')
     D  Perset         S              4P 0 inz(0001)

      *-------------------------------------------------------------------------
      *   V a r i a b l e   D a t a
      *-------------------------------------------------------------------------
     D  MrgDta         DS          4096
     D   W0KATA             0001   0011
     D   W0ISDT             0012   0021
     D   W0ISTM             0022   0029
     D   W0BARC             0030   0043
     D   W0LOC1             0044   0044
     D   W0LOC2             0045   0046
     D   W0LOC3             0047   0048
     D   W0LOC4             0049   0049
     D   W0DATA             0001   0049

     IECSWP74   AA  01
     I                                 01   49  DATAIN
     I                                 01  256  RECORD

      **------------------------------------------------------------------------
      *          M a i n   P r o c e s s i n g
      **------------------------------------------------------------------------
      *
      * get label name and outq from control file for this program...
     C     @@PGM         Chain     AB#PPCT
     C                   If        %found(AB#PPCT)
     C                   Eval      @@LBFM = CTCHR1
     C                   Eval      @@OUTQ = CTCHR2
     C                   EndIf

     C                   Exsr      $OvrSR

     C                   Read      ECSWP74

     C                   DoW       NOT %eof(ECSWP74)
     C                   Exsr      MoveData
     C                   Exsr      $LabelSR
     C                   Read      ECSWP74
     C                   EndDo

     C                   Eval      LblQty = *zero
     C                   Eval      Demand = 'Y'
     C                   Exsr      $LabelSR

     C                   Eval      *InLR = *On
     C                   Return

      *-------------------------------------------------------------------------
      *          Move Label Data to Merge Data for Printing
      *-------------------------------------------------------------------------
     C     MoveData      BegSr

     C                   Eval      W0DATA = DATAIN

     C                   EndSr
      *-------------------------------------------------------------------------
      *          Call Barcode400 Label Print Program
      *-------------------------------------------------------------------------
     C     $LabelSR      BegSr

     C                   Call      'Z7XI4096'
     C                   Parm                    Lblnam
     C                   Parm                    Across
     C                   Parm                    Lbldev
     C                   Parm                    Lblqty
     C                   Parm                    Demand
     C                   Parm                    Mrgdta
     C                   Parm                    Perset

     C                   EndSr
      *-------------------------------------------------------------------------
      *          Override Barcode400 Printer File
      *-------------------------------------------------------------------------
     C     $OvrSR        BegSr

     C                   Eval      Lblnam = @@LBFM
     C                   Eval      Lbldev = @@OUTQ
     C                   Eval      CmdLen = 80

     C*Library List
      *********          Monitor
      *********          Eval      Cmd = 'ADDLIBLE TLABARCODE'
      *********          Call      'QCMDEXC'
      *********          Parm                    Cmd
      *********          Parm                    CmdLen           15 5
      *********          On-Error
      *********          EndMon
     C*
     C*
     C*Override Prtf
     C                   Monitor
     C                   Eval      Cmd = 'OVRPRTF FILE(BCLABELS) +
     C                             OUTQ('+ @@OUTQ + ') FORMTYPE(*STD) +
     C                             SAVE(*YES) OVRSCOPE(*CALLLVL) +
     C                             EXPDATE(*DAYS) DAYS(2)'
     C                   Eval      CmdLen = %Len(%Trim(Cmd))

     C                   Call      'QCMDEXC'
     C                   Parm                    Cmd             115
     C                   Parm                    CmdLen           15 5
     C                   On-Error
     C                   EndMon

     C                   EndSr
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

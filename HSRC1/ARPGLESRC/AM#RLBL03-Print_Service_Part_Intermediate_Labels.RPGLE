      *
      *-------------------------------------------------------------------------
      *
      *   Program Name:  AM#RLBL03
      *   Description:   Print Service Part Intermediate Labels - called from ALDR2S
      *
      *   Created By:    LEC
      *   Creation Date: 05/10/2021
      *
      *
      *-------------------------------------------------------------------------
     H DATEDIT(*YMD/)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     FAB#PL71   IF   E           K DISK
     FAB#PL10A  IF   E           K DISK
     FFCEPL07   IF   E           K DISK
     FALDPP55   IF   E           K DISK
     FALDPP56   IF   E           K DISK

      *-------------------------------------------------------------------------
      *   B a r c o d e 4 0 0   P a r a m e t e r s
      *-------------------------------------------------------------------------
     D  LblNam         S              8    inz('AMLBL03I')
     D  Across         S              2P 0 inz(01)
     D  LblDev         S             10
     D  LblQty         S              4P 0 inz(0001)
     D  Demand         S              1
     D  Perset         S              4P 0 inz(0001)

     D                 DS
     D   NOHZ                  1      8  0
     D   EKNOYY                1      4  0
     D   EKNOMM                5      6  0
     D   EKNODD                7      8  0

     D                 DS
     D   MHIN                  1     20
     D   EKMHN1                1      5
     D   EKMHN2                6     10
     D   EKMHN3               11     15
     D   EKMHN4               16     20

     D @@SERL          S             18
     D RemQty          S              5S 0

     D MON             S              1    DIM(12) CTDATA PERRCD(12)

      *-------------------------------------------------------------------------
      *   V a r i a b l e   D a t a
      *-------------------------------------------------------------------------
     D  MrgDta         DS          4096
     D   ILPNAM             0001   0030
     D   ILPART             0031   0042
     D   ILPAR#             0043   0056
     D   ILQTY              0057   0061  0
     D   ILSUPP             0062   0066
     D   ILLGBG             0067   0067
     D   ILPRCD             0068   0080

     C     *Entry        PList
     C                   Parm                    @@SERL
     C                   Parm                    @@OUTQ           10

     C     Key10A        KList
     C                   KFld                    EKODRN
     C                   KFLD                    MHIN             20
     C                   KFLD                    NONY              4 0
     C                   KFLD                    NOHZ              8 0
     C                   KFLD                    NOBN              2 0

     C     Key55B        KList
     C                   KFLD                    EKMHN1
     C                   KFLD                    EKMHN2

     C     Key56         KList
     C                   KFLD                    EKMHN1
     C                   KFLD                    EKMHN2
      **------------------------------------------------------------------------
      *          M a i n   P r o c e s s i n g
      **------------------------------------------------------------------------
      *
      ****************   Exsr      $OvrSR

     C                   Exsr      MoveData
     C                   Eval      Demand = 'N'
     C                   Exsr      $LabelSR

     C                   If        RemQty <= *zero
     C                   Eval      LblQty = *zero
     C                   Else
     C                   Eval      LblQty = 1
     C                   Eval      ILQty = RemQty
     C                   EndIf

     C                   Eval      Demand = 'Y'
     C                   Exsr      $LabelSR

     C                   Eval      *InLR = *On
     C                   Return

      *-------------------------------------------------------------------------
      *          Move Label Data to Merge Data for Printing
      *-------------------------------------------------------------------------
     C     MoveData      BegSr

      *------------------------------------------------------------
     C     @@SERL        Chain     AB#PL71

     C                   Eval      NONY = %dec(eknony:4:0)
     C                   Eval      NOBN = %dec(eknobn:2:0)

     C     Key10A        Chain     AB#PL10A

     C     EKZETI        Chain     FCEPL07
      *------------------------------------------------------------

     C                   Eval      ILPNAM = A2SMEI

     C                   Eval      ILPART = EKMHN1+EKMHN2+EKMHN3

     C                   If        EKMHN3 = *blanks
     C                   Eval      ILPAR# = EKMHN1 + '-' + EKMHN2
     C                   Else
     C                   Eval      ILPAR# = EKMHN1 + '-' + EKMHN2 +
     C                             '-' +  EKMHN3
     C                   EndIf

     C                   Eval      ILSUPP = %trim(BASIRE) + %trim(BASIRK)

      ** check part# for large bag designation...
     C     Key55B        Chain     ALDPP55
     C                   If        %found AND A@SKJY = ' '
     C                   Eval      ILLGBG = '*'
     C                   EndIf

      ** check to see if part needs more than 1 intermediate label...
     C     Key56         Chain     ALDPP56
     C                   If        NOT %found
     C                   Eval      LblQty = 1
     C                   Eval      ILQTY  = BAODER
     C                   Else
     C                   Eval      LblQty = BAODER / B@MAXB
     C                   Eval      ILQty =  B@MAXB
     C                   Eval      RemQty = %Rem(BAODER : B@MAXB)
     C                   EndIf

     C                   EndSr
      *-------------------------------------------------------------------------
      *          Call Barcode400 Label Print Program
      *-------------------------------------------------------------------------
     C     $LabelSR      BegSr

     C                   Eval      Lbldev = @@OUTQ

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
     C                   Eval      CmdLen = 80

     C*Library List
      **********         Monitor
      **********         Eval      Cmd = 'ADDLIBLE TLABARCODE'
      **********         Call      'QCMDEXC'
      **********         Parm                    Cmd
      **********         Parm                    CmdLen           15 5
      **********         On-Error
      **********         EndMon
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
**
ABCDEFGHIJKL

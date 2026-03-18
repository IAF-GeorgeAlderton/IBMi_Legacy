     H DftActgrp(*No) Option(*SrcStmt:*NoDebugIO)
      *-------------------------------------------------------------------------
      *
      *   Label Name:    ALHR111
      *   Description:   Print LOT ID TAG for Partial LOQ via TLA
      *
      *   Created By:    LEC
      *   Creation Date: 11/03/2021
      *
      *-------------------------------------------------------------------------
     FIZAPL61   IF   E           K DISK
     FFGBPL01   IF   E           K DISK
     FFCEPL01   IF   E           K DISK
     FALHPP111  O  A E           K DISK

      *-------------------------------------------------------------------------
      *   B a r c o d e 4 0 0   P a r a m e t e r s
      *-------------------------------------------------------------------------
     D  LblNam         S              8
     D  Across         S              2P 0 inz(01)
     D  LblDev         S             10
     D  LblQty         S              4P 0 inz(0001)
     D  Demand         S              1    inz('Y')
     D  Perset         S              4P 0 inz(0001)

     D  BPT            S              1N

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
     D  ##SHIN                 1     12
     D  SHN1                   1      5
     D  SHN2                   6     10
     D  SHN3                  11     12

     D  ##LOT          S              5
     D  K#LOT          S             11
     D  ##HEAT         S              6
     D  ##MDY          S               D   inz(*SYS) datfmt(*usa)               system date (date)
     D  ##MDY80        S              8  0

     C     *Entry        PLIST
     C                   Parm                    @WKCD             6
     C                   Parm                    @LOTN             8
     C                   Parm                    @MATL            15
     C                   Parm                    @SHIN            12
     C                   Parm                    @SERL            12
     C                   Parm                    @LBLN             8
     C                   Parm                    @OUTQ            10

     C     FCEKey        KList
     C                   KFld                    SHN1
     C                   KFld                    SHN2
     C                   KFld                    SHN3

      **------------------------------------------------------------------------
      *          M a i n   P r o c e s s i n g
      **------------------------------------------------------------------------

     C                   Time                    WSDT
     C                   Move      ##MDY         ##MDY80
     C                   Eval      ##SHIN = @SHIN

     C                   If        @OUTQ  = *blanks
     C                   Eval      LblDev = 'QPRINT'
     C                   Else
     C                   Eval      LblDev = @OUTQ
     C                   EndIf

     C                   If        @LBLN  = *blanks
     C                   Eval      LblNam = 'LOTID'
     C                   Else
     C                   Eval      LblNam = @LBLN
     C                   EndIf

     C                   If        %subst(@LOTN:1:1) = 'R'
     C                   Eval      BPT = *On
     C                   Eval      LTSUNM = 'ASJ'
     C                   EndIf

     C     FCEKey        Chain     FCEPL01

     C                   Exsr      $GetData
     C                   Eval      LTISDT = %char(%editw(##MDY80:'  /  /    '))
     C                   Eval      LTLOTB = @LOTN
     C                   Eval      LTLOTH = %subst(@LOTN:1:5) + '-' +
     C                             %subst(@LOTN:6:2) + '-' + %subst(@LOTN:8:1)
     C                   Eval      LTQANO = %subst(@LOTN:1:7) + '-'
     C                   Exsr      $WrtAudit

     C                   If        %found(FCEPL01)                              found in part master
     C                   If        *In50 = *Off OR BPT = *On                    and in wire scan fil
     C                   Exsr      $OvrSR
     C                   Exsr      $LabelSR
     C                   EndIf

     C                   EndIf

     C                   Eval      *InLR = *On
     C                   Return

      *-------------------------------------------------------------------------
      *          Get Data from Wire Scan File for Lot Id Tag to be Printed...
      *-------------------------------------------------------------------------
     C     $GetData      Begsr

     C                   Eval      ##LOT = %subst(@LOTN:1:5)
     C                   Eval      K#LOT = ##LOT

     C     K#LOT         SetLL     IZAPL61
     C     K#LOT         ReadE     IZAPL61                                50

     C                   DoW       *In50 = *Off

     C                   If        I6ZAIS = @MATL and I6ZAIK = A2SAIZ and
     C                             I6SUPP = A2SIRE
      *              for audit record...
     C                   Eval      ##HEAT = I6CHNO

      *              for lot tag print...  (merge data)
     C                   Eval      LTHEAT = ##HEAT
     C                   Eval      LTMATL = @MATL
     C                   Eval      LTDIAM = I6ZAIK
      ****            get supplier name...
     C     I6SUPP        Chain     FGBPL01                            51
     C                   If        *In51 = *Off
     C                   Eval      LTSUNM = B2SMEI
     C                   EndIf

     C                   Leave
     C                   EndIf

     C     K#LOT         ReadE     IZAPL61                                50
     C                   EndDo

     C                   Endsr

      *-------------------------------------------------------------------------
      *          Write Lot Id Tag data to Audit File...
      *-------------------------------------------------------------------------
     C     $WrtAudit     Begsr

     C                   Eval      ADSCDT = WSDATE
     C                   Eval      ADSCTM = WSTIME
     C                   Eval      ADWKCD = @WKCD
     C                   Eval      ADUSER = #USER
     C                   Eval      ADLOTN = @LOTN
     C                   Eval      ADMATL = @MATL
     C                   Eval      ADSHIN = @SHIN
     C                   Eval      ADDIAM = I6ZAIK
     C                   Eval      ADSUPP = I6SUPP
     C                   Eval      ADSERL = @SERL
     C                   Eval      ADHEAT = ##HEAT
     C                   Write     ALHPP111R
     C                   Clear                   ALHPP111R

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

      *Library List
      *********          Monitor
      *********          Eval      Cmd = 'ADDLIBLE TLABARCODE'
      *********          Call      'QCMDEXC'
      *********          Parm                    Cmd             120
      *********          Parm                    CmdLen           15 5
      *********          On-Error
      *********          EndMon
      *
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

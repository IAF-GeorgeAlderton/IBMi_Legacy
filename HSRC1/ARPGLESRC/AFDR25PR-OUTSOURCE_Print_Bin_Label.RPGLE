      *
      *-------------------------------------------------------------------------
      *
      *   Pgm Name:  AFDR25PR
      *   Description:  OUTSOURCE - Print Bin Label
      *
      *   Created By:    LEC
      *   Creation Date: 08/12/2021
      *
      *-------------------------------------------------------------------------
      *   B a r c o d e 4 0 0   P a r a m e t e r s
      *-------------------------------------------------------------------------
     D  LblNam         S              8
     D  Across         S              2P 0 inz(01)
     D  LblDev         S             10
     D  LblQty         S              4P 0
     D  Demand         S              1
     D  Perset         S              4P 0 inz(0001)


      *-------------------------------------------------------------------------
      *   V a r i a b l e   D a t a
      *-------------------------------------------------------------------------
     D  MrgDta         DS          4096
     D   LBLBIN             0001   0003


     C     *Entry        PLIST
     C                   Parm                    ##BIN             3
     C                   Parm                    ##LBNM            8
     C                   Parm                    ##OUTQ           10
     C                   Parm                    ##QTY             3 0
     C                   Parm                    ##DMND            1
      *
      **------------------------------------------------------------------------
      *          M a i n   P r o c e s s i n g
      **------------------------------------------------------------------------
      *
     C                   Eval      LBLBIN = ##BIN
     C                   Eval      LblNam = ##LBNM
     C                   Eval      LblDev = ##OUTQ
     C                   Eval      LblQty = ##QTY
     C                   Eval      Demand = ##DMND

     C                   exsr      $OvrSR
     C                   exsr      $LabelSR

      *Library List
     C                   Monitor
     C                   Eval      Cmd = 'RMVLIBLE TLABARCODE'
     C                   Call      'QCMDEXC'
     C                   Parm                    Cmd              80
     C                   Parm                    CmdLen           15 5
     C                   On-Error
     C                   EndMon

     C                   Eval      *InLR = *on
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
     C                   Eval      CmdLen = 80

      *Library List
     C                   Monitor
     C                   Eval      Cmd = 'ADDLIBLE TLABARCODE'
     C                   Call      'QCMDEXC'
     C                   Parm                    Cmd              80
     C                   Parm                    CmdLen           15 5
     C                   On-Error
     C                   EndMon

      *Override Prtf
     C                   Monitor
     C                   Eval      Cmd = 'OVRPRTF FILE(BCLABELS) +
     C                             OUTQ('+ %TRIM( LblDev ) + ') +
     C                             FORMTYPE(*STD) OVRSCOPE(*CALLLVL)'

     C                   Call      'QCMDEXC'
     C                   Parm                    Cmd              80
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

     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO) DFTACTGRP(*NO)
      //------------------------------------------------------------------------
      //
      // Label Name:     AM#R44E
      // Description:    Print Expedite Truck Tickets sequentially in reverse order.
      //
      // Created By:     lec
      // Creation Date:  02/03/2021
      //
      //------------------------------------------------------------------------
     FAM#PW44E  CF   E             WORKSTN
     FAM#PP00   UF   E           K DISK

     D  ERR            S             60    DIM(2) CTDATA PERRCD(1)

      //------------------------------------------------------------------------
      // B a r c o d e 4 0 0   P a r a m e t e r s
      //------------------------------------------------------------------------
     D  LblNam         S              8    inz('EXPDTT')
     D  Across         S              2P 0 inz(01)
     D  LblDev         S             10
     D  LblQty         S              4P 0 inz(0001)
     D  Demand         S              1    inz('N')
     D  Perset         S              4P 0 inz(0001)

      //------------------------------------------------------------------------
      // V a r i a b l e   D a t a
      //------------------------------------------------------------------------
     D  MrgDta         DS          4096
     D   TTSURT             0001   0009

     D  EndSeq#        S                   like(D0VALU)
     D  Key00          S             10    inz('EXPDTT')

       //-----------------------------------------------------------------------
       //        M a i n   P r o c e s s i n g
       //-----------------------------------------------------------------------

     C                   DoU       *In01 = *On

     C                   ExFmt     DSP01
     C                   Eval      XMSG = *blanks
     C                   Eval      *In41 = *Off
     C                   Eval      *In42 = *Off

     C                   If        NUMTT <= *zero OR NUMTT > 100
     C                   Eval      XMSG = Err(1)
     C                   Eval      *In41 = *On
     C                   Iter
     C                   EndIf

     C                   If        PRTR < 7 OR PRTR > 10 OR
     C                             PRTR = 8
     C                   Eval      XMSG = Err(2)
     C                   Eval      *In42 = *On
     C                   Iter
     C                   Else
     C                   Eval      LblDev = 'BP' +
     C                             %subst(%char(%editc(PRTR:'X')):1:2)
     C                   EndIf

     C                   If        *In05 = *On
     C                   Exsr      $OvrSR
     C                   Exsr      Print
     C                   Leave
     C                   EndIf

     C                   EndDo

     C                   Eval      *InLR =*On
     C                   Return

      ***************************************************************************
      *          Override Barcode400 Printer File
      *
     C     $OvrSR        Begsr
     C                   Eval      CmdLen = 80

      *   Override Prtf
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
      ******************************************************************************

      * Print the number of requested new Expedite Truck Tickets
     C     Print         BegSr

     C                   Exsr      GetSeq#

     C                   Do        NUMTT

      * create Expedite Route Name
     C                   Eval      TTSURT =  'EX-' +
     C                             %subst(%char(%editc(EndSeq#:'X')):2:4)

      * print truck ticket
     C                   Exsr      CallPgm

     C                   Eval      EndSeq# -= 1
     C                   EndDo

      * release spool file to print and close the program...
     C                   Eval      Demand = 'Y'
     C                   Eval      LblQty = *zero
     C                   Eval      PerSet = *zero
     C                   Exsr      CallPgm

     C                   EndSr
      ******************************************************************************
      *    Get the ending sequence # from the control file...

     C     GetSeq#       BegSr

      *    so the last one can print first.... in reverse order.
     C     Key00         Chain     AM#PP00
     C                   If        %found(AM#PP00)
     C                   Eval      D0VALU += NUMTT
     C                   Eval      EndSeq# = D0VALU
     C                   If        D0VALU >= 10000
     C                   Eval      D0VALU -= 10000
     C                   EndIf
     C                   Update    AM#PP001
     C                   EndIf

     C                   EndSr
      ******************************************************************************
      *    call the print driver pgm to print the truck ticket...

     C     CallPgm       BegSr

     C                   Call      'Z7XI4096'
     C                   Parm                    Lblnam
     C                   Parm                    Across
     C                   Parm                    Lbldev
     C                   Parm                    Lblqty
     C                   Parm                    Demand
     C                   Parm                    Mrgdta
     C                   Parm                    Perset

     C                   EndSr
      ******************************************************************************
       //******************************************************************
       //           P a r a m e t e r    N o t e s :
       //******************************************************************
       //
       //  LBLQTY  PERSET
       //
       //    If your label has an INCREMENTING #:
       //      -The "LblQty" becomes the number of "SETS" of labels.
       //      -The "Perset" filed becomes the number of labels Per Set.
       //
       //    If your label DOES NOT HAVE AN INCREMENTING #:
       //      -LblQty = label quantity field;
       //      -Perset = 1;
       //
       //       FOR EXAMPLE:  You may want two sets of labels, each set
       //       containing five labels(1 of 5, 2 of 5,.....)
       //            LblQty = 2;
       //            Perset = 5;
       //-----------------------------------------------------------------
       //  DEMAND
       //
       //   "D"  Close the spool file but leave the program and Barcode400
       //        files open.
       //        Labels print IMMEDIATELY.
       //        All Barcode400 Files are open in memory and are not closed
       //        until a "Y" is passed to the program.
       //
       //   "Y"  Close program, as a result the spool file closes.
       //        Labels print IMMEDIATELY.
       //
       //   "N"  Leave the spool file, program, and Barcode400 files open.
       //        LABELS ARE ACCUMULATED IN SPOOL FILE.
       //        Spool file, program, and program files will not close
       //        until a "Y" is passed to the program.
       //-----------------------------------------------------------------
       //  LblNam
       //
       //     This is the name of the label you wish to print.
       //-----------------------------------------------------------------
       //  Across
       //
       //     Number of labels across the form.
       //------------------------------------------------------------------
       //  MrgDta
       //
       //     Data structure(above) containing variable data to be printed
       //     on the label.
       //------------------------------------------------------------------
       //  LblDev
       //
       //     Name of "OUTQ" (e.g...P1, P2, QPRINT)
       //     This entry WILL NOT RE-DIRECT the output, it is used by the
       //     label print program to determine how the data should be sent
       //     to the printer.
       //------------------------------------------------------------------
** ERR
Enter Qty between 1 - 100
Valid options are 07, 09, or 10

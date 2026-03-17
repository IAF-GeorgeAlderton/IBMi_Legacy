     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO) DFTACTGRP(*NO)
      //------------------------------------------------------------------------
      //
      // Label Name:     AM#R413
      // Description:    Determine Send Method for TSCS Skid Build and Send.
      //
      // Created By:     lec
      // Creation Date:  03/12/2021
      //
      //------------------------------------------------------------------------
     FAB#PPCT   IF   E           K DISK

     D  Key1           S              8    inz('TSCS')
     D  Key2           S              8    inz('SKID')

     C     *Entry        PList
     C                   Parm                    MFBC             50
     C                   Parm                    WKCD              6

     C     KeyCT         KList
     C                   KFld                    Key1
     C                   KFld                    Key2

       //-----------------------------------------------------------------------
       //        M a i n   P r o c e s s i n g
       //-----------------------------------------------------------------------

     C     KeyCT         Chain     AB#PPCT
     C                   If        %found
     C                   Select
     C                   When      CTCHR2 = 'AS400'
     C                   Call      'AM#C29'
     C                   Parm                    MFBC
     C                   Parm                    WKCD
     C                   When      CTCHR2 = 'OA2'
     C                   Call      'AM#C29OA2'
     C                   Parm                    MFBC
     C                   Parm                    WKCD
     C                   Parm      'MPTOKEN'     TKID             20
     C                   When      CTCHR2 = 'SKIP'
      *               skip it, don't send
     C                   Other
     C                   Call      'AM#C29'
     C                   Parm                    MFBC
     C                   Parm                    WKCD
     C                   EndSl
     C                   EndIf

     C                   Eval      *InLR =*On
     C                   Return

      ******************************************************************************

     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO) DFTACTGRP(*NO)
      //------------------------------------------------------------------------
      //
      // Label Name:     AM#R415
      // Description:    Determine Send Method for TSCS Trailer Build Resend
      //
      // Created By:     lec
      // Creation Date:  08/26/2025
      //
      //------------------------------------------------------------------------
     FAB#PPCT   IF   E           K DISK

     D  Key1           S              8    inz('TSCS')
     D  Key2           S              8    inz('TRAILER')

     C     *Entry        PList
     C                   Parm                    WKCD              6
     C                   Parm                    TT               25

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
     C                   Call      'AM#C28Z'
     C                   Parm                    WKCD
     C                   Parm                    TT
     C                   When      CTCHR2 = 'OA2'
     C                   Call      'AM#C28ZOA2'
     C                   Parm                    WKCD
     C                   Parm                    TT
     C                   When      CTCHR2 = 'SKIP'
      *               skip it, don't send
     C                   Other
     C                   Call      'AM#C28Z'
     C                   Parm                    WKCD
     C                   Parm                    TT
     C                   EndSl
     C                   EndIf

     C                   Eval      *InLR =*On
     C                   Return

      ******************************************************************************

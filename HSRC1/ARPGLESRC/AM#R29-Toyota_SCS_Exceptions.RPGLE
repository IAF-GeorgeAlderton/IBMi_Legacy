     H DATEDIT(*YMD/)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
      ******** AM#R29 *******************************************
      * Toyota SCS Exceptions Selection
      * -----------------------------------------
      * LEC   2019/06/25
      ************************************************************
     FAM#PW29   CF   E             WORKSTN
     F                                     SFILE(SFL01:RRN1)
     F                                     INFDS(@INFDS)
     FAM#PP00   IF   E           K DISK
      *
     D @INFDS          DS
     D  @@REC                378    379B 0
     D                SDS
     D  #PGM                   1      8
     D  #WSID                244    253
     D  #USER                254    263

     D RRN1            S              6S 0
     D @@ID            S              2
     D PEXCD           S              3
     D PEXTY           S             30
      * ----------------------------------------------------
      *          M  A  I  N  L  I  N  E
      *
     C     *Entry        PList
     C                   Parm                    PEXCD
     C                   Parm                    PEXTY
      *--------------------------------------------------
     C                   Eval      @@ID = '01'
     C                   Exsr      #SET1
      *
     C                   DoU       @@ID = '99'
      *
     C     @@ID          CASEQ     '01'          #SCRN1
     C                   ENDCS
      *
     C                   EndDo
      *
     C                   Eval      *InLR = *on
     C                   Return
      *--------------------------------------------------
      *  Set Screen 1 subfile.
      *--------------------------------------------------
      *
     C     #SET1         BegSr
      *
     C                   Eval      PEXCD = *blanks
     C                   Eval      PEXTY = *blanks
      *
     C                   Eval      *IN61 = *on
     C                   Write     CTL01
     C                   Eval      *IN61 = *off
     C                   Eval      *IN62 = *off
      *
     C                   Eval      RRN1 = *zero
      ***                Eval      D@MSG = *blanks
     C                   Eval      *In98 = *Off
      *
     C     *LoVal        SetLL     AM#PP00
      *
     C                   DoU       *In90 =  *On
      *
     C                   Read      AM#PP00                                90
     C   90              Leave
      *
     C                   If        %subst(D0KEY:1:4) = 'EXCD'
     C                   Eval      RRN1 += 1
     C                   Clear                   SFL01
     C                   Eval      S1SEL   =  *blank
     C                   Eval      S1EXCD  =  %char(D0VALU)
     C                   Eval      S1EXTY  =  D0TXT
     C                   Write     SFL01
     C                   EndIf
      *
     C                   EndDo
      *
     C                   If        RRN1  = *zero
     C                   Eval      *IN98 = *on
     C                   EndIf
      *
     C                   Eval      W@REC1 = 1
      *
     C                   EndSr
      *--------------------------------------------------
      * Display Screen 1    -   Subfile1
      *
     C     #SCRN1        BegSr
      *
     C                   WRITE     DSP99
     C                   Z-ADD     W@REC1        #RCNO1
     C                   EXFMT     CTL01
      *
     C     @@REC         IFNE      *ZERO
     C                   Z-ADD     @@REC         W@REC1            4 0
     C                   ELSE
     C                   Z-ADD     1             W@REC1
     C                   ENDIF
      *
     C                   SELECT
     C     *INKA         WHENEQ    *ON
     C                   MOVE      '99'          @@ID
     C                   OTHER
     C                   EXSR      #CHK1
     C                   ENDSL
      *
     C                   EndSr
      *--------------------------------------------------
      * Check Screen 1 for a selection made...
      *--------------------------------------------------
      *
     C     #CHK1         BegSr
      *
     C                   Eval      RRN1 = *zero
      *
     C                   Do        *HiVal
      *
     C                   Eval      RRN1 += 1
      *
     C     RRN1          Chain     SFL01
      *
     C                   If        NOT %found
     C                   Leave
     C                   EndIf
      *
     C                   If        S1SEL = *blank
     C                   Iter
     C                   EndIf
      *
     C                   Eval      PEXCD = S1EXCD
     C                   Eval      PEXTY = S1EXTY
     C                   Eval      @@ID  = '99'
      *
     C                   LeaveSr

     C                   EndDo
      *
     C                   EndSr
      *--------------------------------------------------

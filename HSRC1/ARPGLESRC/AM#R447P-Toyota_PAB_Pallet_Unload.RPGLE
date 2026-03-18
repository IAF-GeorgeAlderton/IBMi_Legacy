     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO) DFTACTGRP(*NO)
     F***************************************************
     F*  TOYOTA PRODUCTION ANALYSIS BOARD               *
     F*  PALLET UNLOAD                                  *
     F*                                                 *
     F*  LEC   2020.04.03                               *
     F***************************************************
     FAM#PW46P  CF   E             WORKSTN maxdev(*FILE)
     FAM#WP446P IF   E           K DISK
     FAM#WP446A IF   E           K DISK
      *------------------------------------------------------------

     D                SDS
     D  #PGM                   1     10
     D  #WSID                244    253
     D  #USER                254    263
      *
     C     *ENTRY        PLIST
     C                   PARM                    PCMD              1
      *
      *------------------------------------------------------------
      *  M   A   I   N   L   I   N   E
      *------------------------------------------------------

      *  from plan workfile...
     C                   Eval      D@SHFT   = W1SHIFT
     C                   Eval      D@QTR    = W1QTR
     C                   Eval      D@SSDAT  = W1SSDAT
     C                   Eval      D@SEDAT  = W1SEDAT
     C                   Eval      D@QSDAT  = W1QSDAT
     C                   Eval      D@QEDAT  = W1QEDAT
     C                   Eval      D@SSTIM  = W1SSTIM
     C                   Eval      D@SETIM  = W1SETIM
     C                   Eval      D@QSTIM  = W1QSTIM
     C                   Eval      D@QETIM  = W1QETIM

     C                   Eval      D@QPQTY  = W1QPQTY
     C                   Eval      D@SPQTY  = W1SPQTY
     C                   Eval      D@TRGT   = W1STQTY

      * calculate pace for quarter = qtr target qty / (qtr mins x 60)
     C                   Eval      D@PACE = (W1QMINS * 60) / W1QTQTY

      *  from actual workfile...
     C                   Eval      D@QAQTY  = W2QAQTY
     C                   Eval      D@SAQTY  = W2TAQTY

      *  calculate gap quantities = actual - plan...
     C                   Eval      D@QGQTY  = W2QAQTY - W1QPQTY
     C                   Eval      D@SGQTY  = W2TAQTY - W1SPQTY

     C                   If        D@QGQTY < *zero
     C                   Eval      *In71 = *On
     C                   EndIf

     C                   If        D@SGQTY < *zero
     C                   Eval      *In72 = *On
     C                   EndIf

     C                   Write     DSP01
     C                   Read(E)   AM#PW46P

     C                   Eval      PCMD = *In01

     C                   Eval      *InLR = *On
     C                   Return
      *------------------------------------------------------
      *  Initialize
      *------------------------------------------------------
     C     *INZSR        BEGSR

     C                   Read      AM#WP446P
     C                   Read      AM#WP446A

     C                   ENDSR
      *------------------------------------------------------

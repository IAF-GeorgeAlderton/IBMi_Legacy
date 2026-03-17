     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO) DFTACTGRP(*NO)
     F** AM#R446S ************************************
     F* Toyota PAB - Shipping
     F*      LEC            2020.04.10               *
     F************************************************
     FAM#PW46S  CF   E             WORKSTN MAXDEV(*FILE)
     F                                     SFILE(SFL:RRN)
     F                                     INFDS(INFDS)
     FAM#WP446P IF   E           K DISK
     FAM#WL446S IF   E           K DISK
     FAM#PP31   IF   E           K DISK
      *
     D                SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D  W#JBNO               264    269
      *
     D INFDS           DS
     D  #CUR                 370    371B 0
     D  #POS                 378    379B 0
     D  MJCODE               401    402
     D  MJCOD4               401    404
     D  @STTS            *STATUS
     D  RRN            S              6  0
     D  CTRX           S              6  0
     D  DSPSW          S              2
     D  WKCD           S              6  0
     D  Cur_DTTM       S               Z
     D  L_S_DTTM       S               Z
     D                 DS
     D  DT                     1      8  0
     D  TM                     9     14  0
     D  microsecs             15     20  0 inz(0)
     D  DTTM                   1     20  0

      *----------------------------------------------------*
      * PLIST                                              *
      *----------------------------------------------------*
     C     *Entry        PList
     C                   Parm                    PCmd              1
      *----------------------------------------------------*
      *   K  E  Y   L  I  S  T                             *
      *----------------------------------------------------*
      *
      *----------------------------------------------------*
      * CONTROL                                            *
      *----------------------------------------------------*
     C                   Exsr      #SB100
     C                   DoU       DSPSW = '99'
     C                   Exsr      #SB200
     C                   EndDo
     C                   Exsr      #SB300
      *----------------------------------------------------*
      * Initialize                                         *
      *----------------------------------------------------*
     C     #SB100        BegSr

     C                   Read      AM#WP446P
      *
     C     *LoVal        SetLL     AM#WL446S

     C                   Eval      PCmd = *Blank
     C                   Eval      DSPSW = '01'
     C                   Eval      S#PGM = W#PGM
     C                   Eval      C1DATE = W1CDATE
     C                   Eval      C1TIME = W1CTIME

      ***  current date/time
     C                   Eval      DT = W1CDATE
     C                   Eval      TM = W1CTIME
     C                   Eval      Cur_DTTM = %timestamp(DTTM)

     C                   Eval      T1SELT = W1STSEL
     C                   EndSr
      *----------------------------------------------------*
      * Accumulate Totals for Actual Qtys                  *
      *----------------------------------------------------*
     C     AccumTotls    BegSr

     C                   Eval      T1QACT += S1QACT
     C                   Eval      T1TACT += S1TACT

     C                   EndSr
      *----------------------------------------------------*
      * MAIN                                               *
      *----------------------------------------------------*
     C     #SB200        BegSr

     C                   DoW       DSPSW = '01'
     C                   Exsr      #SB210
     C                   EndDo

     C                   DoW       DSPSW = '02'
     C                   Exsr      #SB220
     C                   EndDo

     C                   EndSr
      *----------------------------------------------------*
      * Clear and Fill Subfile                             *
      *----------------------------------------------------*
     C     #SB210        BegSr


     C                   Eval      *In66 = *Off
     C                   Read      AM#WL446S                              81

     C                   Exsr      #CLR

     C                   DoW       *In81 = *Off and *In66 = *Off

     C                   Eval      S1TMNM = W2WKNM

     C                   Eval      WKCD = %dec(W2WKCD:6:0)
     C     WKCD          Chain     AM#PP31
     C                   If        (%found(AM#PP31) and R3PGM1 = '1') OR
     C                             WKCD = *zero
     C                   Eval      S1QPLN = *zero
     C                   Eval      S1TPLN = *zero
     C                   Else
     C                   Eval      S1QPLN = W1QPQTY
     C                   Eval      S1TPLN = W1SPQTY
     C                   EndIf

      ***  if TM has not pulled in the last hour, keep actual but drop planned amounts...
     C                   Eval      DT = W2LSCDT
     C                   Eval      TM = W2LSCTM
     C                   Eval      microsecs = *zero
     C                   Eval      L_S_DTTM = %timestamp(DTTM)
     C                   If        %diff(Cur_DTTM: L_S_DTTM: *mn) > 60
     C                   Eval      S1QPLN = *zero
     C                   Eval      S1TPLN = *zero
     C                   EndIf

     C                   Eval      S1QACT = W2QTQTY
     C                   Eval      S1QGAP = S1QACT - S1QPLN

     C                   If        S1QGAP < *zero
     C                   Eval      *In31 = *On
     C                   Else
     C                   Eval      *In31 = *Off
     C                   EndIf

     C                   Eval      S1TACT = W2STQTY
     C                   Eval      S1TGAP = S1TACT - S1TPLN

     C                   If        S1TGAP < *zero
     C                   Eval      *In32 = *On
     C                   Else
     C                   Eval      *In32 = *Off
     C                   EndIf

     C                   Eval      RRN += 1
     C                   Eval      @RRN += 1
     C                   Eval      CTRX += 1
     C                   Write     SFL

     C                   Exsr      AccumTotls

     C                   If        CTRX = 16
     C                   Eval      *In66 = *On
     C                   Leave
     C                   EndIf

     C                   Read      AM#WL446S                              81
     C                   EndDo

     C                   Eval      T1QPLN = W1QPQTY * W1STSEL
     C                   Eval      T1TPLN = W1SPQTY * W1STSEL
     C                   Eval      T1QGAP = T1QACT - T1QPLN
     C                   Eval      T1TGAP = T1TACT - T1TPLN

     C                   If        T1QGAP < *zero
     C                   Eval      *In41 = *On
     C                   Else
     C                   Eval      *In41 = *Off
     C                   EndIf

     C                   If        T1TGAP < *zero
     C                   Eval      *In42 = *On
     C                   Else
     C                   Eval      *In42 = *Off
     C                   EndIf

     C                   Eval      DSPSW ='02'

     C                   EndSr
      *----------------------------------------------------*
      * Display Subfile.                                   *
      *----------------------------------------------------*
     C     #SB220        BegSr

     C                   If        CTRX = *zero
     C                   Eval      *In72 = *On
     C                   Eval      *In99 = *On
     C                   Write     DSP99                                92
     C                   Else
     C                   Eval      *In72 = *On
     C                   Eval      *In73 = *On
     C                   Write     Totals                               92
     C                   Write     SFLCTL                               92
     C                   EndIf

     C                   Read      AM#PW46S                             9898

     C                   SetOff                                       7273
     C                   SetOff                                       99
     C                   If        *In98 = *On and @STTS = 1331
     C                   If        *In81 = *On
     C                   Eval      DSPSW = '99'
     C                   Else
     C                   Eval      DSPSW = '01'
     C                   EndIf
     C                   EndIf
      * F1 - End program
     C                   If        *In01 = *On
     C                   Eval      PCmd = *On
     C                   Eval      DSPSW = '99'
     C                   EndIf
      * F5 - Refresh
     C                   If        *In05 = *On
     C                   Eval      PCmd = *Off
     C                   Eval      DSPSW = '99'
     C                   EndIf

     C                   EndSr
      *----------------------------------------------------*
      * End Program                                        *
      *----------------------------------------------------*
     C     #SB300        BegSr

     C                   Eval      *InLR = *On
     C                   Return

     C                   EndSr
      *----------------------------------------------------*
      * Clear Subfile                                      *
      *----------------------------------------------------*
     C     #CLR          BegSr

     C                   Eval      *In71 = *On
     C                   Write     SFLCTL
     C                   Eval      *In71 = *Off
     C                   Eval      *In66 = *Off
     C                   Eval      RRN  = *zero
     C                   Eval      @RRN = *zero
     C                   Eval      CTRX = *zero
     C                   Eval      @SFRC1 = 1

     C                   EndSr
      *----------------------------------------------------*

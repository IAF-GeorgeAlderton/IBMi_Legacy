     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO) DFTACTGRP(*NO)
     F** AM#R446C ************************************
     F* Toyota PAB - Consolidate TL/Dock/Cover TMs   *
     F*      LEC            2020.06.26               *
     F************************************************
     FAM#WP446P IF   E           K DISK
     FAM#WL446S UF A E           K DISK
     FAM#PP31   IF   E           K DISK
      *
     D                SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D  W#JBNO               264    269
      *
     D  WKCD           S              6  0
     D  Cur_DTTM       S               Z
     D  L_S_DTTM       S               Z
     D  TotlQACT       S              5  0
     D  TotlTACT       S              5  0
     D                 DS
     D  DT                     1      8  0
     D  TM                     9     14  0
     D  microsecs             15     20  0 inz(0)
     D  DTTM                   1     20  0

      *----------------------------------------------------*
      * M  A  I  N    P  R  O  C  E  S  S                  *
      *----------------------------------------------------*
      ***  get current date/time from "plan" work file...
     C                   Read      AM#WP446P
     C                   If        not %eof
     C                   Eval      DT = W1CDATE
     C                   Eval      TM = W1CTIME
     C                   Eval      Cur_DTTM = %timestamp(DTTM)
     C                   EndIf

      ** process the "actual" data work file, consolidate if TL, Dock ...
     C     *LoVal        SetLL     AM#WL446S

     C                   DoW       NOT %eof(AM#WL446S)

     C                   Read      AM#WL446S

     C                   If        %eof(AM#WL446S)
     C                   Leave
     C                   EndIf

      ***  if TM has not pulled in the last hour, add their qty into consolidated profile...
     C                   Eval      DT = W2LSCDT
     C                   Eval      TM = W2LSCTM
     C                   Eval      microsecs = *zero
     C                   Eval      L_S_DTTM = %timestamp(DTTM)
     C                   If        %diff(Cur_DTTM: L_S_DTTM: *mn) > 60
     C                   Eval      TotlQACT += W2QTQTY
     C                   Eval      TotlTACT += W2STQTY
     C                   Delete    AM#WP446S1
     C                   Iter
     C                   EndIf

      ***  if worker code is for a TL, Dock worker, password reset TM, consolidate also...
     C                   Eval      WKCD = %dec(W2WKCD:6:0)
     C     WKCD          Chain     AM#PP31
     C                   If        %found(AM#PP31) and R3PGM1 = '1'
     C                   Eval      TotlQACT += W2QTQTY
     C                   Eval      TotlTACT += W2STQTY
     C                   Delete    AM#WP446S1
     C                   EndIf

     C                   EndDo

     C                   If        TotlQACT > *zero OR TotlTACT > *zero
     C                   Eval      W2WKCD = '000000'
     C                   Eval      W2WKNM = '--TL/Dock/Cover'
     C                   Eval      W2QTQTY = TotlQACT
     C                   Eval      W2STQTY = TotlTACT
     C                   Eval      W2LSCDT = W1CDATE
     C                   Eval      W2LSCTM = W1CTIME
     C                   Write     AM#WP446S1
     C                   EndIf

     C                   Eval      *InLR = *On
     C                   Return


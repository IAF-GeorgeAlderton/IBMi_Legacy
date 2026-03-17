     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO)

     FAM#WP446P IF   E           K DISK
     FAB#PL65D  IF   E           K DISK
     FALBPL30   IF   E           K DISK
     FAM#WP446S UF A E           K DISK

     D                SDS
     D  #PGM                   1     10
     D  #USER                254    263

     D  QtrQty         S              6  0
     D  TotQty         S              6  0
     D  SysDTTM        S             14  0
     D  QtrStrDTTM     S             14  0
     D  QtrEndDTTM     S             14  0
     D  ShfStrDTTM     S             14  0
     D  ShfEndDTTM     S             14  0
     D  ScanDTTM       S             14  0

     D                 DS
     D  DT                     1      8  0
     D  TM                     9     14  0
     D  DTTM                   1     14  0

     C     Key65         KLIST
     C                   KFLD                    W1SSDAT
     C                   KFLD                    W1SSTIM

      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------

     C                   Exsr      #Init

      *  process shipping pull scan file... starting at shift start date/time...
     C     Key65         SetLL     AB#PL65D
     C                   Do        *HiVal
     C                   Read      AB#PL65D

     C                   If        %eof
     C                   Leave
     C                   EndIf

      *  if not Toyota customer code, then ignore record...
     C                   If        (A6TOKU <> 3411 and A6TOKU <> 3423) Or
     C                             A6SKJY <> ' '
     C                   Iter
     C                   EndIf

      *  scan date/time...
     C                   Eval      DT = A6SCDT
     C                   Eval      TM = A6SCTM
     C                   Eval      ScanDTTM = DTTM

      *  if scan date/time is beyond current system date/time, then stop accumulation...
     C                   If        ScanDTTM > SysDTTM
     C                   Leave
     C                   EndIf

     C     A6WKCD        Chain     AM#WP446S

      *  accumulate quarter quantity...
     C                   If        ScanDTTM >= QtrStrDTTM and
     C                             ScanDTTM <= QtrEndDTTM
     C                   Eval      W2QTQTY += 1
     C                   EndIf

      *  accumulate shift quantity...
     C                   If        ScanDTTM >= ShfStrDTTM and
     C                             ScanDTTM <= ShfEndDTTM
     C                   Eval      W2STQTY += 1
     C                   EndIf

      *  save last scan date and time...
     C                   Eval      W2LSCDT =  A6SCDT
     C                   Eval      W2LSCTM =  A6SCTM

      *  update shipping pull PAB workfile...Actual
     C                   If        %found(AM#WP446S)
     C                   Update    AM#WP446S1
     C                   Else
     C                   Eval      W2WKCD = A6WKCD
     C                   Eval      ALWKCD    = %dec(A6WKCD:6:0)
     C     ALWKCD        Chain     ALBPL30
     C                   If        %found
     C                   Eval      W2WKNM = ALWKNM
     C                   EndIf
     C                   Write     AM#WP446S1
     C                   EndIf

     C                   Clear                   AM#WP446S1
     C                   EndDo

     C                   Eval      *InLR = *On
     C                   Return
      *----------------------------------------------------------------
      *  Initialization
      *----------------------------------------------------------------
      *
     C     #Init         BegSr

      *  get current planned information...
     C                   Read      AM#WP446P
     C                   If        %eof
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf

      *  current system date/time...
     C                   Eval      DT = W1CDATE
     C                   Eval      TM = W1CTIME
     C                   Eval      SysDTTM = DTTM

      *  current shift start date/time...
     C                   Eval      DT = W1SSDAT
     C                   Eval      TM = W1SSTIM
     C                   Eval      ShfStrDTTM = DTTM

      *  current shift end date/time...
     C                   Eval      DT = W1SEDAT
     C                   Eval      TM = W1SETIM
     C                   Eval      ShfEndDTTM = DTTM

      *  current quarter start date/time...
     C                   Eval      DT = W1QSDAT
     C                   Eval      TM = W1QSTIM
     C                   Eval      QtrStrDTTM = DTTM

      *  current quarter end date/time...
     C                   Eval      DT = W1QEDAT
     C                   Eval      TM = W1QETIM
     C                   Eval      QtrEndDTTM = DTTM

     C                   EndSr
      *----------------------------------------------------------------

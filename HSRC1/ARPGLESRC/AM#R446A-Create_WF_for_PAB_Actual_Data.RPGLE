     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO)

     FAM#WP446P IF   E           K DISK
     FAM#PL45   IF   E           K DISK
     FAM#WP446A O  A E           K DISK

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

     C     Key45         KLIST
     C                   KFLD                    W1SSDAT
     C                   KFLD                    W1SSTIM

      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------

     C                   Exsr      #Init

      *  process pallet return scan file... starting at shift start date/time...
     C     Key45         SetLL     AM#PL45
     C                   Do        *HiVal
     C                   Read      AM#PL45

     C                   If        %eof
     C                   Leave
     C                   EndIf

      *  scan date/time...
     C                   Eval      DT = D1SSHZ
     C                   Eval      TM = D1SSTI
     C                   Eval      ScanDTTM = DTTM

      *  if scan date/time is beyond current system date/time, then stop accumulation...
     C                   If        ScanDTTM > SysDTTM
     C                   Leave
     C                   EndIf

      *  accumulate quarter quantity...
     C                   If        ScanDTTM >= QtrStrDTTM and
     C                             ScanDTTM <= QtrEndDTTM
     C                   Eval      QtrQty += 1
     C                   EndIf

      *  accumulate shift quantity...
     C                   If        ScanDTTM >= ShfStrDTTM and
     C                             ScanDTTM <= ShfEndDTTM
     C                   Eval      TotQty += 1
     C                   EndIf

     C                   EndDo

     C                   Eval      W2QAQTY = QtrQty
     C                   Eval      W2TAQTY = TotQty

      *  write to pallet return PAB workfile...Actual
     C                   Write     AM#WP446A1

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

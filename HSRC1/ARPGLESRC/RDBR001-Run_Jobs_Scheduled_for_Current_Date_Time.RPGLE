     H DftActgrp(*No) Option(*SrcStmt:*NoDebugIO) DatFmt(*ISO)
      *-------------------------------------------------------------------------
      *
      *   Label Name:    RDBR001
      *   Description:   Run Jobs Scheduled for Current Day
      *
      *   Created By:    LEC
      *   Creation Date: 01/16/2024
      *
      *-------------------------------------------------------------------------
     FRDBPPCT   IF   E           K DISK
     FRDBPPSC   IF   E           K DISK
     FRDBPPLG   UF A E           K DISK
      *-------------------------------------------------------------------------

     D                SDS
     D  #PGM                   1      8
     D  #WSID                244    253
     D  #USER                254    263

     D                 DS
     D  WSDT                   1     14  0
     D  WSTIME                 1      6  0
     D  WSHHMM                 1      4  0
     D  WSSECS                 5      6  0
     D  WSDATE                 7     14  0

     D  sysDt          S               D   inz(*SYS) datfmt(*iso)
     D  basDt          S               D   inz(D'2000-12-31')                   known sunday
     D  dayWk          S              1  0
     D  schedule       S              1    dim(7)
     D  DelaySecs      S              3  0

     C     *Entry        PList
     C                   Parm                    DelaySecs

     C     LogKey        KList
     C                   KFld                    WSDATE
     C                   KFld                    SCTIME
     C                   KFld                    CTJBNM

     C     SchKey1       KList
     C                   KFld                    CTJBNM
     C                   KFld                    WSHHMM

     C     SchKey2       KList
     C                   KFld                    CTJBNM

      **------------------------------------------------------------------------
      *          M a i n   P r o c e s s i n g
      **------------------------------------------------------------------------

     C                   Time                    WSDT

      *  day of week... 1=mon, 2=tue, 3=wed,.....7=sun
     C                   Eval      dayWk=%rem(%diff(sysDt:basDt:*days):7)
     C                   If        dayWk = *zero
     C                   Eval      dayWk = 7
     C                   EndIf

     C                   Read      RDBPPCT

     C                   DoW       NOT %eof(RDBPPCT)

     C                   MoveA     CTDAYS        Schedule
     C                   If        Schedule(dayWk) = '1' and CTSTAT = 'A'

      * get next scheduled time...
     C     SchKey1       SetLL     RDBPPSC
     C     SchKey2       ReadE     RDBPPSC

     C                   If        NOT %eof(RDBPPSC)
     C
      * check log file...

     C     LogKey        Chain     RDBPPLG


      * if not there, submit job...

     C                   If        NOT %found(RDBPPLG) and SCTIME <= WSHHMM
     C                   Call      'RDBC001'
     C                   Parm                    CTJBNM
     C                   Parm                    CTPGM
     C                   Parm                    CTJOBQ


      * write to log...
     C                   Clear                   RDBPPLG1
     C                   Eval      LGJBNM = CTJBNM
     C                   Eval      LGPGM  = CTPGM
     C                   Eval      LGSCDT = WSDATE
     C                   Eval      LGSCTM = SCTIME
     C                   Eval      LGJOBQ = CTJOBQ
     C                   Eval      LGDATE = WSDATE
     C                   Eval      LGTIME = WSTIME
     C                   Write     RDBPPLG1
     C                   EndIf

     C                   EndIf

     C                   EndIf

     C                   Read      RDBPPCT
     C                   EndDo

     C                   Time                    WSDT
     C                   Eval      DelaySecs = 60 - WSSECS

     C                   Eval      *InLR = *On
     C                   Return

      *-------------------------------------------------------------------------

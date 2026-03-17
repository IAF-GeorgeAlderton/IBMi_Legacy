     H DftActgrp(*No) Option(*SrcStmt:*NoDebugIO) DatFmt(*ISO)
      *-------------------------------------------------------------------------
      *
      *   Label Name:    RDBR003
      *   Description:   Update Job Schedule for Specified Job
      *
      *   Created By:    LEC
      *   Creation Date: 01/25/2024
      *
      *-------------------------------------------------------------------------
     FRDBPPCT   IF   E           K DISK
     FRDBPPSC   UF A E           K DISK
      *-------------------------------------------------------------------------

     D                SDS
     D  #PGM                   1      8
     D  #WSID                244    253
     D  #USER                254    263

     D                 DS
     D  WSDT                   1     14  0
     D  WSTIME                 1      6  0
     D  WSHHMM                 1      4  0
     D  WSDATE                 7     14  0

     D  tm_Next        S               T                                        known sunday
     D  NextCall       S              4S 0                                      next sched time

     C     *Entry        PList
     C                   Parm                    P_JBNM           10

      **------------------------------------------------------------------------
      *          M a i n   P r o c e s s i n g
      **------------------------------------------------------------------------

      * first, delete all schedule records for this job...
     C                   DoU       NOT %found(RDBPPSC)
     C     P_JBNM        Delete    RDBPPSC
     C                   EndDo


     C                   Time                    WSDT

      * get job details from control file...
     C     P_JBNM        Chain     RDBPPCT

     C                   If        %found(RDBPPCT)

     C                   If        CTSTAT = 'A'
     C                   Eval      NextCall = CTFCAL

      * write job schedule records...
     C                   DoW       NextCall <= CTLCAL
     C                   Eval      SCTIME = NextCall
     C                   Eval      SCJBNM = CTJBNM
     C                   Write     RDBPPSC1

     C                   Eval      tm_Next = %time(%dec(NextCall)*100) +
     C                              %minutes(CTFQMN)
     C                   Eval      NextCall = %dec(tm_Next)/100

     C                   If        NextCall > CTLCAL Or CTFCAL = CTLCAL Or
     C                             NextCall = *zero Or NextCall = 2400 Or
     C                             NextCall = CTFCAL
     C                   Leave
     C                   EndIf
     C                   EndDo

     C                   EndIf

     C                   EndIf

     C                   Eval      *InLR = *On
     C                   Return

      *-------------------------------------------------------------------------

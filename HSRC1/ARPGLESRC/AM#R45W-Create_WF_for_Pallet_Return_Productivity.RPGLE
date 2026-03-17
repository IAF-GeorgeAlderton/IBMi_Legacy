     H OPTION(*SRCSTMT : *NODEBUGIO) DATEDIT(*YMD/)

     FAM#PL47   IF   E           K DISK
     FAM#WP45G  O  A E           K DISK

     D                SDS
     D  #PGM                   1     10
     D  XXUSER               254    263

     D  @Hour          S              2  0
     D  SysHour        S              2  0
     D  SaveHour       S              2  0
     D  Count          S              3  0
     D  WrtCount       S              2  0

     C     *ENTRY        PLIST
     C                   PARM                    InWKCD           10
     C                   PARM                    InStDt            8 0
     C                   PARM                    InStTm            6 0

     C     L#47Key       KLIST
     C                   KFld                    InWKCD           10
     C                   KFld                    InStDt            8 0

     C     L#47Key1      KLIST
     C                   KFld                    InWKCD           10

      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------
      *
      * summarize worker pallet count per hour...

     C     L#47Key       Chain     AM#PL47                            90
     C                   Eval      SaveHour = (D1SSTI/10000)

     C                   DoW       *In90 = *Off

      * when hour changes, write pallet count for the hour...
     C                   If        (D1SSTI/10000) <> SaveHour
     C                   Eval      WKHRS = SaveHour
     C                   Eval      WKCNT = Count
     C                   Write     AM#WP451
     C                   Clear                   AM#WP451
     C                   Eval      WrtCount += 1
     C                   Eval      SaveHour = (D1SSTI/10000)
     C                   Eval      Count = *zero

      * only write no more than twelve hour records...
     C                   If        WrtCount = 12
     C                   Leave
     C                   EndIf

     C                   EndIf

     C                   Eval      Count += 1

     C     L#47Key1      ReadE     AM#PL47                                90
     C                   EndDo

      * if hour count hasn't been written...
     C                   If        Count > *zero
     C                   Eval      WKHRS = SaveHour
     C                   Eval      WKCNT = Count
     C                   Write     AM#WP451
     C                   EndIf

     C                   Eval      *InLR = *On
     C                   Return
      *
      *----------------------------------------------------------------

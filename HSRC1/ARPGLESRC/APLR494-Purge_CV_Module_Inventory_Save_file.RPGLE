          // ***********************************************************
          //  Purge CV Module Inventory Save file...
          //  LEC            2022.01.18
          // ***********************************************************
          //

     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO)

     FINVPP15S  UF   E           K DISK

     D                SDS
     D  #PGM                   1     10
     D  #USER                254    263

     D  file           S             50
     D  CutOffDt       S              8  0
     D  Sys_Date       S               D   inz(*sys)

      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------
      *
     C                   Exsr      #Init

      *  purge CV module inventory save file...

     C     *LoVal        SetLL     INVPP15S
     C                   DoU       %eof(INVPP15S)
     C                   Read      INVPP15S

     C                   If        %eof(INVPP15S)
     C                   Leave
     C                   EndIf

     C                   If        IVDATE < CutOffDt
     C                   Delete    INVPP151
     C                   EndIf

     C                   EndDo


     C                   Eval      *InLR = *On
     C                   Return
      *----------------------------------------------------------------
      *  Initialization  - get cutoff date
      *----------------------------------------------------------------
      *
     C     #Init         BegSr

      *  take system date, subtract 3 mos to get cutoff date...
     C                   SubDur    3:*M          Sys_Date
     C                   Eval      CutOffDt = %dec(Sys_Date)

     C                   EndSr
      *----------------------------------------------------------------

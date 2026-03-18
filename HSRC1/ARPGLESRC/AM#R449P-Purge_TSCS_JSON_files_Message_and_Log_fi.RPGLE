          // ***********************************************************
          //  Toyota SCS - Purge JSON, Message, and Log files...
          //  LEC            2021.02.26
          // ***********************************************************
          //

     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO)

     FAM#PL400L1UF   E           K DISK
     FAM#PP400MGUF   E           K DISK
     FAM#PL25B  UF   E           K DISK
     FAM#PL60   UF   E           K DISK

     D                SDS
     D  #PGM                   1     10
     D  #USER                254    263

     D  file           S             50
     D  SkidCutOffDt   S              8  0
     D  TrlrCutOffDt   S              8  0
     D  Sys_Date       S               D   inz(*sys)

     C     KeyMG         KLIST
     C                   KFld                    L1APID
     C                   KFld                    L1CTID

      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------
      *
     C                   Exsr      #Init

      *  purge SCS log file, message file, and delete json files...

     C     *LoVal        SetLL     AM#PL400L1
     C                   DoU       %eof(AM#PL400L1)
     C                   Read      AM#PL400L1

     C                   If        %eof(AM#PL400L1)
     C                   Leave
     C                   EndIf

     C                   Select
     C                   When      L1APID = 'SKID' and L1DATE < SkidCutOffDt
     C                   ExSr      Purge
     C                   Delete    AM#PPLG1
     C                   When      L1APID = 'TRAILER' and L1DATE < TrlrCutOffDt
     C                   ExSr      Purge
     C                   Delete    AM#PPLG1
     C                   When      (L1APID='CASES' or L1APID='SPTRAILER') and
     C                             L1DATE < SkidCutOffDt
     C                   ExSr      Purge
     C                   Delete    AM#PPLG1
     C                   EndSl

     C                   EndDo

      *--------------------------------------------------------------------
      *  now purge wrapper scan file and HULFT transmission log file...
      *--------------------------------------------------------------------
      *
      *wrapper
     C     *LoVal        SetLL     AM#PL25B
     C                   DoU       %eof(AM#PL25B)
     C                   Read      AM#PL25B

     C                   If        %eof(AM#PL25B)
     C                   Leave
     C                   EndIf

     C                   If        R5SSHZ < SkidCutOffDt
     C                   Delete    AM#PP251
     C                   Else
     C                   Leave
     C                   EndIf

     C                   EndDo

      *HULFT
     C     *LoVal        SetLL     AM#PL60
     C                   DoU       %eof(AM#PL60)
     C                   Read      AM#PL60

     C                   If        %eof(AM#PL60)
     C                   Leave
     C                   EndIf

     C                   If        M1SSHZ < SkidCutOffDt
     C                   Delete    AM#PP601
     C                   Else
     C                   Leave
     C                   EndIf

     C                   EndDo

     C                   Eval      *InLR = *On
     C                   Return
      *----------------------------------------------------------------
      *  Initialization  - get cutoff date
      *----------------------------------------------------------------
      *
     C     #Init         BegSr

      *  take system date, subtract 2 wks to get cutoff date for skid...
      *  take system date, subtract 3 wks to get cutoff date for trailer...
     C                   SubDur    14:*D         Sys_Date
     C                   Eval      SkidCutOffDt = %dec(Sys_Date)

     C                   SubDur    21:*D         Sys_Date
     C                   Eval      TrlrCutOffDt = %dec(Sys_Date)

     C                   EndSr
      *----------------------------------------------------------------
      *  Purge Message File and delete JSON files from IFS
      *----------------------------------------------------------------
      *
     C     Purge         BegSr

      * purge records from message file...
     C                   If        L1CFM# = '*NULL' OR L1CFM# = *blanks
     C     KeyMG         SetLL     AM#PP400MG
     C     KeyMG         ReadE     AM#PP400MG
     C                   DoW       NOT %eof(AM#PP400MG)
     C                   Delete    AM#PPMG1
     C     KeyMG         ReadE     AM#PP400MG
     C                   EndDo
     C                   EndIf

     C                   Select
     C                   When      L1APID = 'TRAILER' and L1SHID <> *zero
     C                   Eval      file = %char(L1SHID) + '_' + %trim(L1SURT) +
     C                              '_' + %trim(L1SUPP) + '.json'
     C
     C                   When      L1APID = 'TRAILER' and L1SHID = *zero
     C                   Eval      file = '_' + %trim(L1SURT                ) +
     C                              '_' + %trim(L1SUPP) + '.json'
     C
     C                   When      L1APID = 'SKID'
     C                   Eval      file = %trim(L1ORD#) + '_' + %trim(L1NAMC) +
     C                             '_' + %trim(L1DOCK) + '_' + %trim(L1PALT) +
     C                             '_' + %trim(L1SKID) + '.json'
     C                   When      L1APID = 'CASES'
     C                   Eval      file = 'Case_' + %trim(L1ORD#) + '.json'
     C                   When      L1APID = 'SPTRAILER'
     C                   Eval      file = %char(L1SHID) + '_' + %trim(L1SURT) +
     C                              '_' + %trim(L1SUPP) + '.json'
     C                   EndSl

      *  program to delete json files from ifs...
     C                   Call      'AM#R421D'
     C                   Parm                    L1APID
     C                   Parm                    file




      *  for skids, check if a kanban cut file exists...if so, delete them.
     C                   If        L1APID = 'SKID'
     C                   Eval      file = %trim(L1ORD#) + '_' + %trim(L1NAMC) +
     C                             '_' + %trim(L1DOCK) + '_' + %trim(L1PALT) +
     C                             '_' + %trim(L1SKID) + '_CUT.json'
      *  program to delete json files from ifs...
     C                   Call      'AM#R421D'
     C                   Parm                    L1APID
     C                   Parm                    file

     C                   EndIf

     C                   EndSr
      *----------------------------------------------------------------

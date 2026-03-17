     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO)  DFTACTGRP(*NO)
     H BNDDIR('QC2LE')

     FAM#PP400  IF   E           K DISK

     D                SDS
     D  #PGM                   1     10
     D  #USER                254    263

     D rc              S             10I 0
     D APPID           S             20A
     D SURT            S              9A
     D SUPPCD          S              5A
     D pathname        S            500A
     D file            S             50A
     D resultname      S            500A
     D NewName         S            500A

     D upper           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D lower           C                   'abcdefghijklmnopqrstuvwxyz'

     D unlink          PR            10I 0 ExtProc('unlink')
     D   path                          *   Value options(*string:*trim)

     C     *Entry        PList
     C                   Parm                    APPID
     C                   Parm                    FILE

     C     Key           KList
     C                   KFld                    APPID

      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------

      *  get filepaths from TSCS control file...
     C     Key           Chain     AM#PP400
     C                   If        %found
     C                   Eval      pathname = %trim(T1FILE)+%trim(FILE)
     C     lower:upper   xlate     pathname      NewName
     C                   Eval      rc = unlink(Newname)

     C                   Eval      resultname=%trim(T1RSLT)+%trim(FILE)
     C     lower:upper   xlate     resultname    NewName
     C                   Eval      rc = unlink(NewName)

     C                   Eval      resultname=%trim(T1RSLT)+%trim(FILE)+'.hdr'
     C     lower:upper   xlate     resultname    NewName
     C                   Eval      rc = unlink(NewName)
     C                   EndIf

     C                   Eval      *InLR = *On
     C                   Return
      *----------------------------------------------------------------

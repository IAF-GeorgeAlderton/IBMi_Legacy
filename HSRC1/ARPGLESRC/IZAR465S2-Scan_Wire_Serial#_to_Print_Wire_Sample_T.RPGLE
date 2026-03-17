     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IZAR465S2 ******************************************
      * SCAN WIRE SERIAL # TO PRINT WIRE SAMPLE TAGS
      *   LEC .................     2025.10.10
      *******************************************************
     FIZAPW465S2CF   E             WORKSTN
     FIZAPP65   IF   E           K DISK
     FIZAPL03   IF   E           K DISK
      *
     D ER              S             60    DIM(5) CTDATA PERRCD(1)

     D DSPSW           S              2
     D Valid           S              1
     D @MATN           S             15
     D @DIAM           S              5S 2
     D SERIAL          S             15
      *
     D                SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D  W#JBNO               264    269
      *
     C     *Entry        Plist
     C                   Parm                    #OUTQ            10
      *
      *
      *----------------------------------------------------*
      * MAINLINE                                           *
      *----------------------------------------------------*
     C                   Eval      DSPSW = '01'
      *
     C                   DoU       DSPSW = '99'
      *
     C                   Select
     C                   When      DSPSW = '01'
     C                   Exsr      #SB100
     C                   When      DSPSW = '02'
     C                   Exsr      #SB200
     C                   EndSl
      *
     C                   EndDo
      *
     C                   Eval      *InLR = *On
     C                   Return
      *
      *------------------------------------------------------------*
      * SCREEN ONE - Display Screen for Serial number barcode
      *------------------------------------------------------------*
     C     #SB100        BegSR
      *
     C                   ExFmt     IZAPW001
     C                   Eval      *IN99 = *Off
     C                   Eval      *IN31 = *Off
      *
     C                   If        *IN01 = *On
     C                   Eval      DSPSW = '99'
     C                   LeaveSR
     C                   EndIf
      *
      * if Wire Serial Number is Blank, display error
     C                   If        D1BAR1 = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(1)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
      * check if wire serial number is in file.
     C                   Exsr      CHK100
     C                   If        Valid = 'N'
     C                   Eval      *IN99 = *On
     C                   Exsr      #SB290
     C                   Eval      D1BAR1  = *blanks
     C                   LeaveSR
     C                   EndIf
      *
     C                   Eval      DSPSW  = '02'
      *
     C                   EndSR
      *
      *------------------------------------------------------------*
      * Check Wire Serial Number exists in file
      *------------------------------------------------------------*
     C     CHK100        BegSr

     C                   Select
     C                   When      %subst(D1BAR1:1:1) = 'S'
     C                   Eval      SERIAL = %subst(D1BAR1:2:15)
     C                   When      %subst(D1BAR1:1:2) = 'F#'
     C                   Eval      SERIAL = %subst(D1BAR1:3:15)
     C                   Other
     C                   Eval      SERIAL = D1BAR1
     C                   EndSl

     C     Key1          KList
     C                   KFld                    SERIAL

     C     Key1          Chain     IZAPP65
     C                   If        NOT %found
     C                   Eval      Valid = 'N'
     C                   Eval      D9ERR = ER(2)
     C                   LeaveSR
     C                   EndIf

     C     Key2          KList
     C                   KFld                    @MATN
     C                   KFld                    @DIAM
      *
     C                   Eval      @MATN = IWMATN
     C                   Eval      @DIAM = IWDIAM
      *
     C     Key2          SetGT     IZAPL03
     C     Key2          ReadPE    IZAPL03                                91
      *
     C                   If        ZCSKJY = 'D'
     C                   Eval      *IN91 = *On
     C                   EndIf
      *
     C                   If        ZCSTYY <> 9999
     C                   Eval      *IN91 = *On
     C                   EndIf
      *
     C                   If        *IN91 = *On
     C                   Eval      Valid = 'N'
     C                   Eval      D9ERR = ER(3)
     C                   Else
     C                   Eval      Valid = 'Y'
     C                   EndIf
      *
     C                   EndSr
      *------------------------------------------------------------*
      * SCREEN TWO - Display Screen for Wire Info Confirmation
      *------------------------------------------------------------*
     C     #SB200        BegSR
      *
     C                   Eval      F2SUPP = IWSUPP
     C                   Eval      F2MATN = IWMATN
     C                   Eval      F2DIAM = IWDIAM
     C                   Eval      F2ZETI = ZCKNO3
     C                   Eval      F2HEAT = IWHEAT
     C                   Eval      F2MFG# = IWMFG#
     C                   Eval      F2COIL = IWCOIL
     C                   Eval      F2SERL = SERIAL
      *
     C                   ExFmt     IZAPW002
      *
     C                   If        *IN01 = *On
     C                   Eval      D1BAR1 = *blank
     C                   Eval      DSPSW = '01'
     C                   LeaveSR
     C                   EndIf
      * print wire sample tag...
     C                   Call      'IZAR65P2'
     C                   Parm                    SERIAL
     C                   Parm                    #OUTQ
      * display ok
     C                   ExFmt     IZAPW095
     C                   Eval      D1BAR1 = *blank
     C                   Eval      DSPSW = '01'
      *
     C                   EndSR
      *
      *------------------------------------------------------------*
      * ERROR SCREEN - Display Error on Screen
      *------------------------------------------------------------*
     C     #SB290        BegSR
      *
     C                   Write     IZAPW098
     C                   ExFmt     IZAPW099
      *
     C                   EndSR
      *------------------------------------------------------------*
** ER(60A).........2.........3.........4.........5.........6
 SCAN WIRE TAG SERIAL #                                        01
 WIRE SERIAL # NOT FOUND                                       02
 MATERIAL/DIAM NOT FOUND IN M/F                                03
                                                               04
                                                               05

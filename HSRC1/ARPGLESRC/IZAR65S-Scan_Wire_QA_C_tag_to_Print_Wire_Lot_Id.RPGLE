     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IZAR65S ********************************************
      * SCAN WIRE QA C-TAG TO PRINT WIRE LOT ID TAGS
      *   LEC .................     2025.10.06
      *******************************************************
     FIZAPW65S  CF   E             WORKSTN
     FIZAPL65L  IF   E           K DISK
     FFGBPL01   IF   E           K DISK
     FAB#PPCT   IF   E           K DISK
      *
     D ER              S             60    DIM(5) CTDATA PERRCD(1)

     D DSPSW           S              2
     D Valid           S              1
     D ##SUPP          S              4S 0
     D ##diam          S              5
     D ##wgt           S              5
     D LblName         S              8
     D OutQName        S             10
      *
     D                SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D  W#JBNO               264    269
      *
      *
      *----------------------------------------------------*
      * MAINLINE                                           *
      *----------------------------------------------------*
      *
     C                   Eval      DSPSW = '01'
      *
      * get label name and print outque name...
     C     KEY1          KList
     C                   KFld                    CTKEY1
     C                   KFld                    CTKEY2

     C                   Eval      CTKEY1 = 'QALOT'
     C                   Eval      CTKEY2 = 'PRINT'
      *
     C     KEY1          Chain     AB#PPCT
     C                   If        %found
     C                   Eval      LblName  = CTCHR1
     C                   Eval      OutQName = CTCHR2
     C                   Else
     C                   Eval      DSPSW = '99'
     C                   EndIf

     C                   DoW       DSPSW <> '99'
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
      * SCREEN ONE - Display Screen for QA C-tag QR code
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
      * if QA C-tag QR code is Blank, display error
     C                   If        D1BAR1 = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(1)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
      * check if QR code is correct.
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
      * Check QR code is correct
      *------------------------------------------------------------*
     C     CHK100        BegSr

     C                   If        %subst(D1BAR1:1:3) = 'Z01' and
     C                             %subst(D1BAR1:75:1) = 'C'
     C                   Eval      Valid = 'Y'
     C                   Else
     C                   Eval      Valid = 'N'
     C                   Eval      D9ERR = ER(2)
     C                   LeaveSR
     C                   EndIf

     C     D1BAR1        Chain     IZAPL65L
     C                   If        %found
     C                   Eval      Valid = 'N'
     C                   Eval      D9ERR = ER(3)
     C                   LeaveSR
     C                   EndIf

      *
     C                   EndSr
      *------------------------------------------------------------*
      * SCREEN TWO - Display Screen for Wire Info Confirmation
      *------------------------------------------------------------*
     C     #SB200        BegSR
      *
     C                   Eval      ##SUPP = %dec(%subst(
     C                             D1BAR1:46:4):4:0)

     C     ##SUPP        Chain     FGBPL01
     C                   If        %found
     C                   Eval      F2SUPP = B2SMEI
     C                   Else
     C                   Eval      F2SUPP = 'N/F'
     C                   EndIf

     C                   Eval      F2MATN =%subst(D1BAR1:11:15)

     C                   Eval      ##diam = %subst(D1BAR1:26:5)
     C                   Eval      F2DIAM = %dec(##diam:5:0)/100
     C
     C                   Eval      F2HEAT = %subst(D1BAR1:31:10)
     C                   Eval      F2MFG# = %subst(D1BAR1:66:7)
     C                   Eval      F2COIL = %subst(D1BAR1:73:2)

     C                   Eval      ##wgt  = %subst(D1BAR1:41:5)
     C                   Eval      F2WGT  = %dec(##wgt:5:0)/10

     C                   If        F2WGT >= 2000
     C                   Eval      F2#TAG = 96
     C                   Else
     C                   Eval      F2#TAG = 54
     C                   EndIf

      * display coil info for confirmation...
     C                   ExFmt     IZAPW002
      *
     C                   If        *IN01 = *On
     C                   Eval      D1BAR1 = *blank
     C                   Eval      DSPSW = '01'
     C                   LeaveSR
     C                   EndIf

      * print wire lot id tags...
     C                   Call      'IZAR65PR'
     C                   Parm                    D1BAR1
     C                   Parm                    LblName
     C                   Parm                    OutQName
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
 SCAN QA C-TAG QR CODE                                         01
 INVALID QR CODE                                               02
 LOT IDs ALREADY PRINTED FOR THIS COIL                         03
 LABEL FORMAT NOT FOUND                                        04
                                                               05

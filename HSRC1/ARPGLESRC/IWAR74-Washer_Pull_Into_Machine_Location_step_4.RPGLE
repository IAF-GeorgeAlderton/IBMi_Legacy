     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IWAR74 *********************************************
      * WASHER PULL & SCAN INTO LOCATION
      *   LEC .................     2025.07.18
      *******************************************************
     FIWAPW74   CF   E             WORKSTN
     FAKBPL06   IF   E           K DISK
      *
     D ER              S             60    DIM(10) CTDATA PERRCD(1)

     D DSPSW           S              2
     D Valid           S              1
     D PKQR            S            400
     D NewLoc          S              6
      *
      *  location kanban
     D                 DS
     D  LCKANB                 1     10
     D  LCZETI                 1      4
     D  LCLOCN                 5     10
     D  LCLOC1                 5      5
     D  LCLOC2                 6      7
     D  LCLOC3                 8      9
     D  LCLOC4                10     10
      *
      *  washer order kanban barcode
     D                 DS
     D  WKASJ                  1     20
     D  OZETI                  2      5
     D  OORDR                  6     11
     D  OTYPE                 12     12
     D  OLOTN                 13     16
     D  OCHCK                 17     17
      *
      *  plastic kanban qr code
     D D3QR            DS
     D  D3QRA                  1    256
     D  D3TYPE                 1      3
     D  D3SHIN                34     45
     D  D3SHN1                34     38
     D  D3SHN2                39     43
     D  D3SHN3                44     45
     D  D3NXLC                53     58
     D  D3FRLC                79     84
     D  D3PROC               175    177
     D  D3MCH#               178    180
     D  D3CHIN               219    230
     D  D3CHN1               219    223
     D  D3CHN2               224    228
     D  D3CHN3               229    230
     D  D3QRB                257    400
      *
     D                 DS
     D  WTIME                  1     14  0
     D  HHMMSS                 1      6  0
     D  WDATE                  7     14  0
     D  WYY                    7     10  0
     D  WMM                   11     12  0
     D  WDD                   13     14  0
      *
     D                SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D  W#JBNO               264    269
      *
     C     *Entry        PList
     C                   Parm                    POPR              6
     C                   Parm                    PWKNM            20
      *
      *
     C     K#KEY1        KList
     C                   KFld                    WAORBC           20
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
     C                   When      DSPSW = '03'
     C                   Exsr      #SB300
     C                   EndSl
      *
     C                   EndDo
      *
     C                   Eval      *InLR = *On
     C                   Return
      *
      *------------------------------------------------------------*
      * SCREEN ONE - Display Screen for Location Tag
      *------------------------------------------------------------*
     C     #SB100        BegSR
      *
     C                   ExFmt     IWAPW741
     C                   Eval      *IN99 = *Off
     C                   Eval      *IN31 = *Off
      *
     C                   If        *IN01 = *On
     C                   Eval      DSPSW = '99'
     C                   LeaveSR
     C                   EndIf
      *
     C                   Eval      LCKANB = D1BAR1
      *
      * if Location Kanban barcode is Blank, display error
     C                   If        D1BAR1 = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(6)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
      * check if washer id is in the washer kanban master file.
     C                   Exsr      CHK100
     C                   If        Valid = 'N'
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(2)
     C                   Exsr      #SB290
     C                   Eval      D1BAR1  = *blanks
     C                   LeaveSR
     C                   EndIf
      *
     C                   Eval      D2BAR1 = *blank
     C                   Eval      DSPSW  = '02'
      *
     C                   EndSR
      *
      *------------------------------------------------------------*
      * Check Washer Kanban Master File
      *------------------------------------------------------------*
     C     CHK100        BegSr

      * check for washer ID...
     C     Key1          KList
     C                   KFld                    LCZETI

     C     Key1          SetGT     AKBPL06
      *
     C                   DoW       *In91 = *Off
     C     Key1          ReadPE    AKBPL06                                91

     C                   If        *In91 = *On
     C                   Leave
     C                   EndIf
      *
     C                   If        L1SKJY = 'D'
     C                   Iter
     C                   EndIf
      *
     C                   If        L1STYY = 9999
     C                   Leave
     C                   EndIf
     C                   EndDo

     C                   If        *IN91 = *On
     C                   Eval      Valid = 'N'
     C                   Else
     C                   Eval      Valid = 'Y'
     C                   EndIf

     C                   EndSr
      *----------------------------------------------------*
      * SCREEN TWO - Display Screen for Washer Order
      *----------------------------------------------------*
     C     #SB200        BegSR
      *
     C                   ExFmt     IWAPW742
     C                   Eval      *IN99 = *Off
     C                   Eval      *IN31 = *Off
      *
     C                   If        *IN01 = *On
     C                   Eval      DSPSW  = '01'
     C                   Eval      D2BAR1 = *blanks
     C                   Eval      D1BAR1 = *blanks
     C                   LeaveSR
     C                   EndIf
      *
     C                   If        D2BAR1 = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(1)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
     C                   If        LCLOCN <> L1TKRO
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(4)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
     C                   Eval      WKASJ = D2BAR1
      *
     C                   Eval      D3QR = *blank
     C                   Eval      DSPSW  = '03'
      *
     C                   EndSR
      *------------------------------------------------------------*
      * SCREEN THREE  - Display Screen for Plastic Kanban
      *------------------------------------------------------------*
     C     #SB300        BegSR
      *
     C                   Exfmt     IWAPW743
     C                   Eval      *In99 = *Off
     C                   Eval      *In31 = *Off
      *
     C                   If        *IN01 = *ON
     C                   Eval      DSPSW = '02'
     C                   Eval      D3QR = *blank
     C                   Eval      D2BAR1 = *blanks
     C                   LeaveSR
     C                   EndIf
      *
      * if Plastic Kanban QR code is Blank, display error
     C                   If        D3QR = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(3)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
      * if Plastic Kanban type is not correct, display error
     C                   If        D3TYPE <> 'B01'
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(8)
     C                   Exsr      #SB290
     C                   Eval      D3QR = *blank
     C                   LeaveSR
     C                   EndIf
      * check that the part numbers match...
     C                   If        D3CHIN <> L1SHIN
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(5)
     C                   Exsr      #SB290
     C                   Eval      D3QR = *blank
     C                   LeaveSR
     C                   EndIf
      *
      * call update program for washer inventory...
     C                   Exsr      #SB550
      *
      * display ok screen...
     C                   ExFmt     IWAPW095
      *
     C                   Eval      DSPSW = '01'
     C                   Eval      D1BAR1 = *blank
     C                   Eval      D2BAR1 = *blank
     C                   Eval      D3QR = *blank
     C                   Eval      DSPSW = '01'
      *
     C                   EndSR
      *-----------------------------------------------------------------------*
      * ERROR SCREEN - Display Error on Screen
      *------------------------------------------------------------*
     C     #SB290        BegSR
      *
     C                   Write     IWAPW098
     C                   ExFmt     IWAPW099
      *
     C                   EndSR
      *------------------------------------------------------------*
      * Call Program to Update Washer Inventory file
      *------------------------------------------------------------*
     C     #SB550        BegSR
      *
     C                   Eval      IZPGM = W#PGM
     C                   Eval      NewLoc = D3NXLC
     C                   Eval      PKQR = D3QR
      *
     C                   Call      'IWAR70U4'
     C                   Parm                    WKASJ
     C                   Parm                    PKQR
     C                   Parm                    POPR
     C                   Parm                    IZPGM            10
     C                   Parm                    NewLoc            6
     C                   Parm      'C'           OSTS              1
     C                   Parm      '4'           PSTEP             1
     C                   Parm                    RTNCD             1
      *
     C                   EndSR
      *
      *----------------------------------------------------*
** ER(60A).........2.........3.........4.........5.........6
 SCAN WASHER ORDER KANBAN                                      01
 WASHER PART ID N/FND                                          02
 SCAN PLASTIC KANBAN                                           03
 LOCATION MISMATCH                                             04
 PART NUMBER MISMATCH                                          05
 SCAN LOCATION TAG                                             06
 ALREADY SCANNED                                               07
 WRONG KANBAN                                                  08
                                                               09
                                                               10

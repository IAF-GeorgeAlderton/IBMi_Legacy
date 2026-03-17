     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IWAR79 *********************************************
      * OS WASHER PULL FROM LOCATION
      *   LEC .................     2025.10.29
      *******************************************************
     FIWAPW79   CF   E             WORKSTN
     FAKBPL06   IF   E           K DISK
     FIWAPP71   IF   E           K DISK
      *
     D ER              S             60    DIM(11) CTDATA PERRCD(1)

     D DSPSW           S              2
     D Valid           S              1
     D PKQR            S            400
     D NewLoc          S              6
     D STEP            S              1
     D RSHIN           S             12
     D Key71           S             20
     D #W1SHN          S             12
     D #W2SHN          S             12
     D #RLMCH          S              3
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
     D  WKORDK                 1     20
     D  OTYPE                  1      1
     D  OZETI                  2      5
     D  OSUPP                  6      9
      *
      *  washer retrieval kanban barcode
     D                 DS
     D  WKRTVK                 1     20
     D  RTYPE                  1      1
     D  RPART                  1     14
     D  RSHN1                  1      5
     D  RSHN2                  7     11
     D  RSHN3                 13     14
      *
      *  washer part number from lot id
     D                 DS
     D  W1PHIN                 1     12
     D  W1PHN1                 1      5
     D  W1PHN2                 6     10
     D  W1PHN3                11     15
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
     C                   Parm                    PSECT             2
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
     C                   When      DSPSW = '03'
     C                   Exsr      #SB300
     C                   When      DSPSW = '35'
     C                   Exsr      #SB350
     C                   When      DSPSW = '04'
     C                   Exsr      #SB400
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
     C                   ExFmt     IWAPW791
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

     C                   If        PSECT = 'CV'
     C                   Eval      STEP  = '3'
     C                   Eval      OSTS = 'F'
     C                   Eval      NewLoc = 'TRAIN'
     C                   EndIf

     C                   If        PSECT = 'RL'
     C                   Eval      STEP  = '5'
     C                   Eval      OSTS = 'C'
     C                   EndIf

     C                   EndSr
      *----------------------------------------------------*
      * SCREEN TWO - Display Screen for Retrieval Kanban
      *------------------------------------------------------------*
     C     #SB200        BegSR
      *
     C                   Exfmt     IWAPW792
     C                   Eval      *In99 = *Off
     C                   Eval      *In31 = *Off
      *
     C                   If        *IN01 = *ON
     C                   Eval      DSPSW = '01'
     C                   Eval      D2BAR1 = *blanks
     C                   Eval      D1BAR1 = *blanks
     C                   LeaveSR
     C                   EndIf
      *
      * if Retrieval barcode is Blank, display error
     C                   If        D2BAR1 = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(3)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *

     C                   Eval      WKRTVK = D2BAR1
     C                   Eval      OSUPP = %char(L1BMON)
     C                   Eval      RSHIN = RSHN1 + RSHN2 + RSHN3

     C                   If        RSHIN <> L1SHIN
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(5)
     C                   Exsr      #SB290
     C                   Eval      D2BAR1 = *blank
     C                   LeaveSR
     C                   EndIf

      *
      * verify locations match...
     C                   If        LCLOCN <> L1TKRO
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(4)
     C                   Exsr      #SB290
     C                   Eval      D2BAR1  = *blanks
     C                   LeaveSR
     C                   EndIf
      *
     C                   Eval      D3BAR1 = *blank
      *
      * step 5 = Rolling, so we need to scan the mfg kanban
      * else, we need to scan the order kanban.
     C                   If        STEP  = '5'
     C                   Eval      DSPSW = '35'
     C                   Else
     C                   Eval      DSPSW = '03'
     C                   EndIf
      *
     C                   EndSR
      *-----------------------------------------------------------------------*
      * SCREEN THREE - Display Screen for Order Kanban
      *------------------------------------------------------------*
     C     #SB300        BegSR
      *
     C                   Exfmt     IWAPW793
     C                   Eval      *In99 = *Off
     C                   Eval      *In31 = *Off
      *
     C                   If        *IN01 = *ON
     C                   Eval      DSPSW = '01'
     C                   Eval      D5BAR1 = *blanks
     C                   Eval      D3BAR1 = *blanks
     C                   Eval      D2BAR1 = *blanks
     C                   LeaveSR
     C                   EndIf
      *
      * if Order barcode is Blank, display error
     C                   If        D3BAR1 = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(11)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
     C                   Eval      WKORDK = D3BAR1
      *
     C                   If        LCZETI <> OZETI
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(5)
     C                   Exsr      #SB290
     C                   Eval      D3BAR1 = *blank
     C                   LeaveSR
     C                   EndIf

      *
     C                   Eval      D4BAR1 = *blank
     C                   Eval      DSPSW = '04'
      *
     C                   EndSR
      *-----------------------------------------------------------------------*
      * SCREEN THREE - Display Screen for Manufacturing Kanban
      *------------------------------------------------------------*
     C     #SB350        BegSR
      *
     C                   Exfmt     IWAPW795
     C                   Eval      *In99 = *Off
     C                   Eval      *In31 = *Off
      *
     C                   If        *IN01 = *ON
     C                   Eval      DSPSW = '02'
     C                   Eval      D5BAR1 = *blanks
     C                   Eval      D3BAR1 = *blanks
     C                   Eval      D2BAR1 = *blanks
     C                   LeaveSR
     C                   EndIf
      *
      * if mfg qr code is blank, display error
     C                   If        D5BAR1 = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(11)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
      * substring out both washer part numbers...
     C                   Eval      #W1SHN = %subst(D5BAR1:205:12)
     C                   Eval      #W2SHN = %subst(D5BAR1:219:12)
      *
      * make sure washer part number matches one of them...
     C                   If        L1SHIN <> #W1SHN and L1SHIN <> #W2SHN
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(5)
     C                   Exsr      #SB290
     C                   Eval      D5BAR1 = *blank
     C                   LeaveSR
     C                   EndIf
      *
      * substring out rolling machine number...
     C                   Eval      #RLMCH = %subst(D5BAR1:178:3)
      *
     C                   Eval      D4BAR1 = *blank
     C                   Eval      DSPSW = '04'
      *
     C                   EndSR
      *-----------------------------------------------------------------------*
      * SCREEN FOUR - Display Screen for OS washer Lot Id
      *---------------------------------------------------------------*
     C     #SB400        BegSR
      *
     C                   ExFmt     IWAPW794
     C                   Eval      *IN99 = *Off
     C                   Eval      *IN31 = *Off
      *
     C                   If        *IN01 = *On
     C                   If        STEP  = '5'
     C                   Eval      DSPSW  = '35'
     C                   Else
     C                   Eval      DSPSW  = '03'
     C                   EndIf
      *
     C                   Eval      D3BAR1 = *blanks
     C                   Eval      D4BAR1 = *blanks
     C                   Eval      D5BAR1 = *blanks
     C                   LeaveSR
     C                   EndIf
      *
     C                   If        D4BAR1 = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(1)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
      * check to verify Lot Id scan is valid...
     C                   Call      'UEXR71'
     C                   Parm                    OSUPP
     C                   Parm                    D4BAR1
     C                   Parm                    RTN               1
      *
     C                   If        RTN = 'N' Or RTN = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(9)
     C                   Exsr      #SB290
     C                   Eval      D4BAR1  = *blanks
     C                   LeaveSr
     C                   EndIf
      *
     C                   If        STEP  = '5'
     C                   Eval      WKORDK = *blank
     C                   EndIf
      *
      * check washer inventory file for this lot id...
     C                   Eval      Key71 = D4BAR1
     C     Key71         Chain     IWAPP71
     C                   If        NOT %found
      * if lot id is not found, call pgm to get the part#, qty and
      *    add lot id to washer inventory.

     C                   Call      'IWAR781'
     C                   Parm                    POPR
     C                   Parm                    PWKNM
     C                   Parm                    PSECT
     C                   Parm                    WKORDK
     C                   Parm                    D4BAR1
     C                   Parm                    LCZETI
     C                   Parm                    STEP
     C                   Parm                    RTN
      *
     C                   If        RTN = 'N' Or RTN = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(10)
     C                   Exsr      #SB290
     C                   Eval      D4BAR1  = *blanks
     C                   LeaveSr
     C                   EndIf
     C                   EndIf
      *
      * call update program for washer inventory...
     C                   Exsr      #SB550
      *
      * display ok screen...
     C                   ExFmt     IWAPW095
      *
     C                   Eval      D1BAR1 = *blank
     C                   Eval      D2BAR1 = *blank
     C                   Eval      D3BAR1 = *blank
     C                   Eval      D4BAR1 = *blank
     C                   Eval      D5BAR1 = *blank
     C                   Eval      DSPSW = '01'
      *
      *
     C                   EndSR
      *------------------------------------------------------------*
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
     C                   Eval      RTVKAN = D2BAR1
     C                   Eval      ORDKAN = D3BAR1
     C                   Eval      LOTID = D4BAR1
     C                   Eval      IZPGM = W#PGM

     C                   If        STEP  = '5'
     C                   Eval      MFGKAN = D5BAR1
     C                   Eval      NewLoc = #RLMCH
     C                   Else
     C                   Eval      MFGKAN = *blank
     C                   EndIf
      *
     C                   Call      'IWAR77U2'
     C                   Parm                    RTVKAN           20
     C                   Parm                    ORDKAN           20
     C                   Parm                    MFGKAN          400
     C                   Parm                    LOTID            20
     C                   Parm                    POPR
     C                   Parm                    IZPGM            10
     C                   Parm                    NewLoc            6
     C                   Parm                    OSTS              1
     C                   Parm                    STEP              1
     C                   Parm                    RTNCD             1
      *
     C                   EndSR
      *
      *----------------------------------------------------*
** ER(60A).........2.........3.........4.........5.........6
 SCAN LOT ID                                                   01
 WASHER PART ID N/FND                                          02
 SCAN RETRIEVAL KANBAN                                         03
 LOCATION MISMATCH                                             04
 PART NUMBER MISMATCH                                          05
 SCAN LOCATION TAG                                             06
 ALREADY SCANNED                                               07
 WRONG KANBAN                                                  08
 INVALID LOT ID                                                09
 LOT ID NOT FOUND                                              10
 SCAN ORDER KANBAN                                             11

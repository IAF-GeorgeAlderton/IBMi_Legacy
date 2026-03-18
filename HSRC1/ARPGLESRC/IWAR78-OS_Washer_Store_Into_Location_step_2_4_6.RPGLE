     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IWAR78 *********************************************
      * OS WASHER STORE INTO LOCATION
      *   LEC .................     2025.10.15
      *******************************************************
     FIWAPW78   CF   E             WORKSTN
     FAKBPL06   IF   E           K DISK
     FIWAPP71   IF   E           K DISK
      *
     D ER              S             60    DIM(10) CTDATA PERRCD(1)

     D DSPSW           S              2
     D Valid           S              1
     D PKQR            S            400
     D NewLoc          S              6
     D STEP            S              1
     D RSHIN           S             12
     D Key71           S             20
     D ##SUPP          S              4
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
     C                   ExFmt     IWAPW781
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
      * SCREEN TWO - Display Screen for Order or Retrieval Kanban
      *------------------------------------------------------------*
     C     #SB200        BegSR
      *
     C                   Exfmt     IWAPW782
     C                   Eval      *In99 = *Off
     C                   Eval      *In31 = *Off
     C                   Eval      STEP  = *blank
      *
     C                   If        *IN01 = *ON
     C                   Eval      DSPSW = '01'
     C                   Eval      D2BAR1 = *blanks
     C                   Eval      D1BAR1 = *blanks
     C                   LeaveSR
     C                   EndIf
      *
      * if Order/Retrieval barcode is Blank, display error
     C                   If        D2BAR1 = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(3)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
     C                   Eval      WKORDK = D2BAR1
     C                   Eval      WKRTVK = *blank
      *
     C                   Select
     C                   When      OTYPE <> 'A'
      * order kanban was scanned...
      * check that the part ids match...
     C                   If        LCZETI <> OZETI
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(5)
     C                   Exsr      #SB290
     C                   Eval      D2BAR1 = *blank
     C                   LeaveSR
     C                   EndIf

     C                   Eval      STEP  = '2'
     C                   Eval      OSTS = 'F'
     C                   Eval      ##SUPP = OSUPP

     C                   Other
     C                   Eval      WKORDK = *blank
     C                   Eval      WKRTVK = D2BAR1
     C                   Eval      ##SUPP = %char(L1BMON)
     C                   Eval      RSHIN = RSHN1 + RSHN2 + RSHN3
     C                   If        RSHIN <> L1SHIN
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(5)
     C                   Exsr      #SB290
     C                   Eval      D2BAR1 = *blank
     C                   LeaveSR
     C                   EndIf

     C                   If        PSECT = 'CV'
     C                   Eval      STEP  = '4'
     C                   Eval      OSTS = 'F'
     C                   EndIf

     C                   If        PSECT = 'RL'
     C                   Eval      STEP = '6'
     C                   Eval      OSTS = 'P'
     C                   EndIf

     C                   EndSl
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
     C                   Eval      DSPSW = '03'
      *
     C                   EndSR
      *-----------------------------------------------------------------------*
      * SCREEN THREE - Display Screen for OS washer Lot Id
      *---------------------------------------------------------------*
     C     #SB300        BegSR
      *
     C                   ExFmt     IWAPW783
     C                   Eval      *IN99 = *Off
     C                   Eval      *IN31 = *Off
      *
     C                   If        *IN01 = *On
     C                   Eval      DSPSW  = '02'
     C                   Eval      D3BAR1 = *blanks
     C                   Eval      D2BAR1 = *blanks
     C                   LeaveSR
     C                   EndIf
      *
     C                   If        D3BAR1 = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(1)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
      * check to verify Lot Id scan is valid...
     C                   Call      'UEXR71'
     C                   Parm                    ##SUPP
     C                   Parm                    D3BAR1
     C                   Parm                    RTN               1
      *
     C                   If        RTN = 'N' Or RTN = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(9)
     C                   Exsr      #SB290
     C                   Eval      D3BAR1  = *blanks
     C                   LeaveSr
     C                   EndIf
      *
      * check washer inventory file for this lot id...
     C                   Eval      Key71 = D3BAR1
     C     Key71         Chain     IWAPP71
     C                   If        NOT %found
      * if lot id is not found, call pgm to get the part#, qty and
      *    add lot id to washer inventory.

     C                   Call      'IWAR781'
     C                   Parm                    POPR
     C                   Parm                    PWKNM
     C                   Parm                    PSECT
     C                   Parm                    WKORDK
     C                   Parm                    D3BAR1
     C                   Parm                    LCZETI
     C                   Parm                    STEP
     C                   Parm                    RTN
      *
     C                   If        RTN = 'N' Or RTN = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(10)
     C                   Exsr      #SB290
     C                   Eval      D3BAR1  = *blanks
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
     C                   Eval      RTVKAN = WKRTVK
     C                   Eval      ORDKAN = WKORDK
     C                   Eval      LOTID = D3BAR1
     C                   Eval      IZPGM = W#PGM
     C                   Eval      NewLoc = LCLOCN
     C                   Eval      MFGKAN = *blank
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
 SCAN ORDER/RETRIEVAL KANBAN                                   03
 LOCATION MISMATCH                                             04
 PART NUMBER MISMATCH                                          05
 SCAN LOCATION TAG                                             06
 ALREADY SCANNED                                               07
 WRONG KANBAN                                                  08
 INVALID LOT ID                                                09
 LOT ID NOT FOUND                                              10

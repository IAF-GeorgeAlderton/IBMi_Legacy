     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IWAR781 ********************************************
      * OS WASHER INV - Add Lot Id, Qty to Inventory
      *   LEC .................     2025.10.17
      *******************************************************
     FIWAPW781  CF   E             WORKSTN
     FAKBPL07   IF   E           K DISK
     FIWAPP71   IF   E           K DISK
      *
     D ER              S             60    DIM(10) CTDATA PERRCD(1)

     D DSPSW           S              2
     D Valid           S              1
     D ##QTY           S              6P 0
     D ##SUPP          S              4
      *
      *  part number
     D                 DS
     D  SHIN                   1     12
     D  SHN1                   1      5
     D  SHN2                   6     10
     D  SHN3                  11     12
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
     C                   Parm                    PWKORD           20
     C                   Parm                    PLOTID           20
     C                   Parm                    PZETI             4
     C                   Parm                    PSTEP             1
     C                   Parm                    RTN
      *
      *
      *----------------------------------------------------*
      * MAINLINE                                           *
      *----------------------------------------------------*
     C                   Eval      DSPSW = '01'
     C                   Eval      D@LOT# = PLOTID
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
      * SCREEN ONE - Display Screen for Part Number
      *------------------------------------------------------------*
     C     #SB100        BegSR
      *
     C                   Eval      L1ZETI = *blank
     C                   ExFmt     IWAPW7811
     C                   Eval      *IN99 = *Off
     C                   Eval      *IN31 = *Off
      *
     C                   If        *IN01 = *On
     C                   Eval      DSPSW = '99'
     C                   Eval      RTN   = 'N'
     C                   LeaveSR
     C                   EndIf
      *
      * if part number barcode is blank, display error
     C                   If        D@SHN  = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(1)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
      * remove field indicator  (P)
     C                   If        %subst(D@SHN:1:1) = 'P'
     C                   Eval      D@SHN = %subst(D@SHN:2:19)
     C                   Else
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(1)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
      * remove dashes
     C                   Eval      INP25 = D@SHN
     C                   Call      'UUUR05'
     C                   Parm                    INP25            25
     C                   Parm                    OUT25            25
     C                   Eval      SHIN = OUT25
      *
      * check if washer id is in the washer kanban master file.
     C                   Exsr      CHK100
     C                   If        Valid = 'N'
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(2)
     C                   Exsr      #SB290
     C                   Eval      D@SHN   = *blanks
     C                   LeaveSR
     C                   EndIf
      *
      * verify part ids match
     C                   If        L1ZETI <> PZETI
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(4)
     C                   Exsr      #SB290
     C                   Eval      D@SHN   = *blanks
     C                   LeaveSR
     C                   EndIf
      *
     C                   Eval      D@QTY  = *blank
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
     C                   KFld                    SHN1
     C                   KFld                    SHN2
     C                   KFld                    SHN3

     C     Key1          SetGT     AKBPL07
      *
     C                   DoW       *In91 = *Off
     C     Key1          ReadPE    AKBPL07                                91

     C                   If        *In91 = *On
     C                   Leave
     C                   EndIf
      *
     C                   If        L1SKJY = 'D'
     C                   Iter
     C                   EndIf
      *
     C                   If        L1STYY = 9999
     C                   Eval      ##SUPP = %char(%editc(L1BMON:'X'))
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
      * SCREEN TWO - Display Screen for Quantity
      *------------------------------------------------------------*
     C     #SB200        BegSR
      *
     C                   Exfmt     IWAPW7812
     C                   Eval      *In99 = *Off
     C                   Eval      *In31 = *Off
      *
     C                   If        *IN01 = *ON
     C                   Eval      DSPSW = '01'
     C                   Eval      D@SHN  = *blanks
     C                   Eval      D@QTY  = *blanks
     C                   Eval      RTN    = 'N'
     C                   LeaveSR
     C                   EndIf
      *
      * check qty barcode scan is valid
     C                   Exsr      CHK200
     C                   If        Valid = 'N'
     C                   Eval      D@QTY   = *blanks
     C                   LeaveSR
     C                   EndIf
      *
      * call update program for washer inventory...
     C                   Exsr      #SB550

      * end pgm
     C                   Eval      DSPSW = '99'
      *
      *
     C                   EndSR
      *-----------------------------------------------------------------------*
      * Check Qyantity barcode is valid
      *------------------------------------------------------------*
     C     CHK200        BegSr

      * if quantity is blank, display error
     C                   If        D@QTY  = *blank
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(3)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
      * remove field indentifier (Q)
     C                   If        %subst(D@QTY:1:1) = 'Q'
     C                   Eval      D@QTY = %subst(D@QTY:2:9)
     C                   Else
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(3)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
      * remove dashes, commas, decimal point
     C                   Eval      INP25 = D@QTY
     C                   Call      'UUUR05'
     C                   Parm                    INP25            25
     C                   Parm                    OUT25            25
     C                   Eval      D@QTY = OUT25

      * * convert character qty to numeric...
     C                   Eval      ##QTY = %dec(D@QTY:6:0)
      *
      * if quantity is zero, display error
     C                   If        ##QTY  = *zero
     C                   Eval      *IN99 = *On
     C                   Eval      D9ERR = ER(3)
     C                   Exsr      #SB290
     C                   LeaveSR
     C                   EndIf
      *
     C                   Eval      Valid = 'Y'

     C                   EndSr
      *----------------------------------------------------*
      * ERROR SCREEN - Display Error on Screen
      *------------------------------------------------------------*
     C     #SB290        BegSR
      *
     C                   Write     IWAPW098
     C                   ExFmt     IWAPW099
     C                   Eval      Valid = 'N'
      *
     C                   EndSR
      *------------------------------------------------------------*
      * Call Program to Update Washer Inventory file
      *------------------------------------------------------------*
     C     #SB550        BegSR
      *
     C                   If        PWKORD = *blank
     C                   Eval      KANBAN ='0' + PZETI + ##SUPP
     C                   Else
     C                   Eval      KANBAN = PWKORD
     C                   EndIf
      *
     C                   Eval      LOTID = PLOTID
     C                   Eval      IZPGM = W#PGM
      *
     C                   Call      'IWAR77U1'
     C                   Parm                    KANBAN           20
     C                   Parm                    LOTID            20
     C                   Parm                    ##QTY             6 0
     C                   Parm      'QD'          LOCN              6
     C                   Parm                    POPR
     C                   Parm                    IZPGM            10
     C                   Parm                    PSTEP
     C                   Parm                    RTN               1
      *
     C                   EndSR
      *
      *----------------------------------------------------*
** ER(60A).........2.........3.........4.........5.........6
 SCAN PART # ON SUPP LBL                                       01
 WASHER PART ID N/FND                                          02
 SCAN QTY ON SUPP LABEL                                        03
 PART NUMBER MISMATCH                                          04
                                                               05
                                                               06
                                                               07
                                                               08
                                                               09
                                                               10

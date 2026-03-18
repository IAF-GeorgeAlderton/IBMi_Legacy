     H DATEDIT(*YMD/)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
      ******** AM#R27 *******************************************
      * Toyota SCS Pallet check
      * -----------------------------------------
      * LEC   2019/05/13
      ************************************************************
     FAM#PW27   CF   E             WORKSTN
     F                                     SFILE(SFL01:RRN1)
     F                                     SFILE(SFL03:RRN3)
     F                                     INFDS(@INFDS)
     FAB#PL12   IF   E           K DISK
     FGADPL13   IF   E           K DISK
     FAB#PL65B  IF   E           K DISK
     FAM#PL09   IF   E           K DISK
     FAL#PL10   IF   E           K DISK
     FABP1P27   UF A E           K DISK
     FABP2P27   UF A E           K DISK
     FQPRINT    O    F  132        PRINTER OFLIND(*INOF)
     F                                     USROPN
      *
     D ERR             S             78    DIM(5) CTDATA PERRCD(1)
     D CMX             S             78    DIM(4) CTDATA PERRCD(1)
     D CMD             S             80    DIM(3) CTDATA PERRCD(1)
     D NONY            S              4    DIM(43) CTDATA PERRCD(1)
      *
     D SysDateMDY      S               D   inz(*SYS) datfmt(*usa)               system date (date)
     D @PRT            S              8
     D RRN3            S              6S 0
     D RRN1            S              6S 0
     D @@ID            S              2
     D IAFP            S              3
     D KANB            S              4
     D BOXN            S              4
     D BOXT            S              4
     D Packed          S              1
     D W#RST           S              5S 0
     D W@@CNT          S              5S 0
     D W@NPCK          S              5S 0
     D W@BIN           S              2S 0
     D W@CCNT          S              5S 0
     D W@DD            S              2S 0
     D W@MM            S              2S 0
     D W@NCNT          S              5S 0
     D W@NONY          S              4S 0
     D W@SCNT          S              5S 0
     D W@TCNT          S              5S 0
     D W@TOKU          S              4S 0
     D W@YYYY          S              4S 0
     D WWNONY          S              4
     D P#IAFP          S              3
     D P#KANB          S              4
     D P#BOXN          S              4
     D P#BOXT          S              4
     D P#NUKE          S              2
     D P#ODRN          S             12
     D P#MHN           S             15
      *
     D @INFDS          DS
     D  @@REC                378    379B 0
     D                SDS
     D  #PGM                   1      8
     D  #WSID                244    253
     D  #USER                254    263
     D                 DS
     D  WSDT                   1     14  0
     D  WSSHHH                 1      2  0
     D  WSSNNN                 3      4  0
     D  WSSSSS                 5      6  0
     D  WSSYYY                 7     10  0
     D  WSSMMM                11     12  0
     D  WSSDDD                13     14  0
     D  WSSTM4                 1      4  0
     D  WSSTM6                 1      6  0
     D  WSSDAT                 7     14  0
     D                 DS
     D  D@MDY                  1      8  0
     D  D@MM                   1      2  0
     D  D@DD                   3      4  0
     D  D@YYYY                 5      8  0
      *
     D                 DS
     D BAMHN                   1     20
     D BAMHN1                  1      5
     D BAMHN2                  6     10
     D BAMHN3                 11     15
     D BAMHN4                 16     20
      * ----------------------------------------------------
     C     P#CMD         PList
     C                   Parm                    P@CMD           256
     C                   Parm                    P@LEN            15 5
      *--------------------------------------------------
      *          M  A  I  N  L  I  N  E
      *
     C                   DoU       @@ID = '99'
      *
     C     @@ID          CASEQ     '01'          #SCRN1
     C     @@ID          CASEQ     '02'          #SCRNT
     C                   ENDCS
      *
     C                   EndDo
      *
     C                   Eval      *InLR = *on
     C                   Return
      *--------------------------------------------------
      *  Initialization
      *
     C     *INZSR        BegSr
      *
     C                   Move      SysDateMDY    D@MDY
     C                   Eval      @@ID = '01'
     C                   Eval      P@PRT = '1'
     C                   Clear                   W@TCNT
      *
     C                   EndSr
      *--------------------------------------------------
      * Process Screen 1
      *
     C     #SCRN1        BegSr
      *
     C                   Eval      D@CMD = CMX(1)
     C                   Write     DSP99
     C                   ExFmt     DSP01
     C                   Eval      *In98 = *off
     C                   Eval      D@MSG = *blanks
      *
     C                   Select
     C                   When      *InKA  = *on
     C                   Eval      @@ID = '99'
     C                   Other
     C                   Exsr      #CHK1
     C                   If        *In98 = *on
     C                   Eval      @@ID = '01'
     C                   Else
     C                   Exsr      #SETT
     C                   Eval      @@ID = '02'
     C                   If        *In98 = *on
     C                   Eval      @@ID = '01'
     C                   Eval      D@MSG = ERR(2)
     C                   Else
     C                   Eval      W@REC3 = 1
     C                   EndIf
     C                   EndIf
     C                   EndSl
      *
     C                   EndSr
      *--------------------------------------------------
      * Check Screen 1
      *
     C     #CHK1         BegSr
      *
     C     *usa          Test(DE)                D@MDY
     C                   If        %Error
     C                   Eval      D@MSG = ERR(1)
     C                   Eval      *In98 = *on
     C                   EndIf
      *
     C                   EndSr
      *--------------------------------------------------
      *  Set Totals screen
      *--------------------------------------------------
      *
     C     #SETT         BegSr
      *
     C                   Close     ABP2P27
     C                   Eval      P@CMD = CMD(2)
     C                   Eval      P@LEN = 80
     C                   Call      'QCMDEXC'     P#CMD
     C                   Open      ABP2P27
      *
     C                   Close     ABP1P27
     C                   Eval      P@CMD = CMD(3)
     C                   Eval      P@LEN = 80
     C                   Call      'QCMDEXC'     P#CMD
     C                   Open      ABP1P27
      *
     C                   Eval      *IN61 = *on
     C                   Write     CTL03
     C                   Eval      *IN61 = *off
     C                   Eval      *IN62 = *off
      *
     C                   Eval      RRN3 = *zero
     C                   Eval      D@MSG = *blanks
     C                   Eval      *In98 = *Off
     C                   Eval      D@BOXS = *zero
     C                   Eval      D@NBOX = *zero
     C                   Eval      D@NPCK = *zero
      *
     C                   Eval      W@CCNT = *zero
     C                   Eval      W@NCNT = *zero
     C                   Eval      W@TOKU = 3411
     C                   Eval      W@NONY = *zero
      *
     C                   Eval      W@YYYY = D@YYYY
     C                   Eval      W@MM   = D@MM
     C                   Eval      W@DD   = D@DD
     C                   Eval      W@BIN  = D@BIN
     C*
     C     K#KEY1        KList
     C                   KFld                    W@YYYY
     C                   KFld                    W@MM
     C                   KFld                    W@DD
     C                   KFld                    W@TOKU
      *
     C     K#KEY1        SetLL     AB#PL12
      *
     C                   Do        *HIVAL
      *
     C     K#KEY1        ReadE     AB#PL12
     C                   If        %eof
     C                   LEAVE
     C                   EndIf
      *
     C                   If        BASKJY <> *blank
     C                   Iter
     C                   EndIf
      *
     C                   If        D@BIN <> *zero
     C                   If        D@BIN <> BANOBN
     C                   Iter
     C                   EndIf
     C                   EndIf
      *
     C                   Eval      WWNONY = %char(BANONY)
     C     WWNONY        LookUp    NONY                                   95
     C  N95              Iter
      *
     C                   If        BAUSYS <> *zero
     C                   Eval      W#RST = BASRYO / BAUSYS
     C                   Else
     C                   If        BASYOS <> *zero
     C                   Eval      W#RST = BASRYO / BASYOS
     C                   Else
     C                   Eval      W#RST = 1
     C                   EndIf
     C                   EndIf
      *
     C                   Eval      W@CCNT += W#RST
      *
     C                   Eval      W@SCNT = *zero
     C                   Eval      W@@CNT = *zero
     C                   Eval      W@NPCK = *zero
      * get total scanned out at picking...
     C                   Exsr      #SCNT
      *   if total scanned is less than order, get total unscanned (not picked yet)
     C                   If        W@SCNT < W#RST
     C                   Eval      W@@CNT = W#RST - W@SCNT
     C                   EndIf
      *
     C     K#P1P1        KList
     C                   KFld                    BATOKU
     C                   KFld                    BANONY
     C     K#P1P1        Chain     ABP1P27                            86
     C                   If        *In86 = *on
     C                   Clear                   ABP1P271
     C                   Eval      P1TOKU = BATOKU
     C                   Eval      P1NONY = BANONY
     C     BANONY        Chain     GADPL13
     C                   If        %found
     C                   Eval      P1NONM = B5KMEI
     C                   EndIf
     C                   EndIf
      *
     C                   Eval      P1TCNT += W#RST
     C                   Eval      P1NCNT += W@@CNT
     C                   Eval      P1NPCK += W@NPCK
      *
     C                   If        *In86 = *off
     C                   Update    ABP1P271
     C                   Else
     C                   Write     ABP1P271
     C                   EndIf
      *
     C                   EndDo
      *
     C     *LoVal        SetLL     ABP1P27
      *
     C                   DoU       *In90 =  *on
      *
     C                   Read      ABP1P27                                90
     C   90              Leave
      *
     C                   Eval      RRN3 += 1
     C                   Clear                   SFL03
     C                   Eval      S3DLCD  =  P1NONY
     C                   Eval      S3DLNM  =  P1NONM
     C                   Eval      S3BOXS  =  P1TCNT
     C                   Eval      S3NCNT  =  P1NCNT
     C                   Eval      S3NPCK  =  P1NPCK
     C                   Eval      D@BOXS +=  P1TCNT
     C                   Eval      D@NBOX +=  P1NCNT
     C                   Eval      D@NPCK +=  P1NPCK
     C                   Write     SFL03
      *
     C                   EndDo
      *
     C                   If        RRN3  = *zero
     C                   Eval      *IN98 = *on
     C                   EndIf
      *
     C                   EndSr
      *--------------------------------------------------
      * Display Totals screen
      *
     C     #SCRNT        BegSr
      *
     C                   MOVE      CMX(3)        D@CMD
     C                   WRITE     DSP99
     C                   Z-ADD     W@REC3        #RCNO3
     C                   EXFMT     CTL03
      *
     C     @@REC         IFNE      *ZERO
     C                   Z-ADD     @@REC         W@REC3            4 0
     C                   ELSE
     C                   Z-ADD     1             W@REC3
     C                   ENDIF
      *
     C                   SELECT
     C     *INKA         WHENEQ    *ON
     C                   MOVE      '99'          @@ID
     C     *INKL         WHENEQ    *ON
     C                   MOVE      '01'          @@ID
     C                   OTHER
     C                   EXSR      #CHKT
     C                   ENDSL
      *
     C                   EndSr
      *--------------------------------------------------
      * Check Totals screen for a selection made...
      *--------------------------------------------------
      *
     C     #CHKT         BegSr
      *
     C                   Eval      RRN3 = *zero
      *
     C                   Do        *HiVal
      *
     C                   Eval      RRN3 += 1
      *
     C     RRN3          Chain     SFL03
      *
     C                   If        NOT %found
     C                   Leave
     C                   EndIf
      *
     C                   If        S3SEL = *blank
     C                   Iter
     C                   EndIf
      *
     C                   Eval      S3SEL = *blank
      *
     C                   Update    SFL03

     C                   Exsr      #SET1
     C                   Eval      W@REC# = 1
     C                   Exsr      #SCRN2
      *
     C                   EndDo
      *
     C                   EndSr
      *--------------------------------------------------
      * set subfile1...
      *
     C     #SET1         BegSr
      *
     C                   Eval      D@MSG = *blanks
     C                   Eval      *In98 = *Off
     C                   Eval      *In51 = *On
     C                   Write     CTL01
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
      *
     C                   Eval      RRN1 = *zero
     C                   Eval      D@DLCD = S3DLCD
     C                   Eval      D@DLNM = S3DLNM
      *
     C     K#P2P1        KList
     C                   KFld                    S3DLCD

     C     K#P2P1        SetLL     ABP2P27
      *
     C                   DoU       *In90 = *On
      *
     C     K#P2P1        ReadE     ABP2P27                                90
     C   90              Leave
      *
     C                   Clear                   SFL01

     C                   Eval      S1IAFP = P2IAFP
     C                   Eval      S1KANB = P2KANB
     C                   Eval      S1BOXN = P2BOXN
     C                   Eval      S1BOXT = P2BOXT
     C                   Eval      S1NUKE = P2NUKE
     C                   Eval      S1ORD# = P2ODRN
     C                   Eval      S1MHN  = %subst(P2MHN:1:5) + '-' +
     C                             %subst(P2MHN:6:5) + '-' +
     C                             %subst(P2MHN:11:2)
     C                   Eval      RRN1 += 1
     C                   Write     SFL01
      *
     C                   EndDo
      * Last Record
      *
     C                   If        RRN1 = *zero
     C                   Eval      *In98 = *On
     C                   Eval      D@MSG = ERR(2)
     C                   Eval      RRN1 = 1
     C                   Clear                   SFL01
     C                   Write     SFL01
     C                   EndIf
      *
     C                   EndSr
      *--------------------------------------------------
      * display screen 2  (subfile 1)

     C     #SCRN2        BegSr
      *
     C                   Do        *HiVal
      *
     C                   Eval      D@CMD = CMX(2)
     C                   Write     DSP99
     C                   Eval      #RCNO = W@REC#
     C                   ExFmt     CTL01
      *
     C     @@REC         IFNE      *ZERO
     C                   Z-ADD     @@REC         W@REC#            4 0
     C                   ELSE
     C                   Z-ADD     1             W@REC#
     C                   ENDIF
      *
     C                   Select
     C                   When      *InKA = *On
     C                   Eval      @@ID = '99'
     C                   Leave
     C                   When      *InKL =  *On
     C                   Eval      @@ID = '02'
     C                   Eval      D@MSG = *blanks
     C                   Eval      *In98 = *Off
     C                   Leave
     C                   When      *InKE =  *On
      *
     C                   Select
     C                   When      P@PRT =  '1'
     C                   Eval      @PRT = 'LANPRT31'
     C                   When      P@PRT =  '2'
     C                   Eval      @PRT = 'LANPRT06'
     C                   When      P@PRT =  '3'
     C                   Eval      @PRT = 'LANPRT08'
     C                   Other
     C                   Eval      @PRT = 'QDKT    '
     C                   EndSl
     C
     C                   Eval      P@CMD = CMD(1)
     C                   Eval      %Subst(P@CMD:27:8) = @PRT
     C                   Eval      P@LEN = 80
     C                   Call      'QCMDEXC'     P#CMD
     C                   Open      QPRINT
     C                   Exsr      #PRINT
     C                   Close     QPRINT
     C                   Leave

     C                   EndSl
      *
     C                   EndDo
      *
     C                   EndSr
      *---------------------------------------------------
      * get containers scanned count
      *
     C     #SCNT         BegSr
      *
     C     K#PL65B       KList
     C                   KFld                    K@NONY            4
     C                   KFld                    BANOYY
     C                   KFld                    BANOMM
     C                   KFld                    BANODD
     C                   KFld                    K@NUKE            4
     C                   KFld                    K@ODRN           12
     C                   KFld                    BAMHN1
     C                   KFld                    BAMHN2
     C                   KFld                    BAMHN3
     C                   KFld                    BAMHN4
      *
     C                   Eval      K@NONY = %char(BANONY)
     C                   Eval      K@NUKE = BANUKE
     C                   Eval      K@ODRN = BAINVN
      *
     C     K#PL65B       SetLL     AB#PL65B
      *
     C                   Do        *HiVal
     C     K#PL65B       ReadE     AB#PL65B                               96
     C   96              Leave
     C                   If        A6SKJY <> *BLANK
     C                   Iter
     C                   EndIf
     C                   If        A6SRYO <> *ZERO
     C                   Eval      W@SCNT += 1
      * it was picked, so check to see if it was packed...
     C                   If        A6DEST = '60EXP'
     C                   Exsr      ChkExpPack
     C                   Else
     C                   Exsr      ChkPacking
     C                   EndIf
     C                   If        Packed = 'N'
     C                   Eval      W@NPCK += 1
     C                   EndIf
     C                   EndIf
     C                   EndDo
      *
     C                   Eval      K@ODRN = BAODRN
      *
     C     K#PL65B       SetLL     AB#PL65B
      *
     C                   Do        *HiVal
     C     K#PL65B       ReadE     AB#PL65B                               96
     C   96              Leave
     C                   If        A6SKJY <> *BLANK
     C                   Iter
     C                   EndIf
     C                   If        A6SRYO <> *ZERO
     C                   Eval      W@SCNT += 1
      * it was picked, so check to see if it was packed...
     C                   If        A6DEST = '60EXP'
     C                   Exsr      ChkExpPack
     C                   Else
     C                   Exsr      ChkPacking
     C                   EndIf
     C                   If        Packed = 'N'
     C                   Eval      W@NPCK += 1
     C                   EndIf
     C                   EndIf
     C                   EndDo
      *
     C                   EndSr
      *---------------------------------------------------
      * check Packing file to see if it's been packed...
      *
     C     ChkPacking    BegSr
      *
     C     K#PL09        KList
     C                   KFld                    BANONY
     C                   KFld                    SHID              8
     C                   KFld                    NUKE              2
     C                   KFld                    ODRN             12
     C                   KFld                    MHN              12
     C                   KFld                    A6BOXN
      *
     C                   Eval      SHID = %char(A6NOYY) +
     C                             %char(%editc(A6NOMM: 'X')) +
     C                             %char(%editc(A6NODD: 'X'))
     C                   Eval      NUKE = BANUKE
     C                   Eval      MHN  = BAMHN
     C                   Eval      ODRN = BAINVN
     C                   Eval      Packed = 'N'

     C     K#PL09        SetLL     AM#PL09

     C                   DoU       *In96 = *On
     C     K#PL09        ReadE     AM#PL09                                96
     C                   If        *In96 = *Off and R1SKJY = *blank
     C                   Eval      Packed = 'Y'
     C                   LeaveSr
     C                   EndIf
     C                   EndDo

     C                   Eval      ODRN = BAODRN

     C     K#PL09        SetLL     AM#PL09

     C                   DoU       *In96 = *On
     C     K#PL09        ReadE     AM#PL09                                96
     C                   If        *In96 = *Off and R1SKJY = *blank
     C                   Eval      Packed = 'Y'
     C                   LeaveSr
     C                   EndIf
     C                   EndDo

      * not found in packing, so get pallet info from web order file....
     C                   If        Packed = 'N'
     C                   Exsr      GetIAFP
     C                   Exsr      Wrt2P27
     C                   EndIf

     C                   EndSr
      *---------------------------------------------------
      * this subroutine is for Export orders...
      * check Packing file to see if it's been packed...
      *
     C     ChkExpPack    BegSr
      *
     C     K#PL09X       KList
     C                   KFld                    BANONY
     C                   KFld                    SHID              8
     C                   KFld                    NUKE              2
      *
     C                   Eval      SHID = %char(A6NOYY) +
     C                             %char(%editc(A6NOMM: 'X')) +
     C                             %char(%editc(A6NODD: 'X'))
     C                   Eval      NUKE = BANUKE
     C                   Eval      MHN  = BAMHN
     C                   Eval      ODRN = BAINVN
     C                   Eval      Packed = 'N'

     C     K#PL09X       SetLL     AM#PL09

     C                   DoU       *In96 = *On
     C     K#PL09X       ReadE     AM#PL09                                96
      *
     C                   If        *In96 = *Off

     C                   If        R1SKJY = 'D' OR R1HNTE = 'NG'
     C                   Iter
     C                   EndIf
      *
     C                   If        R12HN = MHN and R12OX# = A6BOXN
     C                   Eval      Packed = 'Y'
     C                   LeaveSr
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndDo
      *
      * not found in packing, so get pallet info from web order file....
     C                   If        Packed = 'N'
     C                   Exsr      GetIAFP
     C                   Exsr      Wrt2P27
     C                   EndIf

     C                   EndSr
      *---------------------------------------------------
      * get IAF Pallet # and Kanban# from web order file.
      *
     C     GetIAFP       BegSr
      *
     C                   Eval      IAFP = *blanks
     C                   Eval      KANB = *blanks
     C                   Eval      BOXN = *blanks
     C                   Eval      BOXT = *blanks
      *
     C     K#PL10        KList
     C                   KFld                    SHID
     C                   KFld                    BATOKU
     C                   KFld                    BANONY
     C                   KFld                    BANKOJ
     C                   KFld                    BANUKE
     C                   KFld                    MHN
     C                   KFld                    A6ORNO
     C                   KFld                    A6BOXN
      *
     C     K#PL10        SetLL     AL#PL10
      *
     C                   Do        *HiVal
     C     K#PL10        ReadE     AL#PL10                                96
     C   96              Leave
     C                   If        CASKJY = *blank
     C                   Eval      IAFP = CAIAFP
     C                   Eval      KANB = CAKNB#
     C                   Eval      BOXN = CABOX#
     C                   Eval      BOXT = CABOXT
     C                   Leave
     C                   EndIf
     C                   EndDo
      *
     C                   EndSr
      *---------------------------------------------------
      * write kanban# and box# for IAF pallet to workfile.
      *
     C     Wrt2P27       BegSr
      *
     C                   Clear                   ABP2P271
     C                   Eval      P2IAFP = IAFP
     C                   Eval      P2KANB = A6KANO
     C                   Eval      P2BOXN = A6BOXN
     C                   Eval      P2BOXT = BOXT
     C                   Eval      P2ODRN = A6ORNO
     C                   Eval      P2NONY = BANONY
     C                   Eval      P2NUKE = BANUKE
     C                   Eval      P2MHN  = MHN
     C                   Write     ABP2P271
      *
     C                   EndSr
      *---------------------------------------------------
      * print the selected delivery code parts not packed...
      *---------------------------------------------------
      *
     C     #PRINT        BEGSR

     C                   Time                    @@TIME            6 0

     C                   Except    @HED

     C                   Eval       P2IAFP = *blanks
     C                   Eval       P2KANB = *blanks
     C                   Eval       P2NUKE = *blanks
     C                   Eval       P2BOXN = *blanks
     C                   Eval       P2BOXT = *blanks
     C                   Eval       P2ODRN = *blanks
     C                   Eval       P2MHN  = *blanks

     C     D@DLCD        SetLL     ABP2P27
     C                   DoU        *IN90 =  *On

     C                   If        *InOF = *On
     C                   Except    @HED
     C                   EndIf

     C     D@DLCD        ReadE     ABP2P27                                90
     C                   If        *In90 =   *Off
     C                   Eval      P#IAFP = P2IAFP
     C                   Eval      P#KANB = P2KANB
     C                   Eval      P#BOXN = P2BOXN
     C                   Eval      P#BOXT = P2BOXT
     C                   Eval      P#NUKE = P2NUKE
     C                   Eval      P#ODRN = P2ODRN
     C                   Eval      P#MHN = %subst(P2MHN:1:5) + '-' +
     C                             %subst(P2MHN:6:5) + '-' +
     C                             %subst(P2MHN:11:2)
     C                   Except    @DTL
     C                   EndIf

     C                   EndDo

     C                   EndSr
      *---------------------------------------------------
     OQPRINT    E            @HED             01
     O                       #PGM                10
     O                                           51 'TOYOTA SCS PALLET'
     O                                           64 'VERIFICATION'
     O                       UDATE         Y     80
     O                       @@TIME              90 '  :  :  '
     O                                          100 'PAGE'
     O                       PAGE          Z    105
     O          E            @HED             03
     O                                           12 'SHIP DATE:'
     O                       D@MM                15
     O                                           16 '/'
     O                       D@DD                18
     O                                           19 '/'
     O                       D@YYYY              23
     O          E            @HED             04
     O                       D@DLCD               7
     O                       D@DLNM              24
     O          E            @HED             06
     O                                           13 'IAF_PLT#'
     O                                           24 'KANBAN#'
     O                                           31 'BOX#'
     O                                           42 'OF_BOXES'
     O                                           50 'DOCK'
     O                                           60 'ORDER #'
     O                                           75 'PART #'
     O          E            @DTL        1  1
     O                       P#IAFP              11
     O                       P#KANB              23
     O                       P#BOXN              31
     O                       P#BOXT              40
     O                       P#NUKE              49
     O                       P#ODRN              65
     O                       P#MHN               84
** CMD
INVALID SHIP DATE.
NO DATA



** CMX
 F1:End
 F1:End    F12:Previous    F5:Print
 F1:End    F12:Previous    Next/Prev Page:Page Up/Down
 ENTER:Return Previous Screen
**
OVRPRTF FILE(QPRINT) OUTQ(        )
CLRPFM QTEMP/ABP2P27
CLRPFM QTEMP/ABP1P27
**
3953
3952
0541
0542
3423
3424
3797
3798
3796
3764
3765
3503
3504
3804
3805
3347
3348
3220
3421
3481
3482
3851
3852
3931
3932
3560
3561
3554
3555
3612
3428
3429
9001
9002
9003
9004
9005
9006
9007
3226
3227
3770

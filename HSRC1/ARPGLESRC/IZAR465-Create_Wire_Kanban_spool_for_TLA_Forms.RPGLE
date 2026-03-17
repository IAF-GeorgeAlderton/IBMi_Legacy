     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IZAR465 ******************************************************
      *  CREATE WIRE KANBAN SPOOL INFO FOR TL ASHFORD FORMS TO PICK UP
      *   LEC   2025.07.25
      *   LEC   2025.08.05 also print QA tags
      *****************************************************************
     FIZAPP65   IF   E           K DISK
     FIZAPL03   IF   E           K DISK
     FCACPL02   IF   E           K DISK
     FAB#PPCT   UF A E           K DISK
     FIZAPR01   O    E             PRINTER
     FIZAPR02A  O    E             PRINTER
     FIZAPR02C  O    E             PRINTER
      *
     D @MATN           S             15
     D @DIAM           S              5S 2
     D Valid           S              1
     D #DIAM           S              5
     D #TWGT           S              5
     D SeqNum          S              6S 0
      *
     D                 DS
     D  TIME                   1      6  0
     D  TIMHH                  1      2  0
     D  TIMMM                  3      4  0
      *
     D                 DS
     D  SDATE                  1     14  0
     D  NOW                    1      6  0
     D  TODAY                  7     14  0
      *
     C     *Entry        PList
     C                   Parm                    PSERL            15
      *
      *----------------------------------------------------*
      *  M  A  I  N  L  I  N  E
      *----------------------------------------------------*
     C                   Time                    SDATE
      *
      * find serial number in workfile...
     C     PSERL         Chain     IZAPP65
     C                   If        %found
      *
      * additional info...
     C                   Exsr      GetWireInfo
     C                   If        Valid = 'Y'
      *
      * supplier name
     C                   Eval      P@SPNM = IWSUPP
     C                   Write     P@LN11
      *
      * material name
     C                   Eval      P@ZAIS = IWMATN
     C                   Write     P@LN12
      *
      * diameter
     C                   Eval      P@ZAIK = IWDIAM
     C                   Write     P@LN13
      *
      * weight
     C                   Eval      P@TTLW = IWWGT
     C                   Write     P@LN14
      *
      * recv plant
     C                   Eval      P@IANM = 'I A F'
     C                   Write     P@LN15
      *
      * material color and color code
     C                   Eval      P@ZIRO = C1IR01
     C                   Eval      P@ZICD = C1ZAIR
      *
      * form overlay name
     C                   Eval      P@OVRL = 'WK_' + P@ZICD
     C                   Write     P@LN16
      *
      * order date
     C                   Eval      P@ORDT = IWPRDT
     C                   Write     P@LN17
      *
      * heat#,mfg#,coil#
     C                   Eval      P@HHH# = IWHEAT
     C                   Eval      P@MMM# = '0' + IWMFG#
     C                   Eval      P@CCC# = '0' + IWCOIL
      *
      * wire kanban bcode
     C                   Eval      P@BARC = %trim(ZCKNO2)+ %trim(ZCKNO3)+
     C                             %trim(P@MMM#)+ %trim(P@CCC#)
      *
      * get check digit
     C                   Eval      PMAREA = P@BARC
     C                   Eval      PMBYTE = '016'
      *
     C                   Call      'ALBRCC'
     C                   Parm                    PMAREA          100
     C                   Parm                    PMBYTE            3
     C                   Parm                    PMCHK             1
     C                   Parm                    PMRTCD            1
      *
      * add check digit
     C                   Eval      P@BARC = %trim(P@BARC)+ ' ' + PMCHK
     C                   Write     P@LN18
      *
      * wire id
     C                   Eval      P@PRID = %trim(ZCKNO2) + %trim(ZCKNO3)
     C                   Write     P@LN19
      *
      * wire location
     C                   Eval      P@LCN1 = ZCADR2
     C                   Eval      P@LCN2 = ZCADR3
     C                   Write     P@LN20
      *
     C                   Exsr      PrtQAs
      *
     C                   EndIf
     C                   EndIf
      *
     C                   Eval      *INLR = *On
      *
     C                   Return
      *
      *******************************************************************
     C     GetWireInfo   BegSR
      *
      * get info for wire in material master...
     C     Key1          KList
     C                   KFld                    @MATN
      *
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
     C                   Else
     C                   Eval      Valid = 'Y'
     C                   EndIf
      *
      * get material color and color code...
     C     Key1          Chain     CACPL02
      *
     C                   EndSR
      *******************************************************************
     C     PrtQAs        BegSR
      *
      * get next sequence number for QA#
     C     KeyQA         KList
     C                   KFld                    CTKEY1
     C                   KFld                    CTKEY2
      *
     C                   Eval      CTKEY1 = 'WIRESEQ#'
     C                   Eval      CTKEY2 = %char(%editc(ZCKAKE:'X'))
      *
     C     KeyQA         Chain     AB#PPCT
     C                   If        NOT %found(AB#PPCT)
     C                   Eval      CTCHR1 = 'QA seq#'
     C                   Eval      CTNBR1 = 1
     C                   Write     AB#PPCT1
     C                   Else
     C                   If        CTNBR1 = 999999
     C                   Eval      CTNBR1 = 1
     C                   Else
     C                   Eval      CTNBR1 += 1
     C                   EndIf
     C                   Update    AB#PPCT1
     C                   EndIf
      *
     C                   Eval      SeqNum = CTNBR1
      *
      * form overlay name
     C                   Eval      A@OVRL = 'QA_' + %trim(C1ZAIR)
     C                   Eval      C@OVRL = A@OVRL
      *
      * supplier code
      *
     C                   Eval      A@SUPP = %char(%editc(ZCKAKE:'X'))
     C                   Eval      C@SUPP = A@SUPP
     C                   Write     A@LN11
     C                   Write     C@LN11
      *
      * qa#
     C                   Eval      A@QA#  = C1ZAIR +
     C                             %char(%editc(SeqNum:'X'))
     C                   Eval      C@QA#  = A@QA#
     C                   Write     A@LN12
     C                   Write     C@LN12
      *
      * mfg#
     C                   Eval      A@MFG# = P@MMM#
     C                   Eval      A@COIL = IWCOIL
     C                   Eval      C@MFG# = A@MFG#
     C                   Eval      C@COIL = A@COIL
     C                   Write     A@LN13
     C                   Write     C@LN13
      *
      * production date
     C                   Eval      A@PRDT = IWPRDT
     C                   Eval      C@PRDT = A@PRDT
     C                   Write     A@LN14
     C                   Write     C@LN14
      *
      * ship/order date
     C                   Eval      A@SHDT = IWSHDT
     C                   Eval      C@SHDT = A@SHDT
     C                   Write     A@LN15
     C                   Write     C@LN15
      *
      * material type
     C                   Eval      A@MTYP = IWMTYP
     C                   Eval      C@MTYP = A@MTYP
     C                   Write     A@LN16
     C                   Write     C@LN16
      *
      * material name/grade
     C                   Eval      A@MATN = IWMATN
     C                   Eval      C@MATN = A@MATN
     C                   Write     A@LN17
     C                   Write     C@LN17
      *
      * diameter
     C                   Eval      A@ZAIK = IWDIAM
     C                   Eval      C@ZAIK = A@ZAIK
     C                   Write     A@LN18
     C                   Write     C@LN18
     C                   Eval      #DIAM  = %char(%editc(IWDIAM:'X'))
      *
      * heat#/charge#
     C                   Eval      A@CHRG = IWHEAT
     C                   Eval      C@CHRG = A@CHRG
     C                   Write     A@LN19
     C                   Write     C@LN19
      *
      * weight
     C                   Eval      A@TTLW = IWWGT
     C                   Eval      C@TTLW = A@TTLW
     C                   Write     A@LN20
     C                   Write     C@LN20
     C                   Eval      #TWGT  = %char(%editc(IWWGT:'X'))
      *
      * qr code data
     C                   Eval      A@QR = 'Z01' + A@QA# + A@MATN +
     C                             #DIAM + A@CHRG + #TWGT + (A@SUPP) +
     C                             %char(A@PRDT) + %char(A@SHDT) +
     C                             %subst(A@MFG#:1:7) + A@COIL + 'A'
      *
     C                   Eval      C@QR = 'Z01' + A@QA# + A@MATN +
     C                             #DIAM + A@CHRG + #TWGT + (A@SUPP) +
     C                             %char(A@PRDT) + %char(A@SHDT) +
     C                             %subst(A@MFG#:1:7) + A@COIL + 'C'
      *
     C                   Write     A@LN21
     C                   Write     C@LN21
      *
     C                   EndSR
      *******************************************************************

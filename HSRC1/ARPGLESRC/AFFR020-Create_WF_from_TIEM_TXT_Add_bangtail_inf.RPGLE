     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO)

     FAFFWP20   IF   E           K DISK
     FAB#PL15   IF   E           K DISK
     FFCEPL01   IF   E           K DISK
     FAB#NP30   UF A E           K DISK
     FAB#PL78   UF   E           K DISK
     FAB#PL75   UF   E           K DISK
     FAB#PP70   O  A E           K DISK
     FAFFWP20B  O  A E           K DISK
     F**AB#XP01   O  A E           K DISK
     FAB#XP01A  O  A E           K DISK

     D                SDS
     D  #PGM                   1     10
     D  #WSID                244    253
     D  #USER                254    263

     D  @@14           S             14  0
     D  SERL           S             18
     D  X              S              5  0
     D  NumConts       S              5  0
     D  Order#         S             10

     D                 DS
     D  WSDT                   1     14  0
     D  WSTIME                 1      6  0
     D  WSDATE                 7     14  0
     D  WSHH                   1      2  0
     D  WSMN                   3      4  0
     D  WSYY                   7     10  0
     D  WSMM                  11     12  0
     D  WSDD                  13     14  0

     D                 DS
     D  A2DATE                 1      8  0
     D  A2TRYY                 1      4  0
     D  A2TRMM                 5      6  0
     D  A2TRDD                 7      8  0

     D                 DS
     D  BASHDT                 1      8  0
     D  BANOYY                 1      4  0
     D  BANOMM                 5      6  0
     D  BANODD                 7      8  0

     C     Key15         KLIST
     C                   KFLD                    TOKU              4 0
     C                   KFLD                    NONY              4 0
     C                   KFLD                    NKOJ              1
     C                   KFLD                    NUKE              4
     C                   KFLD                    MHN1              5
     C                   KFLD                    MHN2              5
     C                   KFLD                    MHN3              5
     C                   KFLD                    MHN4              5
     C                   KFLD                    ODRN             10

     C     Key01         KLIST
     C                   KFLD                    BASHN1
     C                   KFLD                    BASHN2
     C                   KFLD                    BASHN3

     C     Key78         KLIST
     C                   KFLD                    EKNOYY
     C                   KFLD                    EKNOMM
     C                   KFLD                    EKNODD
     C                   KFLD                    TOKU
     C                   KFLD                    NONY
     C                   KFLD                    NKOJ
     C                   KFLD                    NUKE
     C                   KFLD                    BANOBN
     C                   KFLD                    EKRLYY
     C                   KFLD                    EKRLMM
     C                   KFLD                    EKRLDD
     C                   KFLD                    Order#

      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------

     C                   Time                    WSDT

      *  process txt input workfile...
     C                   Do        *HiVal
     C                   Read      AFFWP20

     C                   If        %eof(affwp20)
     C                   Leave
     C                   EndIf

      *  extract data...
     C                   Exsr      Extract

      *  find ordered part in order file...
     C     Key15         SetLL     AB#PL15
     C                   DoW       NOT %eof(ab#pl15)
     C     Key15         ReadE     AB#PL15
     C                   If        BASKJY = 'D'
     C                   Iter
     C                   EndIf
     C                   Leave
     C                   EndDo

     C                   If        NOT %eof(ab#pl15) and BASKJY = *blank

      *  calculate number of containers...
     C                   If        BASYOS > *zero
     C                   Eval      NumConts = BASRYO / BASYOS
     C                   Else
     C                   Eval      NumConts = 1
     C                   EndIf

      *  get location from part master...
     C     Key01         SetLL     FCEPL01
     C                   DoW       NOT %eof(fcepl01)
     C     Key01         ReadE     FCEPL01
     C                   If        A2GSKD = 'D'
     C                   Iter
     C                   EndIf
     C                   Leave
     C                   EndDo

     C                   If        NOT %eof(fcepl01) and A2GSKD = *blank

      *  let numconts = total boxes and x = box number...
     C     1             Do        NumConts      X
     C                   Exsr      GetNxtNmbr
     C                   Exsr      WrtPP70
     C                   Exsr      WrtWP20B
     C                   Exsr      WrtXP01
     C                   Exsr      UpdPP78
     C                   Exsr      UpdPP75
     C                   EndDo

     C                   EndIf

     C                   EndIf

     C                   EndDo

     C                   Eval      *InLR = *On
     C                   Return
      *----------------------------------------------------------------
      *  Extract text data from input...
      *----------------------------------------------------------------
      *
     C     Extract       BegSr

      *  customer part# is in field4...
     C                   Eval      MHN1 = %subst(FLD4:1:5)
     C                   Eval      MHN2 = %subst(FLD4:7:5)
     C                   Eval      MHN3 = %subst(FLD4:13:2)

      *  order# is in fieldE...
     C                   Eval      ODRN = FLDE

      *  customer code is in fieldF...
     C                   Eval      TOKU = %dec(%subst(FLDF:1:4):4:0)

      *  delivery code is in fieldG...
     C                   Eval      NONY = %dec(%subst(FLDG:1:4):4:0)

      *  default factory code and dock...
     C                   Eval      NKOJ = '0'
     C                   Eval      NUKE = '00'

     C                   EndSr
      *----------------------------------------------------------------
      *  get next serial number for container label...
      *----------------------------------------------------------------
      *
     C     GetNxtNmbr    BegSr

     C                   Eval      @@14 = 99999999999999
     C                   Time                    WSDT

     C     NONY          Chain     AB#NP30

     C                   Eval      N3UDAT = WSDATE
     C                   Eval      N3UTIM = WSTIME
     C                   Eval      N3UPGM = #PGM
     C                   Eval      N3UUSR = #USER
     C                   Eval      N3UWIS = #WSID

     C                   Eval      N3NONY = NONY

     C                   If        NOT %found(ab#np30)
     C                   Eval      N3NMBR = 1
     C                   Write     AB#NP301
     C                   Else
     C                   Eval      N3NMBR += 1
     C                   If        N3NMBR = @@14
     C                   Eval      N3NMBR = 1
     C                   EndIf
     C                   Update    AB#NP301
     C                   EndIf

     C                   Eval      SERL = %trim(FLDG) +
     C                             %subst(%char(%editc(N3NMBR:'X')):5:14)
     C                   EndSr
      *----------------------------------------------------------------
      *  Write label info to EKANBAN SERIAL -- AB#PP70
      *----------------------------------------------------------------
      *
     C     WrtPP70       BegSr

     C                   Clear                   AB#PP701
     C                   Eval      EKKOYY = WSYY
     C                   Eval      EKKOMM = WSMM
     C                   Eval      EKKODD = WSDD
     C                   Eval      EKKOHH = WSHH
     C                   Eval      EKKOMN = WSMN
     C                   Eval      EKKOME = #USER
     C                   Eval      EKTOKU = TOKU
     C                   Eval      EKNONY = %trim(FLDG)
     C                   Eval      EKNKOJ = NKOJ
     C                   Eval      EKNUKE = NUKE
     C                   Eval      EKZETI = A2ZETI
     C                   Eval      EKSYOS=%subst(%char(%editc(BASYOS:'X')):2:5)

     C                   If        WSDATE >= A2DATE
      * new
     C                   Eval      EKLOC1 = A2STRK
     C                   Eval      EKLOC2 = A2STRT
     C                   Eval      EKLOC3 = A2STRR
     C                   Eval      EKLOC4 = A2STRD
     C                   Else
      * old
     C                   Eval      EKLOC1 = A2KTRK
     C                   Eval      EKLOC2 = A2KTRT
     C                   Eval      EKLOC3 = A2KTRR
     C                   Eval      EKLOC4 = A2KTRD
     C                   EndIf

     C                   Eval      EKODRN = BAODRN
     C                   Eval      EKSHN1 = BASHN1
     C                   Eval      EKSHN2 = BASHN2
     C                   Eval      EKSHN3 = BASHN3
     C                   Eval      EKNOYY = BANOYY
     C                   Eval      EKNOMM = BANOMM
     C                   Eval      EKNODD = BANODD
     C                   Eval      EKMHN1 = BAMHN1
     C                   Eval      EKMHN2 = BAMHN2
     C                   Eval      EKMHN3 = BAMHN3
     C                   Eval      EKMHN4 = BAMHN4
     C                   Eval      EKNOBN = %char(%editc(BANOBN:'X'))
     C                   Eval      EKSERL = SERL
     C                   Eval      EKRLYY = BADEYY
     C                   Eval      EKRLMM = BADEMM
     C                   Eval      EKRLDD = BADEDD

     C                   Write     AB#PP701

     C                   EndSr
      *----------------------------------------------------------------
      *  Write label info to label download workfile -- AFFWP20B
      *----------------------------------------------------------------
      *
     C     WrtWP20B      BegSr

     C                   Clear                   AFFWP2B1
     C                   Eval      LBMMDD = FLD1
     C                   Eval      LBSBGO = FLD2
     C                   Eval      LBQAFL = FLD3
     C                   Eval      LBPART = FLD4
     C                   Eval      LBSUPP = FLD5
     C                   Eval      LBSNAM = FLD6
     C                   Eval      LBLOCN = FLD7
     C                   Eval      LBPLNT = FLD8
     C                   Eval      LBDOCK = FLD9
     C                   Eval      LBQPC  = FLDA
     C                   Eval      LBBXTY = FLDB
     C                   Eval      LBKANB = FLDC
     C                   Eval      LBDDAT = FLDD
     C                   Eval      LBODRN = FLDE
     C                   Eval      LBCUST = FLDF
     C                   Eval      LBDELV = FLDG

     C                   If        WSDATE >= A2DATE
      * new
     C                   Eval      LBLOC1 = A2STRK
     C                   Eval      LBLOC2 = A2STRT
     C                   Eval      LBLOC3 = A2STRR
     C                   Eval      LBLOC4 = A2STRD
     C                   Else
      * old
     C                   Eval      LBLOC1 = A2KTRK
     C                   Eval      LBLOC2 = A2KTRT
     C                   Eval      LBLOC3 = A2KTRR
     C                   Eval      LBLOC4 = A2KTRD
     C                   EndIf

     C                   Eval      LBSERL = SERL
     C                   Eval      LBBOX# = %char(X)
     C                   Eval      LBBOXT = %char(NumConts)
     C                   Eval      LBIPAR = BASHN1 + BASHN2 + BASHN3
     C                   Write     AFFWP2B1

     C                   EndSr
      *----------------------------------------------------------------
      *  Write label info to label data issue log -- AB#XP01
      *----------------------------------------------------------------
      *
     C     WrtXP01       BegSr

     C**jw               Clear                   AB#XP011
     C                   Clear                   AB#XP1A1
     C                   Eval      IXKOHZ = WSDATE
     C                   Eval      IXKOTM = WSTIME
     C                   Eval      IXTOKU = %char(%editc(BATOKU:'X'))
     C                   Eval      IXNONY = %char(%editc(BANONY:'X'))
     C                   Eval      IXNKOJ = BANKOJ
     C                   Eval      IXNUKE = BANUKE
     C                   Eval      IXODRN = BAODRN
     C                   Eval      IXSERL = SERL
     C                   Eval      IXDEDT = BASHDT
     C                   Eval      IXNOBN = %char(%editc(BANOBN:'X'))

     C**jw               Write     AB#XP011
     C                   Write     AB#XP1A1

     C                   EndSr
      *----------------------------------------------------------------
      *  Update CUST SHIPPING CHECK SHEET file  -- AB#PP78
      *----------------------------------------------------------------
      *
     C     UpdPP78       BegSr

     C                   Eval      Order# = ODRN
     C     Key78         Chain     AB#PL78
     C                   If        %found(ab#pl78) and P8SKJY = *blank
     C                   Eval      P8KODT = WSDATE
     C                   Eval      P8KOTM = WSTIME
     C                   Eval      P8KONM = #USER
     C                   If        P8LPDT = *zero
     C                   Eval      P8LPDT = WSDATE
     C                   Eval      P8LPTM = WSTIME
     C                   Eval      P8LPNM = #USER
     C                   EndIf
     C                   Update    AB#PP781
     C                   EndIf

     C                   EndSr
      *----------------------------------------------------------------
      *  Update Packing List file  -- AB#PP75
      *----------------------------------------------------------------
      *
     C     UpdPP75       BegSr

     C                   Eval      Order# = ODRN
     C     Key78         Chain     AB#PL75
     C                   If        NOT %found(ab#pl75)
     C                   Eval      Order# = *blanks
     C     Key78         Chain     AB#PL75
     C                   EndIf

     C                   If        %found(ab#pl75) and PUSKJY = *blank
     C                   Eval      PUKODT = WSDATE
     C                   Eval      PUKOTN = WSTIME
     C                   Eval      PUKOME = #USER
     C                   Eval      PULPDT = WSDATE
     C                   Update    AB#PP751
     C                   EndIf

     C                   EndSr
      *----------------------------------------------------------------

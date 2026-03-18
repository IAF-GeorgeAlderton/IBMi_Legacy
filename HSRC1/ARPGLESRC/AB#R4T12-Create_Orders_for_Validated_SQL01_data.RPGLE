     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO)

      * =======================================================================================
      *  AB#R4T12
      *  LEC          2021/11/29
      *  This program will Create Orders for Validated SQL01 data and Email Failed Orders List
      *-----------------------------------------------
      *  JW1          2023.07.14 add AB#XP01A (Serial# Log)
      * =======================================================================================
      *

     FRDBWP20   UF   E           K DISK
     FRDBWP21   UF   E           K DISK
     FAB#NP30   UF A E           K DISK
     FAB#PP70   UF A E           K DISK
     FAB#WP452  O    F  256        DISK
JW1  FAB#XP01A  O    E             DISK

     D                SDS
     D  #PGM                   1     10
     D  #WSID                244    253
     D  #USER                254    263

     D  SysDateISO     S               D   inz(*SYS) datfmt(*iso)               system date (date)
     D  SysDate80      S              8S 0                                      ship date (num)
     D  ##tierName     S             10
     D  ##orgCode      S             10
     D  ##orderNo      S             15
     D  ##nuke         S              4
     D  ##SaveMHN      S                   like(tdmhn)
     D  ##OrderQty     S              7S 0                                      total ordered qty
     D  ##chNONY       S              4
     D  @@14           S             14  0
     D  ##serl         S             18

     D                 DS
     D  WSDT                   1     14  0
     D  WSTIME                 1      6  0
     D  WSDATE                 7     14  0
     D  WSHH                   1      2  0
     D  WSMN                   3      4  0
     D  WSYY                   7     10  0
     D  WSMM                  11     12  0
     D  WSDD                  13     14  0

      * AB#WP452
     D                 DS
     D OREC                    1    256
     D   OSUPC                 1      5
     D   OTOKU                 6      9
     D   ONONY                10     13
     D   ONKOJ                14     14
     D   ODOCK                15     18
     D   OKNB#                19     22
     D   OMHN                 23     34
     D   OSHID                43     50
     D   OORD#                51     60
     D   OSRYO                61     67  0
     D   OSYOS                68     73  0
     D   OSHIT                74     77
     D   OSHIN                78     89
     D   OBIN#                98     99
     D   OUSYS               100    105  0
     D   OINVN               106    121
     D   O@@H                256    256

     D                 DS
     D   ##shid                1      8  0
     D   ##noyy                1      4  0
     D   ##nomm                5      6  0
     D   ##nodd                7      8  0

JW1  D                 DS
 .   D   EKMHIN                1     20
 .   D   EKMHN1                1      5
 .   D   EKMHN2                6     10
 .   D   EKMHN3               11     15
 .   D   EKMHN4               16     20

JW1  D                 DS
 .   D   EKSHIN                1     12
 .   D   EKSHN1                1      5
 .   D   EKSHN2                6     10
 .   D   EKSHN3               11     12

JW1  D                 DS
 .   D   EKNOHZ                1      8  0
 .   D   EKNOYY                1      4  0
 .   D   EKNOMM                5      6  0
 .   D   EKNODD                7      8  0

     C     *Entry        PList
     C                   Parm                    P#ERR             1

     C     WP21_Key      KLIST
     C                   KFLD                    ##tierName
     C                   KFLD                    ##orgCode
     C                   KFLD                    ##orderNo
     C                   KFLD                    ##nuke

      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------

     C                   Eval      P#ERR = *blank
     C                   MoveL     SysDateISO    SysDate80

      *  process uploaded order header file...
     C     *start        SetLL     RDBWP20
     C                   Read      RDBWP20

     C                   DoW       NOT %eof(RDBWP20)

     C                   If        THMSG = 'Validated'
     C                   Exsr      @CreateOrd
     C                   Eval      THMSG = 'Completed'
     C                   Update    RDBWP201
     C                   Else
     C                   Eval      P#ERR = 'Y'
     C                   EndIf

     C                   Read      RDBWP20
     C                   EndDo

     C                   Eval      *InLR = *On
     C                   Return
      *----------------------------------------------------------------
      *  Create Order data from tier1 order detail file...
      *----------------------------------------------------------------
      *
     C     @CreateOrd    BegSr

     C                   Eval      ##tierName = %subst(thindx:1:10)
     C                   Eval      ##orgCode = %subst(thindx:11:10)
     C                   Eval      ##orderNo = %subst(thindx:21:15)
     C                   Eval      ##nuke = THNUKE

     C                   Eval      ##SaveMHN = *blanks

     C     WP21_Key      SetLL     RDBWP21
     C     WP21_Key      ReadE     RDBWP21

     C                   DoW       NOT %eof(RDBWP21)

     C                   If        TDMHN <> ##SaveMHN and ##SaveMHN <> *blank
     C                   Exsr      @WriteMHN
     C                   EndIf

     C                   Eval      ##OrderQty += TDSYOS
     C                   Eval      ##SaveMHN = TDMHN
     C                   Exsr      @GetSerialNo
     C                   Eval      TDSERL = ##serl
     C                   Update    RDBWP211

     C                   Exsr      @SaveInput

     C     WP21_Key      ReadE     RDBWP21

     C                   If        %eof(RDBWP21) and ##OrderQty > *zero
     C                   Exsr      @WriteMHN
     C                   LeaveSR
     C                   EndIf

     C                   EndDo

     C                   EndSr
      *----------------------------------------------------------------
      *  Write Order Detail with Summarized Part Quantity...
      *----------------------------------------------------------------
      *
     C     @WriteMHN     BegSr

     C                   Eval      OMHN  = %subst(##SaveMHN:1:12)
     C                   Eval      OSRYO = ##OrderQty

     C                   Except    @DTL
     C                   Eval      OREC = *blanks
     C                   Eval      ##OrderQty= *zero

     C                   EndSr
      *----------------------------------------------------------------
      *  Save Input Detail of Part...
      *----------------------------------------------------------------
      *
     C     @SaveInput    BegSr

     C                   Eval      OSUPC = TDSUPP
     C                   Eval      OTOKU = %char(%editc(TDTOKU:'X'))
     C                   Eval      ONONY = %char(%editc(TDNONY:'X'))
     C                   Eval      ONKOJ = TDNKOJ
     C                   Eval      ODOCK = TDNUKE
     C                   Eval      OKNB# = TDKBAN
     C                   Eval      OSHID = %char(TDSHID)
     C                   Eval      OORD# = %subst(TDODRN:2:10)
     C                   Eval      OSYOS = TDSYOS
     C                   Eval      OSHIT = %char(%editc(TDSHIT:'X'))
     C                   Eval      OSHIN = TDSHN
     C                   Eval      OBIN# = TDNOBN
     C                   Eval      OUSYS = TDQPC
     C                   Eval      OINVN = %trim(TDODRN) + %trim(ODOCK) + ONKOJ
     C                   Eval      O@@H  = 'H'

     C                   EndSr
      *----------------------------------------------------------------
      *  Get Serial Number for Container...
      *----------------------------------------------------------------
     C     @GetSerialNo  BegSr

     C                   Eval      ##chNONY = %char(%editc(TDNONY:'X'))
     C                   Exsr      GetNxtNmbr
     C                   Exsr      WrtPP70

     C                   EndSr
      *----------------------------------------------------------------
      *  get next serial number for container label...
      *----------------------------------------------------------------
      *
     C     GetNxtNmbr    BegSr

     C                   Eval      @@14 = 99999999999999
     C                   Time                    WSDT

     C     TDNONY        Chain     AB#NP30

     C                   Eval      N3UDAT = WSDATE
     C                   Eval      N3UTIM = WSTIME
     C                   Eval      N3UPGM = #PGM
     C                   Eval      N3UUSR = #USER
     C                   Eval      N3UWIS = #WSID

     C                   Eval      N3NONY = TDNONY

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

     C                   Eval      ##serl = ##chNONY +
     C                             %subst(%char(%editc(N3NMBR:'X')):5:14)

     C                   EndSr
      *----------------------------------------------------------------
      *  Write label info to EKANBAN SERIAL -- AB#PP70
      *----------------------------------------------------------------
      *
     C     WrtPP70       BegSr

     C                   Eval      ##shid = TDSHID
     C                   Clear                   AB#PP701
     C                   Eval      EKKOYY = WSYY
     C                   Eval      EKKOMM = WSMM
     C                   Eval      EKKODD = WSDD
     C                   Eval      EKKOHH = WSHH
     C                   Eval      EKKOMN = WSMN
     C                   Eval      EKKOME = #USER
     C                   Eval      EKTOKU = TDTOKU
     C                   Eval      EKNONY = ##chNONY
     C                   Eval      EKNKOJ = TDNKOJ
     C                   Eval      EKNUKE = TDNUKE
     C                   Eval      EKZETI = %char(%editc(TDZETI:'X'))

     C                   Eval      EKSYOS=%char(%editc(TDSYOS:'X'))

     C                   Eval      EKLOC1 = %subst(TDLOCN:1:1)
     C                   Eval      EKLOC2 = %subst(TDLOCN:2:2)
     C                   Eval      EKLOC3 = %subst(TDLOCN:4:2)
     C                   Eval      EKLOC4 = %subst(TDLOCN:6:1)
     C                   Eval      EKODRN = %subst(TDODRN:2:10)
     C                   Eval      EKSHN1 = %subst(TDSHN:1:5)
     C                   Eval      EKSHN2 = %subst(TDSHN:6:5)
     C                   Eval      EKSHN3 = %subst(TDSHN:11:2)
     C                   Eval      EKNOYY = ##noyy
     C                   Eval      EKNOMM = ##nomm
     C                   Eval      EKNODD = ##nodd
     C                   Eval      EKMHN1 = %subst(TDMHN:1:5)
     C                   Eval      EKMHN2 = %subst(TDMHN:6:5)
     C                   Eval      EKMHN3 = %subst(TDMHN:11:5)
     C                   Eval      EKMHN4 = *blanks
     C                   Eval      EKNOBN = TDNOBN
     C                   Eval      EKSERL = ##serl
     C                   Eval      EKRLYY = *zero
     C                   Eval      EKRLMM = *zero
     C                   Eval      EKRLDD = *zero

     C                   Write     AB#PP701
      * LOG
JW1  C                   EXSR      #XP01
      *
     C                   EndSr
JW1   *================================================================
 .    *  ..LABEL DATA ISSUE LOG
 .    *================================================================
     C     #XP01         BEGSR
     C                   Z-ADD     SYSDATE80     IXKOHZ                         TODAY
     C                   TIME                    IXKOTM                         NOW
     C                   MOVEL     EKTOKU        IXTOKU                         CUSTOMER
     C                   MOVEL     EKNONY        IXNONY                         DELIVERY
     C                   MOVEL     EKNKOJ        IXNKOJ                         FACTORY
     C                   MOVEL     EKNUKE        IXNUKE                         DOCK
     C                   MOVEL     EKODRN        IXODRN                         ORDER #
     C                   MOVE      EKSERL        IXSERL                         SERIAL NUMBER
     C                   Z-ADD     EKNOHZ        IXDEDT                         SHIP DATE
     C                   MOVE      EKNOBN        IXNOBN                         BIN#
     C                   MOVEL     'AB#PP70 '    IXWRKF                         LABEL WF
      *
     C                   MOVEL     *BLANK        IXPL#
     C                   MOVEL     #USER         IXKOUS
     C                   MOVEL     #WSID         IXKOWS
     C                   MOVEL     #PGM          IXKOPG
      *
     C                   MOVEL     EKMHIN        IXMHIN
     C                   MOVEL     EKSHIN        IXSHIN
     C                   MOVEL     *BLANK        IXINVN
     C                   MOVEL     *BLANK        IXHPOS
     C                   MOVEL     *BLANK        IXROUT
     C                   Z-ADD     EKSRYO        IXSRYO
     C                   Z-ADD     0             IXSYOS
     C                   Z-ADD     0             IXUSYS
 .    * MANUAL
     C                   MOVE      *BLANK        PNONY
     C                   MOVE      *BLANK        PNKOJ
     C                   MOVE      *BLANK        PNUKE
     C                   Z-ADD     0             PNOHZ
     C                   Z-ADD     0             BIN
     C                   MOVE      *BLANK        PORD#
     C                   MOVE      *BLANK        SER1F
 .   C                   MOVE      *BLANK        SER1T
 .   C                   MOVE      *BLANK        SER2F
 .    *
 .   C                   WRITE     AB#XP1A1
JW1  C                   ENDSR
      *----------------------------------------------------------------
     OAB#WP452  E            @DTL
     O                       OREC               256

     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO)

      * =======================================================================================
      *  AB#R4T11
      *  LEC          2021/11/18
      *  This program will Validate Tier1 Orders uploaded from SQL01 and update order detail
      * =======================================================================================
      *

     FRDBWP20   UF   E           K DISK
     FRDBWP21   UF   E           K DISK
     FAB#PPT1   IF   E           K DISK
     FGADPL11   IF   E           K DISK
     FAB#PL1O   IF   E           K DISK
     FAB#PL19E  IF   E           K DISK
     FFCEPL01   IF   E           K DISK

     D                SDS
     D  #PGM                   1     10
     D  #WSID                244    253
     D  #USER                254    263

     D  ##tierName     S             10
     D  ##orgCode      S             10
     D  ##orderNo      S             15
     D  ##PP10_ord     S                   like(baodrn)
     D  ##nuke         S              4
     D  ##flag         S              1
     D  ##chTOKU       S              4
     D  ##chNONY       S              4
     D  ##SaveMHN      S                   like(TDMHN)
     D  ##locn         S              6A
     D  SysDateISO     S               D   inz(*SYS) datfmt(*iso)               system date (date)
     D  SysDate80      S              8S 0                                      ship date (num)
     D  ##LastBin#     S                   like(banobn)
     D  ##zeti         S              4
     D  ##qpc          S              5S 0
     D  ##HdrValid     S              1N
     D  ##DtlValid     S              1N
     D  ##msg          S                   like(THMSG)
     D  ##orgFound     S              1A

     D                 DS
     D   ##shid                1      8  0
     D   ##noyy                1      4  0
     D   ##nomm                5      6  0
     D   ##nodd                7      8  0

     D                 DS
     D   ##shin                1     12
     D   ##shn1                1      5
     D   ##shn2                6     10
     D   ##shn3               11     12

     D                 DS
     D   ##mhin                1     20
     D   ##mhn1                1      5
     D   ##mhn2                6     10
     D   ##mhn3               11     15
     D   ##mhn4               16     20

      ***  location change date
     D                 DS
     D  LocChgDat              1      8  0
     D  A2TRYY                 1      4  0
     D  A2TRMM                 5      6  0
     D  A2TRDD                 7      8  0

      ***  qpc change date
     D                 DS
     D  QPCChgDat              1      8  0
     D  A2SYYY                 1      4  0
     D  A2SYMM                 5      6  0
     D  A2SYDD                 7      8  0

     D                 DS
     D  WSDT                   1     14  0
     D  WSTIME                 1      6  0
     D  WSDATE                 7     14  0
     D  WSHH                   1      2  0
     D  WSMN                   3      4  0
     D  WSYY                   7     10  0
     D  WSMM                  11     12  0
     D  WSDD                  13     14  0

     C     GAD_Key       KLIST
     C                   KFLD                    TBTOKU
     C                   KFLD                    TBNONY
     C                   KFLD                    TBNKOJ
     C                   KFLD                    ##nuke

     C     WP21_Key      KLIST
     C                   KFLD                    ##tierName
     C                   KFLD                    ##orgCode
     C                   KFLD                    ##orderNo
     C                   KFLD                    ##nuke

     C     PL1O_Key      KLIST
     C                   KFLD                    TBTOKU
     C                   KFLD                    TBNONY
     C                   KFLD                    ##noyy
     C                   KFLD                    ##nomm
     C                   KFLD                    ##nodd
     C                   KFLD                    TBNKOJ
     C                   KFLD                    ##nuke
     C                   KFLD                    ##PP10_ord

     C     PL19E_Key     KLIST
     C                   KFLD                    TBNONY
     C                   KFLD                    ##shid

     C     FCE_Key       KLIST
     C                   KFLD                    ##shn1
     C                   KFLD                    ##shn2
     C                   KFLD                    ##shn3

     C     PPT1_Key      KLIST
     C                   KFLD                    ##tierName
     C                   KFLD                    ##orgCode

     C                   MoveL     SysDateISO    SysDate80
      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------

      *  validate uploaded Tier1 orders...
     C     *start        SetLL     RDBWP20
     C                   Read      RDBWP20

     C                   DoW       NOT %eof(RDBWP20)

     C                   Exsr      @ValidateH

     C                   If        ##HdrValid
     C                   Exsr      @ValidateD

     C                   If        ##DtlValid
     C                   Eval      THMSG = 'Validated'
     C                   Update    RDBWP201
     C                   Exsr      @UpdDetail
     C                   Else
     C                   Eval      THMSG = 'Detail Validation Failed'
     C                   Update    RDBWP201
     C                   EndIf

     C                   EndIf

     C                   Read      RDBWP20
     C                   EndDo

     C                   Exsr      @UpdateSts

     C                   Eval      *InLR = *On
     C                   Return
      *----------------------------------------------------------------
      *  Validate the order Header data...
      *----------------------------------------------------------------
      *
     C     @ValidateH    BegSr

     C                   Eval      ##HdrValid = *Off

     C                   Eval      ##tierName = %subst(thindx:1:10)
     C                   Eval      ##orgCode = %subst(thindx:11:10)
     C                   Eval      ##orderNo = %subst(thindx:21:15)
     C                   Eval      ##nuke = THNUKE
     C                   Eval      ##PP10_ord = %subst(##orderNo:2:10)

      *  tier name/org code ---> cust code/delivery code validation...
      *
     C                   Eval      ##orgFound = 'N'
      *
     C     PPT1_Key      SetLL     AB#PPT1
     C     PPT1_Key      ReadE     AB#PPT1
      *
     C                   DoW       NOT %eof
      *
     C                   If        TBNUKE = THNUKE
     C                   Eval      ##orgFound = 'Y'
     C                   Leave
     C                   EndIf
      *
     C     PPT1_Key      ReadE     AB#PPT1
     C                   EndDo

     C                   If        ##orgFound = 'N'
     C                   Eval      THMSG = 'Org Code Not Registered in AB#PPT1'
     C                   Update    RDBWP201
     C                   Exsr      @DelDetail
     C                   LeaveSR

     C                   Else

      *  dock code registration...
     C     GAD_Key       Chain     GADPL11
     C                   If        NOT %found
     C                   Eval      THMSG = 'Dock Code Not Registered in ShipMst'
     C                   Update    RDBWP201
     C                   Exsr      @DelDetail
     C                   LeaveSR

     C                   Else

      *  duplicate order check...

      *  first get order ship date from detail file...
     C     WP21_Key      Chain(N)  RDBWP21
     C                   If        %found
     C                   Eval      ##shid = TDSHID

     C     PL1O_Key      SetLL     AB#PL1O
     C     PL1O_Key      ReadE     AB#PL1O
     C                   DoW       NOT %eof
     C                   If        BASKJY = *blank
     C                   Eval      THMSG = 'Duplicate Order'
     C                   Update    RDBWP201
     C                   Exsr      @DelDetail
     C                   LeaveSR
     C                   EndIf
     C     PL1O_Key      ReadE     AB#PL1O
     C                   EndDo

     C                   Else

     C                   Eval      THMSG = 'No Order Detail'
     C                   Update    RDBWP201
     C                   LeaveSR
     C                   EndIf

     C                   EndIf

     C                   EndIf

     C                   Eval      ##HdrValid = *On

     C                   EndSr
      *----------------------------------------------------------------
      *  Validate the order Detail data...
      *----------------------------------------------------------------
      *
     C     @ValidateD    BegSr

     C                   Eval      ##DtlValid = *On

     C     WP21_Key      SetLL     RDBWP21

     C                   DoW       NOT %eof(RDBWP21)

     C     WP21_Key      ReadE     RDBWP21

     C                   If        %eof(RDBWP21)
     C                   LeaveSR
     C                   EndIf

     C                   Eval      TDTOKU = TBTOKU
     C                   Eval      TDNONY = TBNONY
     C                   Eval      TDNKOJ = TBNKOJ

     C                   If        TDMHN <> ##SaveMHN
     C                   Exsr      @GetPartInfo
     C                   EndIf
     C                   Eval      ##SaveMHN = TDMHN

     C                   Eval      TDZETI = %dec(##ZETI:4:0)
     C                   If        ##zeti = *blanks OR ##zeti = '0000'
     C                   Eval      TDSHN = *blanks
     C                   Eval      TDMSG = 'Part Number Not Found in Part Mstr'
     C                   Update    RDBWP211
     C                   Eval      ##DtlValid = *Off
     C                   Iter
     C                   Else
     C                   Eval      TDSHN = ##shin
     C                   EndIf

     C                   Eval      TDSYOS = ##qpc

     C                   If        TDQPC <> TDSYOS
     C                   Eval      TDMSG = 'Customer QPC Does NOT Match IAF QPC'
     C                   Update    RDBWP211
     C                   Eval      ##DtlValid = *Off
     C                   Iter
     C                   EndIf

     C                   Clear                   RDBWP211
     C                   EndDo

     C                   EndSr
      *----------------------------------------------------------------
      *  Delete order from detail file...
      *----------------------------------------------------------------
      *
     C     @DelDetail    BegSr

     C                   DoU       Not %found(RDBWP21)
     C     WP21_Key      Delete    RDBWP21
     C                   EndDo

     C                   EndSr
      *----------------------------------------------------------------
      *  Update order detail file...
      *----------------------------------------------------------------
      *
     C     @UpdDetail    BegSr

      * get next bin number for delivery code/ship date...
     C                   Exsr      @GetBinNum

     C     WP21_Key      SetLL     RDBWP21
     C     WP21_Key      ReadE     RDBWP21

     C                   DoW       NOT %eof(RDBWP21)

     C                   Eval      TDTOKU = TBTOKU
     C                   Eval      TDNONY = TBNONY
     C                   Eval      TDNKOJ = TBNKOJ

     C                   If        TDMHN <> ##SaveMHN
     C                   Exsr      @GetPartInfo
     C                   EndIf
     C                   Eval      ##SaveMHN = TDMHN
     C                   Eval      TDLOCN = ##locn

     C                   Eval      TDZETI = %dec(##ZETI:4:0)
     C                   Eval      TDSHN = ##shin

     C                   Eval      TDNOBN = %char(%editc(##LastBin#:'X'))
     C                   Eval      TDSYOS = ##qpc

     C                   Update    RDBWP211
     C     WP21_Key      ReadE     RDBWP21

     C                   EndDo

     C                   EndSr
      *----------------------------------------------------------------
      *  Get IAF part number file, Location, Absolute Part Id...
      *----------------------------------------------------------------
     C     @GetPartInfo  BegSr

      * get iaf part number...
     C                   Eval      ##chTOKU = %char(%editc(TDTOKU:'X'))
     C                   Eval      ##chNONY = %char(%editc(TDNONY:'X'))
     C                   Eval      ##mhin = TDMHN

     C                   Call      'BBHR50'
     C                   Parm                    ##chTOKU
     C                   Parm                    ##chNONY
     C                   Parm                    TBNKOJ
     C                   Parm                    ##nuke
     C                   Parm                    ##mhin
     C                   Parm                    ##shin
     C                   Parm                    ##flag

      * get iaf part location and absolute id from part master...
     C     FCE_Key       Chain     FCEPL01
     C                   If        %found(FCEPL01)
     C                   Eval      ##zeti = A2ZETI

     C                   If        LocChgDat > SysDate80
     C                   Eval      ##locn = A2KTRK + A2KTRT + A2KTRR + A2KTRD
     C                   Else
     C                   Eval      ##locn = A2STRK + A2STRT + A2STRR + A2STRD
     C                   EndIf

     C                   If        QPCChgDat > SysDate80
     C                   Eval      ##qpc = A2KSYS
     C                   Else
     C                   Eval      ##qpc = A2SSYS
     C                   EndIf

     C                   Else

     C                   Eval      ##zeti = '0000'
     C                   Eval      ##locn = *blanks
     C                   Eval      ##qpc  = *zero
     C                   EndIf

     C                   EndSr
      *----------------------------------------------------------------
      *  Get Bin Number for Order...
      *----------------------------------------------------------------
     C     @GetBinNum    BegSr

     C     PL19E_Key     SetGT     AB#PL19E
     C     PL19E_Key     ReadPE    AB#PL19E
     C                   If        NOT %eof
     C                   Eval      ##LastBin# = BANOBN
     C                   Else
     C                   Eval      ##LastBin# = *zero
     C                   EndIf

      * next bin# = last bin# + 1...
     C                   Eval      ##LastBin# += 1

     C                   EndSr
      *----------------------------------------------------------------
      *  Update Order Statuses for all Docks for Tier1/OrgCode/Order...
      *----------------------------------------------------------------
     C     @UpdateSts    BegSr

      *  if one dock has error for a Tier1/OrgCode/Order, then all docks fail validation...
      *     this is for SQL server side of the process...

     C     *start        SetLL     RDBWP20
     C                   Read      RDBWP20

     C                   DoW       NOT %eof(RDBWP20)

     C                   If        THMSG <> 'Validated'
     C                   Eval      ##msg = THMSG

     C     THINDX        Chain     RDBWP20
     C                   DoW       NOT %eof(RDBWP20)
     C                   Eval      THMSG = ##msg
     C                   Update    RDBWP201
     C     THINDX        ReadE     RDBWP20
     C                   EndDo

     C     THINDX        SetGT     RDBWP20
     C                   EndIf

     C                   Read      RDBWP20

     C                   EndDo

     C                   EndSr
      *----------------------------------------------------------------

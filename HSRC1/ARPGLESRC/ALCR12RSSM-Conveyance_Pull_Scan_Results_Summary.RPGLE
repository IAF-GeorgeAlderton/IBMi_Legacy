     H OPTION(*SRCSTMT : *NODEBUGIO) DATEDIT(*YMD/)

     FAM#PW45G  CF   E             WORKSTN
     F                                     SFILE(SFL010:RRN1)
     F                                     INFDS(@INFDS)
     FAM#WP45G  IF   E           K DISK

     D TM              S              6A   DIM(200)

     D DTL             DS                  OCCURS(200)
     D  MSG                          40A   DIM(999)
     D  CNT                           4  0 DIM(999)

     D @INFDS          DS
     D  @STTS            *STATUS
     D  @@LIN                370    371B 0
     D  @@REC                378    379B 0

     D                SDS
     D  #PGM                   1     10
     D  XXUSER               254    263

     D  @HRS           DS
     D  @HR01                  1      2S 0
     D  @HR02                  3      4S 0
     D  @HR03                  5      6S 0
     D  @HR04                  7      8S 0
     D  @HR05                  9     10S 0
     D  @HR06                 11     12S 0
     D  @HR07                 13     14S 0
     D  @HR08                 15     16S 0
     D  @HR09                 17     18S 0
     D  @HR10                 19     20S 0
     D  @HR11                 21     22S 0
     D  @HR12                 23     24S 0

     D  @SA            DS
     D  @SA01                  1      2
     D  @SA02                  3      4
     D  @SA03                  5      6
     D  @SA04                  7      8
     D  @SA05                  9     10
     D  @SA06                 11     12
     D  @SA07                 13     14
     D  @SA08                 15     16
     D  @SA09                 17     18
     D  @SA10                 19     20
     D  @SA11                 21     22
     D  @SA12                 23     24

     D  RRN1           S              2  0
     D  @ind           S              2  0
     D  @Hour          S              2  0
     D  SysHour        S              2  0
     D  SysHRc         S              2
     D  X              S              2  0
     D  F              S              2  0
     D  TopOfScale     S              2  0
     D  W#RNP1         S              4  0
     D  #RNP1          S              4  0

     C     *ENTRY        PLIST
     C                   PARM                    InHR              2
      *
      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------
      *
     C                   DoU       *IN01 = *ON
     C                   Exsr      $INIT
     C                   Exsr      $FILL
      *
      *  display screen until F1
     C                   Write     DATAFOOT
     C                   Eval      #RCN01 = W#RNP1
     C                   ExFmt     CTL010
      *
     C                   EndDo
      *
      *-------------------------
      *
     C                   Eval      *InLR = *On
     C                   Return
      *
      *----------------------------------------------------------------
      *  Initialize subfile
      *----------------------------------------------------------------
     C     $INIT         BegSr
      *
     C                   Eval      RRN1 = *zero
     C                   Eval      SysHour = %dec(%subdt(%time:*hours):2:0)

     C                   Eval      *IN30 = *On
     C                   Write     CTL010
     C                   Eval      *IN30 = *Off
      *
     C                   Eval      #RNP1 = 1
     C                   If        InHR = *blanks
     C                   Eval      @Hour = SysHour
     C                   Else
     C                   Eval      @Hour = %dec(InHR:2:0)
     C                   EndIf
      *
      * load HRS array...
     C                   Do        12            @ind
     C                   Eval      HRS(@ind) = @Hour + (@ind - 1)
     C                   If        HRS(@ind) >= 24
     C                   Eval      HRS(@ind) = HRS(@ind) - 24
     C                   EndIf
     C                   EndDo

     C                   Eval      @HR01 = HRS(1)
     C                   Eval      @HR02 = HRS(2)
     C                   Eval      @HR03 = HRS(3)
     C                   Eval      @HR04 = HRS(4)
     C                   Eval      @HR05 = HRS(5)
     C                   Eval      @HR06 = HRS(6)
     C                   Eval      @HR07 = HRS(7)
     C                   Eval      @HR08 = HRS(8)
     C                   Eval      @HR09 = HRS(9)
     C                   Eval      @HR10 = HRS(10)
     C                   Eval      @HR11 = HRS(11)
     C                   Eval      @HR12 = HRS(12)

      * load SCA array... SCA(1)=30.....SCA(15)=2
     C                   Eval      TopOfScale=32

     C                   Do        15            @ind
     C                   Eval      TopOfScale = TopOfScale - 2
     C                   Eval      SCA(@ind) = TopOfScale
     C                   EndDo
      *
     C                   EndSr
      *
      *----------------------------------------------------------------
      *  fill subfile with hourly amounts.
      *
     C     $FILL         BegSr
      *
      *
      * load count array with workfile counts...

     C                   Read      AM#WP45G                               90
     C                   DoW       *In90 = *Off

     C                   Eval      X = 1
     C     WKHRS         Lookup    HRS(X)                                 10
     C                   If        *IN10 = *On
     C                   Eval      CNT(X) = WKCNT
     C                   EndIf

     C                   Read      AM#WP45G                               90
     C                   EndDo
      *
      * calculate total pallets...
     C                   Eval      @TOTL = %xfoot(CNT)

      *  do for the 12 hours
      *
     C     1             Do        15            R                 2 0

     C                   CLEAR                   SFL010

     C     31            Do        42            Z                 2 0
     C                   Eval      *IN(Z) = *Off
     C                   EndDo

     C                   Eval      F = 30
     C     1             Do        12            C                 2 0

     C                   If        %REM(SCA(R):10) = 0
     C                   Eval      @SCALE = SCA(R)
     C                   EndIf
      *
      * read through CNT array and determine if indicators
      *       31 - 42 should be turned on...
      *
     C                   Eval      F += 1
     C                   If        CNT(C) >= SCA(R)
     C                   Eval      *IN(F) = *On
     C                   EndIf

      * this is to put count at the top of the bar...
     C                   Select
     C                   When      R = 1
     C                   If        CNT(C) >= SCA(R)
     C                   Eval      SCT(C) = %char(CNT(C))
     C                   EndIf
     C                   When      R > 1
     C                   If        CNT(C) >= SCA(R) and CNT(C) < SCA(R-1)
     C                   Eval      SCT(C) = %char(CNT(C))
     C                   EndIf
     C                   EndSl

     C                   EndDo

     C                   MOVEA     SCT           @SA

     C                   Eval      RRN1 += 1
     C                   Write     SFL010                                 90
     C                   Eval      @SCALE = *zero
     C                   Eval      SCT = *blanks
     C                   EndDo

     C                   EndSr

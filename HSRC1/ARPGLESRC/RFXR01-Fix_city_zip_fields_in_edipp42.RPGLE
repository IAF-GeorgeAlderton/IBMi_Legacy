     H option(*nodebugio:*srcstmt)
      //************************************************************************
      // RFXR01
      // LEC          2017/07/27
      // This program updates city and zip fields in edipp42 by extracting them
      // from address fields in edipp40.
      //************************************************************************

     FEDIPP40   IF   E             DISK
     FEDIPP42   UF   E           K DISK

     D Pos             S              6S 0                                      position
     D UpdateFlag      S              1                                         update pp42
     D Addr            S                   like(e4add3)
     D City            S                   like(e4city)
     D ZipC            S                   like(e4zipc)
     D Alpha           S             30    inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ. /-') alpha chars

      **********************************************************************************
      *         M    A    I    N    L    I    N    E
      *
      *
      *
     C                   Do        *HiVal
      *
     C                   Read      EDIPP40                                50
     C                   If        *In50 = *On
     C                   Leave
     C                   EndIf
      *
     C                   Eval      UpdateFlag = 'N'
      *
     C     ','           Scan      E4ADD3:1      Pos                      51
     C                   If        *In51 = *On
     C                   Eval      Addr = E4ADD3
     C                   Exsr      Extract
     C                   Else
     C     ','           Scan      E4ADD4:1      Pos                      51
     C                   If        *In51 = *On
     C                   Eval      Addr = E4ADD4
     C                   Exsr      Extract
     C                   EndIf
     C                   EndIf
      *
     C                   If        UpdateFlag = 'Y'
     C                   Exsr      UpdPP42
     C                   EndIf
      *
     C                   EndDo
      *
     C                   Eval      *InLR = *On
     C                   Return
      *
     **********************************************************************************
     * Purpose: extract the city, state and zip code from address fields.
      *
    C     Extract       BegSr
      *
     C                   Eval      City = %trim(%subst(Addr:1:Pos-1))
     C                   Eval      Pos += 1
     C     Alpha         Check     Addr:Pos      Pos                      51
     C                   If        *In51 = *On
     C                   Eval      ZipC = %trim(%subst(Addr:Pos:10))
     C                   EndIf
      *
     C                   If        City > *blanks OR ZipC > *blanks
     C                   Eval      UpdateFlag = 'Y'
     C                   EndIf
      *
    C                   EndSr
      *
     **********************************************************************************
     * Purpose: update edipp42 with state and zip code.
      *
    C     UpdPP42       BegSr
      *
     C     E4NONY        Chain     EDIPP42
     C                   If        %found
     C                   Eval      E4CITY = City
     C                   Eval      E4ZIPC = ZipC
     C                   Update    EDIPP421
     C                   Clear                   EDIPP421
     C                   EndIf
      *
    C                   EndSr
      *
     **********************************************************************************

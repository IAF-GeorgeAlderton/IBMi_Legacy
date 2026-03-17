     H option(*nodebugio:*srcstmt)
      //************************************************************************
      // RTVR01
      // LEC          2017/05/19
      // This program calculates the Total # of Pallets and updates each record
      // with Current Pallet #, Total # of Pallets.
      //************************************************************************

     FAB#WP2L   UF   E             DISK    USROPN
     FAB#WP43SR IF   E           K DISK

     D Total_Pallets   S              2S 0
     D Pallet_Key      S             31
     D PKEY            S             31    Dim(99)
     D N               S              2S 0                                      index
     D SR              S              1                                         special rack?
     D KEY1            S              7                                         key for ab#wp43sr
      **********************************************************************************
      *         M    A    I    N    L    I    N    E
      *
      *
      ***   initialize all elements to Z, so that after sorting the array all blank elements
      ***   will be at the bottom of the array.
     C                   Do        99
     C                   Eval      N = N + 1
     C                   Eval      PKEY(N) = 'Z'
     C                   EndDo
     C                   Eval      N = *zero
      *
      *
      ***   first get the total number of pallets for this shipment.
     C                   Open      AB#WP2L
      *
     C                   Do        *HiVal
      *
     C                   Read(N)   AB#WP2L                                50
     C                   If        *In50 = *On
     C                   Leave
     C                   EndIf
      *
      ***  determine if this is a special rack
     C                   Eval      SR = 'N'
     C                   Eval      KEY1 = H2NUKE
      *
     C     KEY1          Chain     AB#WP43SR                          55
     C                   If        %found
     C                   Eval      SR = 'Y'
     C                   EndIf
      *
      ***  pallet key is the unique identifier for a pallet. Subaru internal cycle + Pallet Code
      ***  + Order Code.
     C                   Eval      Pallet_Key = SR + L2WHLC + L2FTLC + L2SERI
      *
      ***  accumulate pallet total by tracking all unique pallet keys.
     C     Pallet_Key    Lookup    PKEY                                   10
     C                   If        *In10 = *Off and Pallet_Key <> *blanks
     C                   Eval      N = N + 1
     C                   Eval      PKEY(N) = Pallet_Key
     C                   EndIf
      *
     C                   EndDo
      *
     C                   Close     AB#WP2L
      *
      ***  keep total number of pallets.
     C                   Eval      Total_Pallets = N
      *
      ***  sort pallet key array to get the special racks at the bottom.
     C                   SortA     PKEY
      *
      *
      ***   now update the workfile with pallet number and total pallets.
      *
     C                   Open      AB#WP2L
      *
     C                   Do        *HiVal
      *
     C                   Read      AB#WP2L                                50
     C                   If        *In50 = *On
     C                   Leave
     C                   EndIf
      *
      ***  determine if this is a special rack
     C                   Eval      SR = 'N'
     C                   Eval      KEY1 = H2NUKE
      *
     C     KEY1          Chain     AB#WP43SR                          55
     C                   If        %found
     C                   Eval      SR = 'Y'
     C                   EndIf
      *
      ***  get unique pallet key again
     C                   Eval      Pallet_Key = SR + L2WHLC + L2FTLC + L2SERI
      *
      ***  get pallet number by finding array element in list of unique pallet keys.
     C                   Eval      N = 1
     C     Pallet_Key    Lookup    PKEY(N)                                10
     C                   If        *In10 = *On and Pallet_Key <> *blanks
     C                   Eval      H2LOC2 = %editc(N:'X')
     C                   Eval      H2LOC3 = %editc(Total_Pallets:'X')
     C                   Update    AB#WP2L1
     C                   EndIf
      *
     C                   EndDo
      *
     C                   Close     AB#WP2L
      *
     C                   Eval      *InLR = *On
     C                   Return
      **********************************************************************************

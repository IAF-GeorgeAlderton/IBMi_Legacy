     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IZAR465UL ****************************************************
      *  Convert Charter Steel Wire WF into Wire Coil Data MF
      *   LEC   2025.09.26
      *****************************************************************
     FIZAWP10   IF   E           K DISK
     FFGBPL01   IF   E           K DISK
     FIZAPP65   UF A E           K DISK
      *
     D PSUPP           S              4S 0
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
      *
      *----------------------------------------------------*
      *  M  A  I  N  L  I  N  E
      *----------------------------------------------------*
     C                   Time                    SDATE
      *
     C                   Read      IZAWP10

     C                   DoW       NOT %eof(IZAWP10)

      * get supplier name...
     C                   Eval      PSUPP = %dec(U1FLDJ:4:0)
     C     PSUPP         Chain     FGBPL01
     C                   If        %found
     C                   Eval      IWSUPP = B2SMEI
     C                   Else
     C                   Leave
     C                   EndIf

      * material name
     C                   Eval      IWMATN = U1FLDA
      * diameter
     C                   Eval      IWDIAM = %dec(U1FLDB:5:2)
      * po number
     C                   Eval      IWPONO = U1FLDC
      * heat#
     C                   Eval      IWHEAT = U1FLDD
      * serial#
     C                   Eval      IWSERL = U1FLDE
      * grade and descr
     C                   Eval      IWGRDS = U1FLDF
      * weight
     C                   Eval      IWWGT = %dec(U1FLDG:5:1)
      * draw machine
     C                   Eval      IWMCH# = U1FLDI
      * order date
     C                   Eval      IWPRDT = %dec(U1FLDK:8:0)
      * ship date
     C                   Eval      IWSHDT = %dec(U1FLDL:8:0)
      * mfg#
     C                   Eval      IWMFG# = U1FLDM
      * coil#
     C                   Eval      IWCOIL = U1FLDN
      * material type
     C                   Eval      IWMTYP = U1FLDO
      * test type
     C                   Eval      IWTTYP = U1FLDP
      * results
     C                   Eval      IWRSLT = %dec(U1FLDQ:5:1)
      * job id
     C                   Eval      IWJOB  = U1FLDR
      *
     C                   Write     IZAPP651
     C                   Clear                   IZAPP651

     C                   Read      IZAWP10
     C                   EndDo
      *
     C                   Eval      *INLR = *On
      *
     C                   Return
      *
      *******************************************************************

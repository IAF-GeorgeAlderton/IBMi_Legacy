          // ***********************************************************
          //  Toyota SCS - Check SP Country of Origin file downloaded from Website
          //               to make sure part# is registered.
          //               If not, call program to Send COO info for part in .json format to SCS.
          //  LEC            2022.05.20
          // ***********************************************************
          //

     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO)

     FAM#PP435  IF   E           K DISK

     D                SDS
     D  #PGM                   1     10
     D  #USER                254    263

     D  WKCD           S              6A
     D  PART#          S             12A

      *----------------------------------------------------------------

     C     *Entry        PLIST
     C                   Parm                    WKCD
     C                   Parm                    PART#

     C     Key435        KLIST
     C                   KFLD                    PART#

      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------

      *  check SCS Part# Country of Origin file downloaded from Website for Part#...
     C     Key435        Chain     AM#PP435

     C                   If        NOT %found
     C                   Call      'AM#C435S'
     C                   Parm                    WKCD
     C                   Parm                    PART#
     C                   EndIf

     C                   Eval      *InLR = *On
     C                   Return
      *----------------------------------------------------------------

     H option(*nodebugio:*srcstmt)
      //************************************************************************
      // RDBR02
      // LEC          2016/12/15
      // This program reformats the Great Plains PO workfiles into existing EDI
      // workfile.
      //************************************************************************

     FRDBWP10   IF   E           K DISK
     FRDBWP11   IF   E           K DISK
     FRDBWP55   IF   E           K DISK
     FRDBWP60   IF   E           K DISK
     FEDIWP60   O  A E             DISK

     D Pos             S              6S 0                                       position

     C     *Entry        PList
     C                   Parm                    In_PO#           17
     C                   Parm                    In_LocnId        15

     C     WP11_Key      KList
     C                   KFld                    R1PO#

     C     WP55_Key      KList
     C                   KFld                    R2PO#
     C                   KFld                    R2ORD
     C                   KFld                    R2CMID

      **********************************************************************************
      *         M    A    I    N    L    I    N    E
      *
      *  make sure both parameters were passed in, if not end program.
     C                   If        In_PO# <> *blanks  AND  In_LocnId <> *blanks
      *
      *  get main company information...
     C     In_LocnId     Chain     RDBWP60
     C                   If        %found
      *
      *  get purchase order info from header file...
     C     In_PO#        Chain     RDBWP10
     C                   If        %found
      *
      *  get all purchase order detail info from detail file and write to edi workfile...
     C     WP11_Key      Chain     RDBWP11                            50
     C                   DoW       *In50 = *Off
      *
      * some fields have to have a blank added to the beginning because joe's pgm to process
      * this file is expecting it. used to pull from csv file but now doesn't.
     C                   Eval      D6EDDT = R1LEDT
     C                   Eval      D6VPH1 = ' ' + R1PPHO
     C                   Eval      D6VFAX = ' ' + R1PFAX
     C                   Eval      D6PO#  = R1PO#
     C                   Eval      D6HOLD = ' ' + %char(R1HOLD)
     C                   Eval      D6DCDT = R1DCDT
     C                   Eval      D6REV# = ' ' + %char(R1REV#)
     C                   Eval      D6SHMD = R1SHPM
     C                   Eval      D6PYTM = R1PYTR
     C                   Eval      D6BYID = R1BYID
     C                   Eval      D6VNAM = R1VNNM
     C                   Eval      D6VAD1 = R1PAD1
     C                   Eval      D6VAD2 = R1PAD2
     C                   Eval      D6VAD3 = R1PAD3
     C                   Eval      D6VCTY = R1PCTY
     C                   Eval      D6VSTT = R1PSTA
     C                   Eval      D6VZIP = R1PZIP
     C                   Eval      D6RQDT = R1RQDT
     C                   Eval      D6VID  = R1VNID
     C                   Eval      D6CID  = %char(R1CMID)
     C                   Eval      D6VADC = R1VCPD
      *
     C                   Eval      D6MDDT = R2OPDT
     C                   Eval      D6PHN1 = ' ' + R2PHN1
     C                   Eval      D6FAX  = ' ' + R2FAX#
     C                   Eval      D6DESC = R2ITDS
     C                   Eval      D6VHIN = R2VITM
     C                   Eval      D6VDSC = R2VIDS
     C                   Eval      D6FOB  = ' ' + %char(R2FOB)
     C                   Eval      D6UM   = R2UOFM

     C                   Evalr     D6ODQT = %editc(R2OQTY:'P')
     C     ' '           Check     D6ODQT        Pos
     C                   If        Pos > *zero
     C                   Eval      D6ODQT = %subst(D6ODQT:Pos:20 - Pos + 1)
     C                   Eval      D6ODQT = ' ' + D6ODQT
     C                   EndIf
      *
     C                   Evalr     D6UP   = %editc(R2UCST:'P')
     C     ' '           Check     D6UP          Pos
     C                   If        Pos > *zero
     C                   Eval      D6UP = %subst(D6UP:Pos:20 - Pos + 1)
     C                   Eval      D6UP = ' ' + D6UP
     C                   EndIf
      *
     C                   Evalr     D6EXT  = %editc(R2ECST:'P')
     C     ' '           Check     D6EXT         Pos
     C                   If        Pos > *zero
     C                   Eval      D6EXT= %subst(D6EXT:Pos:20 - Pos + 1)
     C                   Eval      D6EXT= ' ' + D6EXT
     C                   EndIf
      *
      *
      *  get comments from detail comments file...
     C     WP55_Key      Chain     RDBWP55                            55
     C                   If        *In55 = *Off
     C                   Eval      D6COM1 = R3COM1
     C                   Eval      D6COM2 = R3COM2
     C                   Eval      D6COM3 = R3COM3
     C                   Eval      D6COM4 = R3COM4
     C                   EndIf
      *
     C                   Eval      D6WLOC = R4LCID
     C                   Eval      D6WNM  = R4LCNM
     C                   Eval      D6WACD = R4ADCD
     C                   Eval      D6WCCD = R4CONT
     C                   Eval      D6WAD1 = R4ADR1
     C                   Eval      D6WAD2 = R4ADR2
     C                   Eval      D6WAD3 = R4ADR3
     C                   Eval      D6WCTY = R4CITY
     C                   Eval      D6WSTT = R4STAT
     C                   Eval      D6WZIP = R4ZIPC
     C                   Eval      D6WCRY = R4CNTR
      *
     C                   Write     EDIWP601
     C                   Clear                   EDIWP601
      *
     C     WP11_Key      ReadE     RDBWP11                                50
     C                   EndDo
      *
     C                   EndIf
     C                   EndIf
     C                   EndIf
      *
     C                   Eval      *InLR = *On
     C                   Return
      **********************************************************************************

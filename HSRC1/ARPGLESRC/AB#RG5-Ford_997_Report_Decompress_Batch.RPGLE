     F***************************************************
     F*  Generate 997 Report.                           *
     F*  Unwrap 80 byte file to Dcmfil.                 *
     F*  To Compile program, enter command:             *
     F*    CRTPF FILE(QTEMP/DCMFIL) RCDLEN(2000)        *
     F***************************************************
     FCmpfil    If   E             Disk    Rename(Cmpfil:Cmpfilr)
     F                                     Prefix(X:1)
     FDcmfil    O  A E             Disk    Rename(Dcmfil:Dcmfilr)
     F                                     Prefix(X:1)
     D S               S              2  0
     D L               S              2  0
     D X12EDIF         S              1
     D Col123          S              3
     D Isa01a          S              1
     D Isa03a          S              1
     D Arro            S              1    DIM(2000)
     D                 DS
     D  Arri                   1     80    DIM(80)
     D  Xmpfil                 1     80
     C                   READ      Cmpfil                                 90
     C     *IN90         DOWEQ     *OFF
     C                   If        Xmpfil= *Blanks
     C                   Read      Cmpfil                                 90
     c                   Iter
     c                   Endif
      *
     C     3             Subst     Xmpfil:1      Col123            3
     C     1             Subst     Xmpfil:5      ISA01A            1
     C     1             Subst     Xmpfil:19     ISA03A            1
     C     3             Subst     Xmpfil:5      UNB01A            3
      *
     C     COL123        IFNE      'ISA'
     C     COL123        Andne     'UNB'
     C     *IN55         ANDEQ     *OFF
     C                   READ      Cmpfil                                 90
     C                   ENDIF
      *
     C     COL123        IFEQ      'ISA'
     C     ISA01A        ANDEQ     '0'
     C     ISA03A        ANDEQ     '0'
     C     1             Subst     Xmpfil:4      Ele               1
     C                   MOVE      *ON           *IN55
     C                   Eval      X12EDIF = 'X'
     C                   READ      Cmpfil                                 90
     C     2             Subst     Xmpfil:1      Chkgs             2
     C     1             Subst     Xmpfil:3      Chkele            1
     C                   If        Chkgs <> 'GS' or Chkele <> ele
     C     1             Subst     Xmpfil:26     Chkdim            1
     C                   READP     Cmpfil                                 90
     C                   else
     C                   Exsr      Wrtrecsr
     C                   Endif
     C                   ENDIF
      *
     C                   If        %eof(Cmpfil )
     C                   Leave
     C                   Endif
     C                   If        Unwrap = 'X'
     C                   Eval      Unwrap = *Blanks
     C                   READ      Cmpfil                                 90
     C                   Iter
     C                   Endif
     C     COL123        IFNE      'ISA'
     C     COL123        ANDNE     'UNB'
     C     *IN57         ANDEQ     *ON
     C                   READ      Cmpfil                                 90
     C                   ITER
     C                   ENDIF
      *
     C                   Eval      *in57 = *off
     C                   ADD       1             O                 3 0
     C                   Z-ADD     1             I                 3 0
     C                   MOVE      ARRI(I)       ARRO(O)
     C* DO LOOP 1-80 BYTES
     C     I             DOWLT     80
     C     ARRI(I)       IFEQ      CHKDIM
     C                   Movea     ARRO          Xcmfil
     C                   WRITE     Dcmfilr
      *
     C                   Z-ADD     0             O
     C                   MOVEL     ARRO(1)       IEACHK            2
     C                   MOVE      ARRO(2)       IEACHK
     C                   MOVE      ARRO(3)       IEACH1            3
     C                   MOVEL     IEACHK        IEACH1
     C                   If        X12Edif = 'X' and IEACH1 = 'IEA'
     C                   Move      *ON           *In57
     C                   Endif
     C                   MOVE      *BLANK        ARRO
     C                   ENDIF
      *
     C                   Eval      S = I + 1
     C***                Eval      L = 80 - S
     C                   Eval      L = 80 - I
      *
     C                   If        %subst(Xmpfil: S : L) <> *Blanks
     C                              and *in57 = *on
     C                   Eval      *in57 = *off
     C                   Endif
      *
     C                   ADD       1             O                 3 0
     C                   ADD       1             I                 3 0
     C                   MOVE      ARRI(I)       ARRO(O)
     C   57              Z-ADD     80            I
     C   57              Z-ADD     0             O
     C                   ENDDO
     C** IF 80TH BYTE
     C     ARRI(I)       IFEQ      CHKDIM
     C                   Movea     ARRO          Xcmfil
     C                   WRITE     Dcmfilr
     C                   Z-ADD     0             O
     C                   MOVEL     ARRO(1)       IEACHK            2
     C                   MOVE      ARRO(2)       IEACHK
     C                   MOVE      ARRO(3)       IEACH1            3
     C                   MOVEL     IEACHK        IEACH1
     C     IEACH1        COMP      'IEA'                                  57
     C                   MOVE      *BLANK        ARRO
     C                   ENDIF
     C                   READ      Cmpfil                                 90
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
      *
     C     Wrtrecsr      Begsr
     C                   Move      'X'           Unwrap            1
     C     ' '           Checkr    Xmpfil        Pos               2 0
     C     1             Subst     Xmpfil:Pos    Chkdim
     C                   READP     Cmpfil                                 90
     C                   Dow       Not %eof(Cmpfil )
     C     3             Subst     Xmpfil:1      Col123
     C                   If        Col123 = 'ISA'
     C                   Move      Chkdim        Rec26            26
     C     Xmpfil        Cat(P)    rec26         Rec106          106
     C                   Movel(P)  Rec106        Xcmfil
     C                   else
     C     Xmpfil        Cat(P)    Chkdim        Rec81            81
     C                   Movel(P)  REc81         Xcmfil
     C                   endif
     C                   Write     Dcmfilr
     C                   If        Col123 = 'IEA'
     C                   Leave
     C                   Endif
     C                   READ      Cmpfil                                 90
     C                   Enddo
     C                   Endsr

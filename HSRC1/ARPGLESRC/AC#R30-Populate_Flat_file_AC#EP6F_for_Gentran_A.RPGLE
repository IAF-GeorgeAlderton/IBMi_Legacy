      *-------------------------------------------------------------------------
      *
      *   Program Name:  AC#R30
      *   Description:   Write to ASN Flat file for Gentran.
      *                  Used for TTTX and TBA to generate spearate
      *                   Interchange for Each ASN.
      *
      *   Created By:    RMK
      *   Creation Date: 08/17/2020
      *
      *-------------------------------------------------------------------------
     FAC#EP60   IF   E           K DISK
     FAC#EP61   IF   E           K DISK
     FAC#EP62   IF   E           K DISK
     FAC#EP6F   IF a E             DISK        RENAME(AC#EP6F:AC#EP6FR)

     D                 DS
     D ECCNTL                  1      4        INZ('CNTL')
     D ECPTID                  5     39
     D ECTPQ                  40     43
     D ECTPTY                 44     44
     D ECCTL#                 45     53
     D ECFILL                 54     58
     D ECTEST                 59     59
     D ECTRAN                 60     65
     D ECFUGR                 66     71
     D CntlRec                 1     71

     D                 DS
     D E1FILE                  1      8
     D E1SHID                  9     18
     D E1PRTN                 19     28
     D E1DATE                 29     36  0
     D E1TIME                 37     42  0
     D E1TOKU                 43     46  0
     D E1NONY                 47     50  0
     D E1NKOJ                 51     51
     D E1NUKE                 52     55
     D E1NOHZ                 56     63  0
     D E1NBIN                 64     65  0
     D E1NOTM                 66     69  0
     D E1INVN                 70     85
     D E1ORDN                 86     95
     D E1TRCK                 96    105
     D ETPLT                 106    112  0
     D ETBOX                 113    119  0
     D ETRMD                 120    121
     D ETWHT                 122    131  2
     D ESIRE                 132    136
     D ESIRK                 137    137
     D ESCAC                 138    141
     D ETNET                 142    151  2
     D E1REL#                152    163
     D E1FIL1                164    178
     D ETGRS                 179    188  2
     D ESCNAM                189    208
     D ESCTEL                209    223
     D EFOB                  224    225
     D ESNAM                 226    255
     D ESLOC                 256    275
     D E1REC                   1    275
     D                 DS
     D E2FILE                  1      8
     D E2SHID                  9     18
     D E2PRTN                 19     28
     D E2MAN#                 29     48
     D E2BLN#                 49     68
     D E2INVN                 69     84
     D E2ORDN                 85     94
     D E2SUPL                 95    104
     D E2DEHZ                105    112  0
     D E2#LOD                113    117  0
     D E2#UNT                118    124  0
     D E2PKCD                125    129
     D E2SERL                130    149
     D E2Rec                   1    149
     D                 DS
     D E3FILE                  1      8
     D E3SHID                  9     18
     D E3PRTN                 19     28
     D E3MAN#                 29     48
     D E3SBAN                 49     52
     D E3SYOS                 53     58  0
     D E3SRYO                 59     65  0
     D E3ORQY                 66     72  0
     D E3MHIN                 73     92
     D E3RLS#                 93    102
     D E3RLLN                103    106
     D E3RESE                107    110
     D E3DEHZ                111    118
     D E3RVSN                119    128
     D E3PGID                129    140
     D E3TANK                141    151  4
     D E3ORDN                152    161
TCHK1D E3DATE                162    169  0
TCHK1D E3TIME                170    175  0
TCHK1D E3NOHZ                176    183  0
TCHK1D E3NBIN                184    185  0
TCHK1D E3NOTM                186    189  0
TCHK1D E3INVN                190    205
TCHK1D E3ORD#                206    215
TCHK1D E3TRCK                216    225
TCHK1D E3PLT                 226    232  0
TCHK1D E3BOX                 233    239  0
TCHK1D E3RMD                 240    241
TCHK1D E3WHT                 242    251  2
TCHK1D E3CAC                 252    255
TCHK1D E3NET                 256    265  2
     D E3ECL                 266    275
     D E3DESC                276    305
     D E3SHIN                306    320
     D E3POL#                321    325  0
     D E3CRYO                326    333  0
     D E3PODT                334    341  0
     D E3Rec                   1    341

     IAC#EP621
     I              E1DATE                      E3DATE
     I              E1TIME                      E3TIME
     I              E1NOHZ                      E3NOHZ
     I              E1NBIN                      E3NBIN
     I              E1NOTM                      E3NOTM
     I              E1INVN                      E3INVN
     I              E1ORDN                      E3ORD#
     I              E1TRCK                      E3TRCK
     I              ETPLT                       E3PLT
     I              ETBOX                       E3BOX
     I              ETRMD                       E3RMD
     I              ETWHT                       E3WHT
     I              ESCAC                       E3CAC
     I              ETNET                       E3NET
     IAC#EP6FR
     I              AC#EP6F                     RecFlat
      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------

       Read Ac#ep60;
       Dow Not %eof(Ac#ep60);
         Exsr ControlRec;
         E1file = 'AC#EP60';
         Recflat = E1Rec;
         Write Ac#ep6fr;
         Exsr OrderLevel;
         Read Ac#ep60;
       Enddo;
       *Inlr = *on;

       Begsr ControlRec;
         Select;
           When E1prtn = '3511';
             Ecptid = 'TTTX';
           When E1prtn = '0848';
             Ecptid = 'TBA ';
           When E1prtn = '2694';
             Ecptid = 'TBG ';
         Endsl;
          // 1st Control Record
         Ectpty = 'I';
         Ectran = *Blanks;
         Ecfugr = *Blanks;
         Recflat  = Cntlrec;
         Write Ac#ep6fr;
          // 2nd Control Record
         Ectpty = 'G';
         Ectran = *Blanks;
         Ecfugr = 'SH';
         Recflat  = Cntlrec;
         Write Ac#ep6fr;
          // 3rd Control Record
         Ectpty = 'T';
         Ectran = '856';
         Ecfugr = *Blanks;
         Recflat  = Cntlrec;
         Write Ac#ep6fr;
       Endsr;

       Begsr OrderLevel;
         Setll (E1Prtn: E1Shid) Ac#ep61;
         Reade (E1Prtn: E1Shid) Ac#ep61;
         Dow Not %eof(Ac#ep61);
           E2file = 'AC#EP61';
           Recflat = E2Rec;
           Write Ac#ep6fr;
           Exsr ItemLevel;
           Reade (E1Prtn: E1Shid) Ac#ep61;
         Enddo;
       Endsr;

       Begsr ItemLevel;
         Setll (E2Prtn: E2Shid: E2man#) Ac#ep62;
         Reade (E2Prtn: E2Shid: E2man#) Ac#ep62;
         Dow Not %eof(Ac#ep62);
           E3file = 'AC#EP62';
           Recflat = E3Rec;
           Write Ac#ep6fr;
           Reade (E2Prtn: E2Shid: E2man#) Ac#ep62;
         Enddo;
       Endsr;

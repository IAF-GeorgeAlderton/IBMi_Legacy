      *-------------------------------------------------------------------------
      *
      *   Program Name:  AC#R31
      *   Description:   Write to ASN Flat file for Gentran.
      *                  Used for TMS to generate spearate
      *                   Interchange for Each ASN.
      *
      *   Created By:    RMK
      *   Creation Date: 08/04/2022
      *
      *-------------------------------------------------------------------------
     FAC#EP70   IF   E           K DISK
     FAC#EP75   IF   E           K DISK
     FAC#EP76   IF   E           K DISK
     FAC#EP7F   IF a E             DISK        RENAME(AC#EP7F:AC#EP7FR)

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
TCHK1D E3COC                 162    171
     D E3Rec                   1    341

     IAC#EP7FR
     I              AC#EP7F                     RecFlat
      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------

       Read Ac#EP70;
       Dow Not %eof(Ac#EP70);
         Exsr ControlRec;
         E1file = 'AC#EP70';
         Recflat = E1Rec;
         Write Ac#ep7fr;
         Exsr OrderLevel;
         Read Ac#EP70;
       Enddo;
       *Inlr = *on;

       Begsr ControlRec;
         Select;
           When E1prtn = '0323';
             Ecptid = 'TMS ';
         Endsl;
          // 1st Control Record
         Ectpty = 'I';
         Ectran = *Blanks;
         Ecfugr = *Blanks;
         Recflat  = Cntlrec;
         Write Ac#ep7fr;
          // 2nd Control Record
         Ectpty = 'G';
         Ectran = *Blanks;
         Ecfugr = 'SH';
         Recflat  = Cntlrec;
         Write Ac#ep7fr;
          // 3rd Control Record
         Ectpty = 'T';
         Ectran = '856';
         Ecfugr = *Blanks;
         Recflat  = Cntlrec;
         Write Ac#ep7fr;
       Endsr;

       Begsr OrderLevel;
         Setll (E1Shid) Ac#ep75;
         Reade (E1Shid) Ac#ep75;
         Dow Not %eof(Ac#ep75);
           E2file = 'AC#EP75';
           Recflat = E2Rec;
           Write Ac#ep7fr;
           Exsr ItemLevel;
           Reade (E1Shid) Ac#ep75;
         Enddo;
       Endsr;

       Begsr ItemLevel;
         Setll (E2Shid: E2ordn) Ac#ep76;
         Reade (E2Shid: E2ordn) Ac#ep76;
         Dow Not %eof(Ac#ep76);
           E3file = 'AC#EP76';
           Recflat = E3Rec;
           Write Ac#ep7fr;
           Reade (E2Shid: E2ordn) Ac#ep76;
         Enddo;
       Endsr;

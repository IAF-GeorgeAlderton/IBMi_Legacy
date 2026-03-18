     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO) DFTACTGRP(*NO)
     F***************************************************
     F*  TOYOTA PRODUCTION ANALYSIS BOARD               *
     F*  PALLET RETURNS                                 *
     F*                                                 *
     F*  LEC   2020.04.07                               *
     F***************************************************
     FAM#PW46PZ CF   E             WORKSTN maxdev(*FILE)
     FAM#WP446P IF   E           K DISK
     FAM#WP446A IF   E           K DISK
      *------------------------------------------------------------

     D                SDS
     D  #PGM                   1     10
     D  #WSID                244    253
     D  #USER                254    263

     D  WW                            1    dim(3)
     D  #CHR                          1
     D  Char3                         3
     D  D@QGQTY                       3S 0
     D  D@SGQTY                       3S 0

     D  Lines          DS
     D  #L1                    1      8
     D  #L2                    9     16
     D  #L3                   17     24
     D  #L4                   25     32
     D  #L5                   33     40
     D  #L6                   41     48
     D  #L7                   49     56
     D  #L8                   57     64

     D PQ1             DS
     D  PQ11                   1      8
     D  PQ12                   9     16
     D  PQ13                  17     24
     D  PQ14                  25     32
     D  PQ15                  33     40
     D  PQ16                  41     48
     D  PQ17                  49     56
     D  PQ18                  57     64

     D PQ2             DS
     D  PQ21                   1      8
     D  PQ22                   9     16
     D  PQ23                  17     24
     D  PQ24                  25     32
     D  PQ25                  33     40
     D  PQ26                  41     48
     D  PQ27                  49     56
     D  PQ28                  57     64

     D PQ3             DS
     D  PQ31                   1      8
     D  PQ32                   9     16
     D  PQ33                  17     24
     D  PQ34                  25     32
     D  PQ35                  33     40
     D  PQ36                  41     48
     D  PQ37                  49     56
     D  PQ38                  57     64

     D PT1             DS
     D  PT11                   1      8
     D  PT12                   9     16
     D  PT13                  17     24
     D  PT14                  25     32
     D  PT15                  33     40
     D  PT16                  41     48
     D  PT17                  49     56
     D  PT18                  57     64

     D PT2             DS
     D  PT21                   1      8
     D  PT22                   9     16
     D  PT23                  17     24
     D  PT24                  25     32
     D  PT25                  33     40
     D  PT26                  41     48
     D  PT27                  49     56
     D  PT28                  57     64

     D PT3             DS
     D  PT31                   1      8
     D  PT32                   9     16
     D  PT33                  17     24
     D  PT34                  25     32
     D  PT35                  33     40
     D  PT36                  41     48
     D  PT37                  49     56
     D  PT38                  57     64

     D AQ1             DS
     D  AQ11                   1      8
     D  AQ12                   9     16
     D  AQ13                  17     24
     D  AQ14                  25     32
     D  AQ15                  33     40
     D  AQ16                  41     48
     D  AQ17                  49     56
     D  AQ18                  57     64

     D AQ2             DS
     D  AQ21                   1      8
     D  AQ22                   9     16
     D  AQ23                  17     24
     D  AQ24                  25     32
     D  AQ25                  33     40
     D  AQ26                  41     48
     D  AQ27                  49     56
     D  AQ28                  57     64

     D AQ3             DS
     D  AQ31                   1      8
     D  AQ32                   9     16
     D  AQ33                  17     24
     D  AQ34                  25     32
     D  AQ35                  33     40
     D  AQ36                  41     48
     D  AQ37                  49     56
     D  AQ38                  57     64

     D AT1             DS
     D  AT11                   1      8
     D  AT12                   9     16
     D  AT13                  17     24
     D  AT14                  25     32
     D  AT15                  33     40
     D  AT16                  41     48
     D  AT17                  49     56
     D  AT18                  57     64

     D AT2             DS
     D  AT21                   1      8
     D  AT22                   9     16
     D  AT23                  17     24
     D  AT24                  25     32
     D  AT25                  33     40
     D  AT26                  41     48
     D  AT27                  49     56
     D  AT28                  57     64

     D AT3             DS
     D  AT31                   1      8
     D  AT32                   9     16
     D  AT33                  17     24
     D  AT34                  25     32
     D  AT35                  33     40
     D  AT36                  41     48
     D  AT37                  49     56
     D  AT38                  57     64

     D GQ1             DS
     D  GQ11                   1      8
     D  GQ12                   9     16
     D  GQ13                  17     24
     D  GQ14                  25     32
     D  GQ15                  33     40
     D  GQ16                  41     48
     D  GQ17                  49     56
     D  GQ18                  57     64

     D GQ2             DS
     D  GQ21                   1      8
     D  GQ22                   9     16
     D  GQ23                  17     24
     D  GQ24                  25     32
     D  GQ25                  33     40
     D  GQ26                  41     48
     D  GQ27                  49     56
     D  GQ28                  57     64

     D GQ3             DS
     D  GQ31                   1      8
     D  GQ32                   9     16
     D  GQ33                  17     24
     D  GQ34                  25     32
     D  GQ35                  33     40
     D  GQ36                  41     48
     D  GQ37                  49     56
     D  GQ38                  57     64

     D GT1             DS
     D  GT11                   1      8
     D  GT12                   9     16
     D  GT13                  17     24
     D  GT14                  25     32
     D  GT15                  33     40
     D  GT16                  41     48
     D  GT17                  49     56
     D  GT18                  57     64

     D GT2             DS
     D  GT21                   1      8
     D  GT22                   9     16
     D  GT23                  17     24
     D  GT24                  25     32
     D  GT25                  33     40
     D  GT26                  41     48
     D  GT27                  49     56
     D  GT28                  57     64

     D GT3             DS
     D  GT31                   1      8
     D  GT32                   9     16
     D  GT33                  17     24
     D  GT34                  25     32
     D  GT35                  33     40
     D  GT36                  41     48
     D  GT37                  49     56
     D  GT38                  57     64

     C     *Entry        PList
     C                   Parm                    PCMD              1
      *
      *------------------------------------------------------------
      *  M   A   I   N   L   I   N   E
      *------------------------------------------------------

      *  from plan workfile...

      * quarter plan quantity...
     C                   Move      W1QPQTY       Char3
     C                   Exsr      #EditChar3
     C                   MoveA     Char3         WW

      * character 1.
     C                   Eval      #Chr = WW(1)
     C                   Exsr      GetChrQty
     C                   Eval      PQ1  = Lines
      * character 2.
     C                   Eval      #Chr = WW(2)
     C                   Exsr      GetChrQty
     C                   Eval      PQ2  = Lines
      * character 3.
     C                   Eval      #Chr = WW(3)
     C                   Exsr      GetChrQty
     C                   Eval      PQ3  = Lines


      * shift plan qty...
     C                   Move      W1SPQTY       Char3
     C                   Exsr      #EditChar3
     C                   MoveA     Char3         WW

      * character 1.
     C                   Eval      #Chr = WW(1)
     C                   Exsr      GetChrQty
     C                   Eval      PT1  = Lines
      * character 2.
     C                   Eval      #Chr = WW(2)
     C                   Exsr      GetChrQty
     C                   Eval      PT2  = Lines
      * character 3.
     C                   Eval      #Chr = WW(3)
     C                   Exsr      GetChrQty
     C                   Eval      PT3  = Lines


      * quarter actual quantity...
     C                   Move      W2QAQTY       Char3
     C                   Exsr      #EditChar3
     C                   MoveA     Char3         WW

      * character 1.
     C                   Eval      #Chr = WW(1)
     C                   Exsr      GetChrQty
     C                   Eval      AQ1  = Lines
      * character 2.
     C                   Eval      #Chr = WW(2)
     C                   Exsr      GetChrQty
     C                   Eval      AQ2  = Lines
      * character 3.
     C                   Eval      #Chr = WW(3)
     C                   Exsr      GetChrQty
     C                   Eval      AQ3  = Lines


      * shift actual qty...
     C                   Move      W2TAQTY       Char3
     C                   Exsr      #EditChar3
     C                   MoveA     Char3         WW

      * character 1.
     C                   Eval      #Chr = WW(1)
     C                   Exsr      GetChrQty
     C                   Eval      AT1  = Lines
      * character 2.
     C                   Eval      #Chr = WW(2)
     C                   Exsr      GetChrQty
     C                   Eval      AT2  = Lines
      * character 3.
     C                   Eval      #Chr = WW(3)
     C                   Exsr      GetChrQty
     C                   Eval      AT3  = Lines


      *  calculate gap quantities = actual - plan...
     C                   Eval      D@QGQTY  = W2QAQTY - W1QPQTY
     C                   Eval      D@SGQTY  = W2TAQTY - W1SPQTY

     C                   If        D@QGQTY < *zero
     C                   Eval      *In71 = *On
     C                   Eval      D@QGQTY = D@QGQTY * -1
     C                   EndIf

     C                   If        D@SGQTY < *zero
     C                   Eval      *In72 = *On
     C                   Eval      D@SGQTY = D@SGQTY * -1
     C                   EndIf

      * quarter gap quantity...
     C                   Move      D@QGQTY       Char3
     C                   Exsr      #EditChar3
     C                   MoveA     Char3         WW

      * character 1.
     C                   Eval      #Chr = WW(1)
     C                   Exsr      GetChrQty
     C                   Eval      GQ1  = Lines
      * character 2.
     C                   Eval      #Chr = WW(2)
     C                   Exsr      GetChrQty
     C                   Eval      GQ2  = Lines
      * character 3.
     C                   Eval      #Chr = WW(3)
     C                   Exsr      GetChrQty
     C                   Eval      GQ3  = Lines


      * shift gap qty...
     C                   Move      D@SGQTY       Char3
     C                   Exsr      #EditChar3
     C                   MoveA     Char3         WW

      * character 1.
     C                   Eval      #Chr = WW(1)
     C                   Exsr      GetChrQty
     C                   Eval      GT1  = Lines
      * character 2.
     C                   Eval      #Chr = WW(2)
     C                   Exsr      GetChrQty
     C                   Eval      GT2  = Lines
      * character 3.
     C                   Eval      #Chr = WW(3)
     C                   Exsr      GetChrQty
     C                   Eval      GT3  = Lines

     C                   Write     DSP01
     C                   Read(E)   AM#PW46PZ

     C                   Eval      PCMD = *In01

     C                   Eval      *InLR = *On
     C                   Return
      *------------------------------------------------------
      *  Initialize
      *------------------------------------------------------
     C     *InzSr        BegSr

     C                   Read      AM#WP446P
     C                   Read      AM#WP446A

     C     P#CMD         PLIST
     C                   Parm                    #CHR
     C                   Parm                    #L1
     C                   Parm                    #L2
     C                   Parm                    #L3
     C                   Parm                    #L4
     C                   Parm                    #L5
     C                   Parm                    #L6
     C                   Parm                    #L7
     C                   Parm                    #L8

     C                   EndSr
      *------------------------------------------------------
      *  Get Large Character Quantity
      *------------------------------------------------------
     C     GetChrQty     BegSr

     C                   Eval      Lines = *Blanks
     C
     C                   Call      'AM#R46O'     P#CMD

     C                   EndSr
      *------------------------------------------------------
      *  Get Large Character Quantity
      *------------------------------------------------------
     C     #EditChar3    BegSr

     C                   If        %subst(Char3:1:2) = '00'
     C                   Eval      %subst(Char3:1:2) = '  '
     C                   EndIf

     C                   If        %subst(Char3:1:1) = '0'
     C                   Eval      %subst(Char3:1:1) = ' '
     C                   EndIf

     C                   EndSr
      *------------------------------------------------------

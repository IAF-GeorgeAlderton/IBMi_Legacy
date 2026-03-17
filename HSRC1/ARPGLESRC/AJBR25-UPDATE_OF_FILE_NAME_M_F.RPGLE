     H DATEDIT(*YMD.)
     F*** AJBR25 *************************
     F* UPDATE  OF FILE NAME M/F
     F* H.ITO 87.05.21                   *
JW1  F* JW    2018.10.08 CHG FILE TO 8A  *
     F************************* AJBR25 ***
     FDGAPL01   UF A E           K DISK
     FAJBPW25   CF   E             WORKSTN
     D MSG             S             50    DIM(14) CTDATA PERRCD(1)
     D                 DS
     D  A1SKHZ                 1      8  0
     D  A1SKNE                 1      4  0
     D  A1SKGA                 5      6  0
     D  A1SKNT                 7      8  0
     D**JW1                                   9  15 A1FILE
JW1  D  A1FILE                 9     16
     D  A1F1                   9      9
     D  A1F5                  13     13
     C     *ENTRY        PLIST
     C                   PARM                    US               10
     C                   MOVE      'ERROR'       A1EROR
     C                   Z-ADD     0             A1SKHZ
     C     STP1          TAG
     C                   EXFMT     AJBPW251
     C                   SETOFF                                       030405
     C                   SETOFF                                       060708
     C                   SETOFF                                       111299
     C                   SETOFF                                       010217
     C     *INKA         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
     C     A1KOSN        CABNE     *BLANK        STP39
     C                   GOTO      STP40
     C     STP39         TAG
     C     A1KOSN        CABNE     '0'           STP2
     C                   MOVE      'CAN '        A1NAME
     C                   SETON                                        03
     C                   GOTO      STP3
     C     STP2          TAG
     C     A1KOSN        CABNE     '1'           STP4
     C                   MOVE      'CHG '        A1NAME
     C                   SETON                                        04
     C                   GOTO      STP3
     C     STP4          TAG
     C     A1KOSN        CABEQ     '2'           STP5
     C     STP40         TAG
     C                   Z-ADD     1             I                 2 0
     C                   SETON                                        11
     C                   EXSR      SUBMSG
     C                   GOTO      STP1
     C     STP5          TAG
     C                   MOVE      'ADD '        A1NAME
     C                   SETON                                        05
     C     STP3          TAG
     C     A1FILE        CABNE     *BLANK        STP6
     C                   Z-ADD     2             I
     C                   SETON                                        12
     C                   EXSR      SUBMSG
     C                   GOTO      STP1
     C     STP6          TAG
     C     A1F1          CABEQ     'D'           STP7
     C     A1F1          CABEQ     'M'           STP7
     C     A1F1          CABEQ     'R'           STP7
     C     A1F1          CABEQ     'F'           STP7
     C     A1F1          CABEQ     'U'           STP7
     C     A1F1          CABEQ     'T'           STP7
     C     A1F1          CABEQ     'K'           STP7
     C     A1F1          CABEQ     'E'           STP7
     C     A1F1          CABEQ     'N'           STP7
     C     A1F1          CABEQ     'G'           STP7
     C     A1F1          CABEQ     'S'           STP7
     C     A1F1          CABEQ     'V'           STP7
     C     A1F1          CABEQ     'A'           STP7
     C     A1F1          CABEQ     'J'           STP7
     C     A1F1          CABEQ     'B'           STP7
     C     A1F1          CABEQ     'O'           STP7
     C     A1F1          CABEQ     'I'           STP7
     C     A1F1          CABEQ     'C'           STP7
     C     A1F1          CABEQ     'Z'           STP7
     C                   Z-ADD     3             I
     C                   SETON                                        12
     C                   EXSR      SUBMSG
     C                   GOTO      STP1
     C     STP7          TAG
     C     A1F5          CABNE     'P'           STP8
     C                   SETON                                        06
     C                   GOTO      STP9
     C     STP8          TAG
     C     A1F5          CABNE     'L'           STP10
     C                   SETON                                        07
     C                   GOTO      STP9
     C     STP10         TAG
     C     A1F5          CABEQ     'W'           STP9
     C     A1F5          CABEQ     'G'           STP9
     C     A1F5          CABEQ     'M'           STP9
     C     A1F5          CABEQ     'R'           STP9
     C     A1F5          CABEQ     'D'           STP9
     C     A1F5          CABEQ     'S'           STP9
     C     A1F5          CABEQ     'U'           STP9
     C                   Z-ADD     4             I
     C                   SETON                                        12
     C                   EXSR      SUBMSG
     C                   GOTO      STP1
     C     STP9          TAG
     C     A1FILE        CHAIN     DGAPL01                            08
     C   08              GOTO      STP50
     C     A1SKJO        COMP      'D'                                0101
     C   01              GOTO      STP50
     C   04              SETON                                        17
     C     A1SKHZ        COMP      *DATE                              010202
     C     STP50         TAG
     C   03              SETON                                        17
     C   03
     CAN 08              GOTO      STP11
     C   03
     CANN08
     CAN 02              GOTO      STP12
     C   04
     CAN 08              GOTO      STP13
     C   04
     CANN08
     CAN 02              GOTO      STP14
     C   05
     CANN08
     CAN 01              GOTO      STP15
     C                   GOTO      STP16
     C     STP11         TAG
     C                   Z-ADD     5             I
     C                   SETON                                        12
     C                   EXSR      SUBMSG
     C                   GOTO      STP1
     C     STP12         TAG
     C                   Z-ADD     6             I
     C                   SETON                                        12
     C                   EXSR      SUBMSG
     C                   GOTO      STP1
     C     STP13         TAG
     C                   Z-ADD     7             I
     C                   SETON                                        12
     C                   EXSR      SUBMSG
     C                   GOTO      STP1
     C     STP14         TAG
     C                   Z-ADD     8             I
     C                   SETON                                        12
     C                   EXSR      SUBMSG
     C                   GOTO      STP1
     C     STP15         TAG
     C                   Z-ADD     9             I
     C                   SETON                                        12
     C                   EXSR      SUBMSG
     C                   GOTO      STP1
     C     STP16         TAG
     C   03
     COR 04              GOTO      STP17
     C                   MOVE      *BLANK        A1TXTN
     C                   MOVE      *BLANK        A1PROG
     C                   Z-ADD     0             A1RCRD
     C                   Z-ADD     0             A1SKHZ
     C   06              GOTO      STG1
     C                   GOTO      STG2
     C     STG1          TAG
     C                   Z-ADD     10000         A1SIZ1
     C                   Z-ADD     1000          A1SIZ2
     C                   Z-ADD     3             A1SIZ3
     C                   GOTO      STG3
     C     STG2          TAG
     C                   Z-ADD     0             A1SIZ1
     C                   Z-ADD     0             A1SIZ2
     C                   Z-ADD     0             A1SIZ3
     C     STG3          TAG
     C                   MOVE      *BLANK        A1ACS1
     C                   MOVE      *BLANK        A1ACS2
     C                   MOVE      *BLANK        A1ACS3
     C                   MOVE      *BLANK        A1ACS4
     C                   MOVE      *BLANK        A1ACS5
     C     STP17         TAG
     C                   EXFMT     AJBPW252
     C                   SETOFF                                       091013
     C                   SETOFF                                       141516
     C                   SETOFF                                       1899
     C   KC              EXSR      SUBRTN
     C   KC              GOTO      STP1
     C     A1TXTN        CABNE     *BLANK        STP18
     C                   Z-ADD     10            I
     C                   SETON                                        13
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP18         TAG
     C     A1RCRD        CABNE     0             STP19
     C                   Z-ADD     11            I
     C                   SETON                                        14
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP19         TAG
     C   04
     COR 05              GOTO      STP20
     C     A1SKHZ        CABNE     0             STP21
     C                   MOVE      *DATE         A1SKHZ
     C     STP21         TAG
     C     A1SKNE        CABLT     1901          SEN1
     C     A1SKNE        CABLT     1981          SEN1
     C     A1SKGA        CABLT     01            SEN1
     C     A1SKGA        CABGT     12            SEN1
     C     A1SKNT        CABLT     01            SEN1
     C     A1SKNT        CABGT     31            SEN1
     C                   GOTO      STP20
     C     SEN1          TAG
     C                   SETON                                        18
     C                   Z-ADD     14            I
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP20         TAG
     C  N06              GOTO      STP22
     C     A1SIZ1        CABNE     0             STP23
     C     A1SIZ2        CABNE     0             STP24
     C     A1SIZ3        CABEQ     0             STP22
     C                   Z-ADD     12            I
     C                   SETON                                        15
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP23         TAG
     C     A1SIZ2        CABNE     0             STP25
     C                   Z-ADD     12            I
     C                   SETON                                        15
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP25         TAG
     C     A1SIZ3        CABNE     0             STP22
     C                   Z-ADD     12            I
     C                   SETON                                        15
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP24         TAG
     C                   Z-ADD     12            I
     C                   SETON                                        15
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP22         TAG
     C  N07              GOTO      STP26
     C                   MOVE      *BLANK        A1GOSI
     C     A1ACS1        CABNE     *BLANK        STP27
     C     A1ACS2        CABNE     *BLANK        STP28
     C     A1ACS3        CABNE     *BLANK        STP28
     C     A1ACS4        CABNE     *BLANK        STP28
     C     A1ACS5        CABEQ     *BLANK        STP26
     C                   Z-ADD     13            I
     C                   SETON                                        16
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP27         TAG
     C                   SETON                                        09
     C     A1ACS2        CABEQ     *BLANK        STP29
     C                   SETON                                        10
     C     A1ACS3        CABNE     *BLANK        STP30
     C     A1ACS4        CABEQ     *BLANK        STP31
     C                   Z-ADD     13            I
     C                   SETON                                        16
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP29         TAG
     C     A1ACS3        CABEQ     *BLANK        STP32
     C                   Z-ADD     13            I
     C                   SETON                                        16
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP32         TAG
     C     A1ACS4        CABEQ     *BLANK        STP33
     C                   Z-ADD     13            I
     C                   SETON                                        16
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP33         TAG
     C     A1ACS5        CABEQ     *BLANK        STP26
     C                   Z-ADD     13            I
     C                   SETON                                        16
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP30         TAG
     C     A1ACS4        CABEQ     *BLANK        STP31
     C                   GOTO      STP26
     C     STP31         TAG
     C     A1ACS5        CABEQ     *BLANK        STP26
     C                   Z-ADD     13            I
     C                   SETON                                        16
     C                   GOTO      STP17
     C     STP28         TAG
     C                   Z-ADD     13            I
     C                   SETON                                        16
     C                   EXSR      SUBMSG
     C                   GOTO      STP17
     C     STP26         TAG
     C   09
     CANN10              MOVE      'A'           A1GOSI
     C   09
     CAN 10              MOVE      'B'           A1GOSI
     C   KE              GOTO      STP34
     C                   GOTO      STP17
     C     STP34         TAG
     C                   MOVEL     *DATE         A1KSNE
     C                   MOVE      *DATE         A1DATE            4 0
     C                   MOVEL     A1DATE        A1KSGA
     C                   MOVE      A1DATE        A1KSNT
     C                   TIME                    A1TIME            6 0
     C                   MOVEL     A1TIME        A1KSMM
     C                   MOVE      A1TIME        AATIME            4 0
     C                   MOVEL     AATIME        A1KSSS
     C                   MOVEL     US            A1KSSG
     C   05              MOVE      ' '           A1SKJO
     C   03              MOVE      'D'           A1SKJO
     C   05
     CAN 08              GOTO      STP37
     C                   UPDATE    DGAPL011
     C                   GOTO      STP38
     C     STP37         TAG
     C                   WRITE     DGAPL011
     C     STP38         TAG
     C                   EXSR      SUBRTN
     C                   GOTO      STP1
     C     SUBRTN        BEGSR
     C                   MOVE      *BLANK        A1KOSN
     C                   MOVE      *BLANK        A1FILE
     C                   ENDSR
     C     SUBMSG        BEGSR
     C                   MOVE      MSG(I)        A1MSG
     C                   SETON                                        99
     C                   ENDSR
** MSG
INPUT EITHER OF UPDATE <0.1.2>
BECAUSE A FILE NAME ISN'T INPUT, INPUT IT
LIBRARY INSTRUCTION IS WRONG
WORK DISTINCTION FILE IS WRONG
BEING CANCL,BUT NO APPLICABLE KEY IN FILE NAME M/F
BEING CANCL,BUT FILE NAME M/F IS CANCELLED ALREADY
BEING CHG,BUT NO APPLICABLE KEY IN FILE NAME M/F
BEING CHG,BUT FILE NAME M/F IS CANCELLED ALREADY
BEING ADD IT, BUT FILE NAME M/F IS ADDED ALREADY
BECAUSE TEXT NAME ISN'T INPUT, INPUT IT
BECAUSE THE CHIEF OF RECORD ISN'T INPUT, INPUT IT
BECAUSE ONE OF SIZE ISN'T INPUT, INPUT IT
INPUT METHOD OF ACCESSPATH IS WRONG
BECAUSE DATE <YYMMDD> IS WRONG, INPUT A RIGHT DATE

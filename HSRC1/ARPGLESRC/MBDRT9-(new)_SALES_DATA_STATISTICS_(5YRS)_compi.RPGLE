     H DATEDIT(*YMD/)
     F*** MBDRT8 *******************************************
     F* CREATE DELIVERY STATISTIC DATA (IFS)               *
     *** CAUTION !!! COMPLIE WITH RPGLE (not RPG3) ***
     F* JW(SRA) 2016/07/07 CRT                             *
JW4  F* JW(SRA) 2017/10/03 add SORT Field                  *
JW5  F* JW(SRA) 2018/06/15 add Machine Form Name           *
JW5  F* JW      2020/04/17 CHG APLC11 --> UTLC11           *
JW6  F* JW      2021/05/18 add Part/Machine                *
JW7  F* JW      2021/07/01 add Material Property           *
JW8  F* JW      2022/09/20 add Pickup Condition            *
JW9  F* JW      2023/02/02 add Production Date             *
JWA  F* JWA     2023/08/16 fix Price (#UPRC)               *
     F******************************************************
     FMBDPL11   IF   E           K DISK
     FFCEPL01   IF   E           K DISK
     FAAMPL11   IF   E           K DISK
     FEDIPP42   IF   E           K DISK
     FEDIPP43   IF   E           K DISK
JW5  FMFAPL34   IF   E           K DISK
     FMBDWPT6   O    E             DISK
      *
JW6  FMBDWPT6A  O    E             DISK
JW6  FMBDWPTB   IF   E           K DISK
      *****************************************************************
     D S               S              2  0
     D #H1             S              4  0 DIM(60)
     D #H2             S              2  0 DIM(60)
     D F3S             S              3  0 DIM(15)
     D F3C             S              4  0 DIM(15)
jw8  D JOK             S              2    DIM(7)
jw8  D JNM             S             20    DIM(7)
      *
      *----------------------------------------------------------------
JW9  D                 DS
 .   D  SDATE                  1     14  0
 .   D  NOW                    1      6  0
 .   D  TODAY                  7     14  0
JW9  D                 DS
 .   D  A2TAHZ                 1      8  0
 .   D  A2TAYY                 1      4  0
 .   D  A2TAMM                 5      6  0
JW9  D  A2TADD                 7      8  0
     D                 DS
     D  A2GSH8                 1      8  0
     D  A2GSHZ                 3      8  0
     D  A2GSYY                 1      4  0
     D  A2GSMM                 5      6  0
     D  A2GSDD                 7      8  0
     D                 DS
     D  CKGSH8                 1      8  0
     D  CKSKYY                 1      4  0
     D  CKSKMM                 5      6  0
     D  CKSKDD                 7      8  0
      *MBDPL11(QTY)
     D                 DS
     D #TS                     1     84  0 DIM(12)
     D F4TS01                  1      7  0
     D F4TS02                  8     14  0
     D F4TS03                 15     21  0
     D F4TS04                 22     28  0
     D F4TS05                 29     35  0
     D F4TS06                 36     42  0
     D F4TS07                 43     49  0
     D F4TS08                 50     56  0
     D F4TS09                 57     63  0
     D F4TS10                 64     70  0
     D F4TS11                 71     77  0
     D F4TS12                 78     84  0

      *MBDPL11(PRICE)
     D                 DS
     D #TN                     1    132  5 DIM(12)
     D F4TN01                  1     11  5
     D F4TN02                 12     22  5
     D F4TN03                 23     33  5
     D F4TN04                 34     44  5
     D F4TN05                 45     55  5
     D F4TN06                 56     66  5
     D F4TN07                 67     77  5
     D F4TN08                 78     88  5
     D F4TN09                 89     99  5
     D F4TN10                100    110  5
     D F4TN11                111    121  5
     D F4TN12                122    132  5
      *MBDWPT31 (QTY)
     D                 DS
     D F3Q                     1    420  0 DIM(60)
     D F3QT01                  1      7  0
     D F3QT02                  8     14  0
     D F3QT03                 15     21  0
     D F3QT04                 22     28  0
     D F3QT05                 29     35  0
     D F3QT06                 36     42  0
     D F3QT07                 43     49  0
     D F3QT08                 50     56  0
     D F3QT09                 57     63  0
     D F3QT10                 64     70  0
     D F3QT11                 71     77  0
     D F3QT12                 78     84  0
     D F3QT13                 85     91  0
     D F3QT14                 92     98  0
     D F3QT15                 99    105  0
     D F3QT16                106    112  0
     D F3QT17                113    119  0
     D F3QT18                120    126  0
     D F3QT19                127    133  0
     D F3QT20                134    140  0
     D F3QT21                141    147  0
     D F3QT22                148    154  0
     D F3QT23                155    161  0
     D F3QT24                162    168  0
     D F3QT25                169    175  0
     D F3QT26                176    182  0
     D F3QT27                183    189  0
     D F3QT28                190    196  0
     D F3QT29                197    203  0
     D F3QT30                204    210  0
     D F3QT31                211    217  0
     D F3QT32                218    224  0
     D F3QT33                225    231  0
     D F3QT34                232    238  0
     D F3QT35                239    245  0
     D F3QT36                246    252  0
     D F3QT37                253    259  0
     D F3QT38                260    266  0
     D F3QT39                267    273  0
     D F3QT40                274    280  0
     D F3QT41                281    287  0
     D F3QT42                288    294  0
     D F3QT43                295    301  0
     D F3QT44                302    308  0
     D F3QT45                309    315  0
     D F3QT46                316    322  0
     D F3QT47                323    329  0
     D F3QT48                330    336  0
     D F3QT49                337    343  0
     D F3QT50                344    350  0
     D F3QT51                351    357  0
     D F3QT52                358    364  0
     D F3QT53                365    371  0
     D F3QT54                372    378  0
     D F3QT55                379    385  0
     D F3QT56                386    392  0
     D F3QT57                393    399  0
     D F3QT58                400    406  0
     D F3QT59                407    413  0
     D F3QT60                414    420  0
      *MBDWPT61 (QTY)
     D                 DS
     D F6Q                     1    600    DIM(60)
     D F6QT01                  1     10
     D F6QT02                 11     20
     D F6QT03                 21     30
     D F6QT04                 31     40
     D F6QT05                 41     50
     D F6QT06                 51     60
     D F6QT07                 61     70
     D F6QT08                 71     80
     D F6QT09                 81     90
     D F6QT10                 91    100
     D F6QT11                101    110
     D F6QT12                111    120
     D F6QT13                121    130
     D F6QT14                131    140
     D F6QT15                141    150
     D F6QT16                151    160
     D F6QT17                161    170
     D F6QT18                171    180
     D F6QT19                181    190
     D F6QT20                191    200
     D F6QT21                201    210
     D F6QT22                211    220
     D F6QT23                221    230
     D F6QT24                231    240
     D F6QT25                241    250
     D F6QT26                251    260
     D F6QT27                261    270
     D F6QT28                271    280
     D F6QT29                281    290
     D F6QT30                291    300
     D F6QT31                301    310
     D F6QT32                311    320
     D F6QT33                321    330
     D F6QT34                331    340
     D F6QT35                341    350
     D F6QT36                351    360
     D F6QT37                361    370
     D F6QT38                371    380
     D F6QT39                381    390
     D F6QT40                391    400
     D F6QT41                401    410
     D F6QT42                411    420
     D F6QT43                421    430
     D F6QT44                431    440
     D F6QT45                441    450
     D F6QT46                451    460
     D F6QT47                461    470
     D F6QT48                471    480
     D F6QT49                481    490
     D F6QT50                491    500
     D F6QT51                501    510
     D F6QT52                511    520
     D F6QT53                521    530
     D F6QT54                531    540
     D F6QT55                541    550
     D F6QT56                551    560
     D F6QT57                561    570
     D F6QT58                571    580
     D F6QT59                581    590
     D F6QT60                591    600
      *MBDWPT31 (AMT)
     D                 DS
     D F3A                     1    420  0 DIM(60)
     D F3AM01                  1      7  0
     D F3AM02                  8     14  0
     D F3AM03                 15     21  0
     D F3AM04                 22     28  0
     D F3AM05                 29     35  0
     D F3AM06                 36     42  0
     D F3AM07                 43     49  0
     D F3AM08                 50     56  0
     D F3AM09                 57     63  0
     D F3AM10                 64     70  0
     D F3AM11                 71     77  0
     D F3AM12                 78     84  0
     D F3AM13                 85     91  0
     D F3AM14                 92     98  0
     D F3AM15                 99    105  0
     D F3AM16                106    112  0
     D F3AM17                113    119  0
     D F3AM18                120    126  0
     D F3AM19                127    133  0
     D F3AM20                134    140  0
     D F3AM21                141    147  0
     D F3AM22                148    154  0
     D F3AM23                155    161  0
     D F3AM24                162    168  0
     D F3AM25                169    175  0
     D F3AM26                176    182  0
     D F3AM27                183    189  0
     D F3AM28                190    196  0
     D F3AM29                197    203  0
     D F3AM30                204    210  0
     D F3AM31                211    217  0
     D F3AM32                218    224  0
     D F3AM33                225    231  0
     D F3AM34                232    238  0
     D F3AM35                239    245  0
     D F3AM36                246    252  0
     D F3AM37                253    259  0
     D F3AM38                260    266  0
     D F3AM39                267    273  0
     D F3AM40                274    280  0
     D F3AM41                281    287  0
     D F3AM42                288    294  0
     D F3AM43                295    301  0
     D F3AM44                302    308  0
     D F3AM45                309    315  0
     D F3AM46                316    322  0
     D F3AM47                323    329  0
     D F3AM48                330    336  0
     D F3AM49                337    343  0
     D F3AM50                344    350  0
     D F3AM51                351    357  0
     D F3AM52                358    364  0
     D F3AM53                365    371  0
     D F3AM54                372    378  0
     D F3AM55                379    385  0
     D F3AM56                386    392  0
     D F3AM57                393    399  0
     D F3AM58                400    406  0
     D F3AM59                407    413  0
     D F3AM60                414    420  0
      *MBDWPT61 (AMT)
     D                 DS
     D F6A                     1    600    DIM(60)
     D F6AM01                  1     10
     D F6AM02                 11     20
     D F6AM03                 21     30
     D F6AM04                 31     40
     D F6AM05                 41     50
     D F6AM06                 51     60
     D F6AM07                 61     70
     D F6AM08                 71     80
     D F6AM09                 81     90
     D F6AM10                 91    100
     D F6AM11                101    110
     D F6AM12                111    120
     D F6AM13                121    130
     D F6AM14                131    140
     D F6AM15                141    150
     D F6AM16                151    160
     D F6AM17                161    170
     D F6AM18                171    180
     D F6AM19                181    190
     D F6AM20                191    200
     D F6AM21                201    210
     D F6AM22                211    220
     D F6AM23                221    230
     D F6AM24                231    240
     D F6AM25                241    250
     D F6AM26                251    260
     D F6AM27                261    270
     D F6AM28                271    280
     D F6AM29                281    290
     D F6AM30                291    300
     D F6AM31                301    310
     D F6AM32                311    320
     D F6AM33                321    330
     D F6AM34                331    340
     D F6AM35                341    350
     D F6AM36                351    360
     D F6AM37                361    370
     D F6AM38                371    380
     D F6AM39                381    390
     D F6AM40                391    400
     D F6AM41                401    410
     D F6AM42                411    420
     D F6AM43                421    430
     D F6AM44                431    440
     D F6AM45                441    450
     D F6AM46                451    460
     D F6AM47                461    470
     D F6AM48                471    480
     D F6AM49                481    490
     D F6AM50                491    500
     D F6AM51                501    510
     D F6AM52                511    520
     D F6AM53                521    530
     D F6AM54                531    540
     D F6AM55                541    550
     D F6AM56                551    560
     D F6AM57                561    570
     D F6AM58                571    580
     D F6AM59                581    590
     D F6AM60                591    600
      *MBDWPT31 (PRICE)
     D                 DS
     D F3P                     1    660  5 DIM(60)
     D F3PR01                  1     11  5
     D F3PR02                 12     22  5
     D F3PR03                 23     33  5
     D F3PR04                 34     44  5
     D F3PR05                 45     55  5
     D F3PR06                 56     66  5
     D F3PR07                 67     77  5
     D F3PR08                 78     88  5
     D F3PR09                 89     99  5
     D F3PR10                100    110  5
     D F3PR11                111    121  5
     D F3PR12                122    132  5
     D F3PR13                133    143  5
     D F3PR14                144    154  5
     D F3PR15                155    165  5
     D F3PR16                166    176  5
     D F3PR17                177    187  5
     D F3PR18                188    198  5
     D F3PR19                199    209  5
     D F3PR20                210    220  5
     D F3PR21                221    231  5
     D F3PR22                232    242  5
     D F3PR23                243    253  5
     D F3PR24                254    264  5
     D F3PR25                265    275  5
     D F3PR26                276    286  5
     D F3PR27                287    297  5
     D F3PR28                298    308  5
     D F3PR29                309    319  5
     D F3PR30                320    330  5
     D F3PR31                331    341  5
     D F3PR32                342    352  5
     D F3PR33                353    363  5
     D F3PR34                364    374  5
     D F3PR35                375    385  5
     D F3PR36                386    396  5
     D F3PR37                397    407  5
     D F3PR38                408    418  5
     D F3PR39                419    429  5
     D F3PR40                430    440  5
     D F3PR41                441    451  5
     D F3PR42                452    462  5
     D F3PR43                463    473  5
     D F3PR44                474    484  5
     D F3PR45                485    495  5
     D F3PR46                486    506  5
     D F3PR47                507    517  5
     D F3PR48                518    528  5
     D F3PR49                529    539  5
     D F3PR50                540    550  5
     D F3PR51                551    561  5
     D F3PR52                562    572  5
     D F3PR53                573    583  5
     D F3PR54                584    594  5
     D F3PR55                595    605  5
     D F3PR56                606    616  5
     D F3PR57                617    627  5
     D F3PR58                628    638  5
     D F3PR59                639    649  5
     D F3PR60                650    660  5
      *MBDWPT61 (PRICE)
     D                 DS
     D F6P                     1    660    DIM(60)
     D F6PR01                  1     11
     D F6PR02                 12     22
     D F6PR03                 23     33
     D F6PR04                 34     44
     D F6PR05                 45     55
     D F6PR06                 56     66
     D F6PR07                 67     77
     D F6PR08                 78     88
     D F6PR09                 89     99
     D F6PR10                100    110
     D F6PR11                111    121
     D F6PR12                122    132
     D F6PR13                133    143
     D F6PR14                144    154
     D F6PR15                155    165
     D F6PR16                166    176
     D F6PR17                177    187
     D F6PR18                188    198
     D F6PR19                199    209
     D F6PR20                210    220
     D F6PR21                221    231
     D F6PR22                232    242
     D F6PR23                243    253
     D F6PR24                254    264
     D F6PR25                265    275
     D F6PR26                276    286
     D F6PR27                287    297
     D F6PR28                298    308
     D F6PR29                309    319
     D F6PR30                320    330
     D F6PR31                331    341
     D F6PR32                342    352
     D F6PR33                353    363
     D F6PR34                364    374
     D F6PR35                375    385
     D F6PR36                386    396
     D F6PR37                397    407
     D F6PR38                408    418
     D F6PR39                419    429
     D F6PR40                430    440
     D F6PR41                441    451
     D F6PR42                452    462
     D F6PR43                463    473
     D F6PR44                474    484
     D F6PR45                485    495
     D F6PR46                496    506
     D F6PR47                507    517
     D F6PR48                518    528
     D F6PR49                529    539
     D F6PR50                540    550
     D F6PR51                551    561
     D F6PR52                562    572
     D F6PR53                573    583
     D F6PR54                584    594
     D F6PR55                595    605
     D F6PR56                606    616
     D F6PR57                617    627
     D F6PR58                628    638
     D F6PR59                639    649
     D F6PR60                650    660
      * SHIN
     D                 DS
     D A2MEK                   1      7
     D A2MEK1                  1      4
     D A2MEK2                  5      6
     D A2MEK3                  7      7
      * SHIN
     D                 DS
     D F4SHN                   1     14
     D F4SHN1                  1      5
     D F4S1                    6      6
     D F4SHN2                  7     11
     D F4S2                   12     12
     D F4SHN3                 13     14
      * MHIN
     D                 DS
     D F4MHN                   1     23
     D F4MHN1                  1      5
     D F4M1                    6      6
     D F4MHN2                  7     11
     D F4M2                   12     12
     D F4MHN3                 13     17
     D F4M3                   18     18
     D F4MHN4                 19     23
JW7   * SHIN
 .   D                 DS
 .   D F2SHIN                  1     12
 .   D D1HIN1                  1      5
 .   D D1HIN2                  6     10
JW7  D D1HIN3                 11     12
      *
     D                 DS
     D SCPART                  1     20
     D SVMHN1                  1      5
     D SVMHN2                  6     10
     D SVMHN3                 11     15
     D SVMHN4                 16     20
     D                 DS
     D TGT@DT                  1     60
     D TGT@YY                  1      4  0
     D TGT@MM                  5      6  0
      *****************************************************************
      *                    MAIN ROUTINE
      *****************************************************************
      * INIT
     C                   EXSR      #INIT
      **set Process code for Header
     C**                 EXSR      #PROC0
      * SETLL
     C     @TOKU         IFEQ      9999
     C     *LOVAL        SETLL     MBDPL11
     C                   ELSE
     C     @TOKU         SETLL     MBDPL11
     C                   ENDIF
      * LOOP -----------------------------------
     C     *IN90         DOWEQ     *OFF
      * READ
     C                   READ      MBDPL11                                90
     C   90              LEAVE
      * IGNORE DELETED RECORD
     C     F4SKJY        IFEQ      'D'
     C                   ITER
     C                   ENDIF
     C* END?
     C     @TOKU         IFNE      9999
     C     @TOKU         ANDNE     F4TOKU
     C                   MOVE      *ON           *IN90
     C                   LEAVE
     C                   ENDIF
      * SELECT DELIVERY#
     C     @NONY         IFNE      0
     C     @TOKU         ANDNE     9999
     C     @NONY         ANDNE     F4NONY
     C                   ITER
     C                   ENDIF
     C* SELECT FACTORY
     C     @NKOJ         IFNE      *BLANK
     C     @NKOJ         ANDNE     F4NKOJ
     C                   ITER
     C                   ENDIF
     C* SELECT DOCK
     C     @NUKE         IFNE      *BLANK
     C     @NUKE         ANDNE     F4NUKE
     C                   ITER
     C                   ENDIF
     C* SELECT YEAR
     C     F4TNEN        LOOKUP    #H1                                    75
     C     *IN75         IFEQ      *OFF
     C                   ITER
     C                   ENDIF
     C* ADJUST PART
     C     F4MHN2        IFEQ      *BLANK
     C                   MOVE      *BLANK        F4M1
     C                   ELSE
     C                   MOVE      '-'           F4M1
     C                   ENDIF
     C     F4MHN3        IFEQ      *BLANK
     C                   MOVE      *BLANK        F4M2
     C                   ELSE
     C                   MOVE      '-'           F4M2
     C                   ENDIF
     C     F4MHN4        IFEQ      *BLANK
     C                   MOVE      *BLANK        F4M3
     C                   ELSE
     C                   MOVE      '-'           F4M3
     C                   ENDIF
     C     F4SHN2        IFEQ      *BLANK
     C                   MOVE      *BLANK        F4S1
     C                   ELSE
     C                   MOVE      '-'           F4S1
     C                   ENDIF
     C     F4SHN3        IFEQ      *BLANK
     C                   MOVE      *BLANK        F4S2
     C                   ELSE
     C                   MOVE      '-'           F4S2
     C                   ENDIF
      * FIRST?
     C     FIRST         IFEQ      'Y'
     C                   MOVE      'N'           FIRST
     C                   Z-ADD     F4TOKU        SVTOKU            4 0
     C                   Z-ADD     F4NONY        SVNONY            4 0
     C                   MOVEL     F4NKOJ        SVNKOJ            1
     C                   MOVEL     F4NUKE        SVNUKE            4
     C                   MOVEL     F4MHN         SVMHN            23
     C                   MOVEL     F4MHN1        SVMHN1
     C                   MOVEL     F4MHN2        SVMHN2
     C                   MOVEL     F4MHN3        SVMHN3
     C                   MOVEL     F4MHN4        SVMHN4
     C                   MOVEL     F4SHN         SVSHN            14
     C                   MOVEL     F4SHN1        SVSHN1            5
     C                   MOVEL     F4SHN2        SVSHN2            5
     C                   MOVEL     F4SHN3        SVSHN3            2
     C                   ENDIF
      * BREAK?
     C     F4TOKU        IFNE      SVTOKU
     C     F4NONY        ORNE      SVNONY
     C     F4NKOJ        ORNE      SVNKOJ
     C     F4NUKE        ORNE      SVNUKE
     C     F4MHN         ORNE      SVMHN
     C     F4SHN         ORNE      SVSHN
     C                   EXSR      #BRK1
     C                   ENDIF
      * PROCESS
     C                   EXSR      #PROC
      *
     C                   ENDDO
      * LAST BREAK
     C     FIRST         IFEQ      'N'
     C                   EXSR      #BRK1
     C                   ENDIF
      * SET RETURN FLAG
     C     RCNT          IFEQ      0
     C                   MOVE      '*'           P@STS
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                  BREAK PROCESS
      *****************************************************************
     C     #BRK1         BEGSR
      * ADJUST PRICE
     C     P@TYPE        IFEQ      '2'
     C                   EXSR      #UPRC
     C                   ENDIF
      * OUTPUT AB#WPT3
     C                   XFOOT     F3Q           F3QT99            8 0
     C                   XFOOT     F3A           F3AM99            8 0
     C                   MOVEL     F3QT99        F6QT99
     C                   MOVEL     F3AM99        F6AM99
      * GET FCEPP INFO.
     C                   EXSR      #FCEP
     C                   EXSR      #DTL2
     C                   WRITE     MBDWPT61
     C                   ADD       1             RCNT              6 0
JW6   * DETAIL
 .   C     F6SHIN        CHAIN     MBDWPTB                            99
 .   C     *IN99         IFEQ      *ON
 .   C                   EXSR      #CLRM
 .   C                   MOVEL     F6SHIN        FBPART
 .   C                   MOVE      '*'           FBPART
 .   C                   ENDIF
JW9  C                   EVAL      FBPRHZ = %EDITC(A2TAHZ:'Y')
JW6  C                   WRITE     MBDWT6A1
      * SAVE KEY
     C                   Z-ADD     F4TOKU        SVTOKU
     C                   Z-ADD     F4NONY        SVNONY
     C                   MOVEL     F4NKOJ        SVNKOJ
     C                   MOVEL     F4NUKE        SVNUKE
     C                   MOVEL     F4MHN         SVMHN
     C                   MOVEL     F4MHN1        SVMHN1
     C                   MOVEL     F4MHN2        SVMHN2
     C                   MOVEL     F4MHN3        SVMHN3
     C                   MOVEL     F4MHN4        SVMHN4
     C                   MOVEL     F4SHN         SVSHN
     C                   MOVEL     F4SHN1        SVSHN1
     C                   MOVEL     F4SHN2        SVSHN2
     C                   MOVEL     F4SHN3        SVSHN3
      * RESET FIELDS (MBDWPT3)
     C                   CLEAR                   MBDWPT61
jw1  C                   z-add     0             F3Q
jw1  C                   z-add     0             F3A
jw1  C                   z-add     0             F3P
      *
     C                   ENDSR
      *----------------------------------------------------*
      *          GET PRODUCTION INFORMATION
      *----------------------------------------------------*
     C     #FCEP         BEGSR
     C                   SETOFF                                       53
     C                   MOVE      SVSHN1        K@SHN1
     C                   MOVE      SVSHN2        K@SHN2
     C                   MOVE      SVSHN3        K@SHN3
     C     FCEKEY        CHAIN     FCEPL011                           53
     C     *IN53         IFEQ      *OFF
     C     A2GSKD        IFEQ      'D'
     C**   A2GSH8        ANDLE     *DATE
JW9  C     A2GSH8        ANDLE     TODAY
     C                   SETON                                        53
     C                   ENDIF
     C                   ENDIF
     C     FCEKEY        CHAIN     AAMPL111                           53
     C**   *IN53         IFEQ      '0'
     C**   CKSKJY        IFEQ      'D'
     C**   CKGSH8        ANDLE     *DATE
     C**                 SETON                                        53
     C**                 ENDIF
     C**                 ENDIF
      *
     C     *IN53         IFEQ      *OFF
     C**                 MOVEL     A2TUSZ        F6MSIZ
add  C                   EVAL      F6MSIZ = %CHAR(A2TUSZ)
add  C                   EVAL      F6DIAM = %CHAR(A2KAZI)
     C                   MOVEL     A2KUBI        F6SHNK
     C                   MOVEL     A2SSYS        F6QPC
     C                   MOVEL     A2MEK         F6MEKI
     C                   MOVEL     A2ZANM        F6MATE
      * Process
     C                   MOVEL     CKKO01        F6PC01
     C                   MOVEL     CKKO02        F6PC02
     C                   MOVEL     CKKO03        F6PC03
     C                   MOVEL     CKKO04        F6PC04
     C                   MOVEL     CKKO05        F6PC05
     C                   MOVEL     CKKO06        F6PC06
     C                   MOVEL     CKKO07        F6PC07
     C                   MOVEL     CKKO08        F6PC08
     C                   MOVEL     CKKO09        F6PC09
     C                   MOVEL     CKKO10        F6PC10
     C                   MOVEL     CKKO11        F6PC11
     C                   MOVEL     CKKO12        F6PC12
     C                   MOVEL     CKKO13        F6PC13
     C                   MOVEL     CKKO14        F6PC14
     C                   MOVEL     CKKO15        F6PC15
      * Dept
     c     CKBM01        IFNE      0
     C                   MOVEL     CKBM01        F6CD01
     C                   ENDIF
     c     CKBM02        IFNE      0
     C                   MOVEL     CKBM02        F6CD02
     C                   ENDIF
     c     CKBM03        IFNE      0
     C                   MOVEL     CKBM03        F6CD03
     C                   ENDIF
     c     CKBM04        IFNE      0
     C                   MOVEL     CKBM04        F6CD04
     C                   ENDIF
     c     CKBM05        IFNE      0
     C                   MOVEL     CKBM05        F6CD05
     C                   ENDIF
     c     CKBM06        IFNE      0
     C                   MOVEL     CKBM06        F6CD06
     C                   ENDIF
     c     CKBM07        IFNE      0
     C                   MOVEL     CKBM07        F6CD07
     C                   ENDIF
     c     CKBM08        IFNE      0
     C                   MOVEL     CKBM08        F6CD08
     C                   ENDIF
     c     CKBM09        IFNE      0
     C                   MOVEL     CKBM09        F6CD09
     C                   ENDIF
     c     CKBM10        IFNE      0
     C                   MOVEL     CKBM10        F6CD10
     C                   ENDIF
     c     CKBM11        IFNE      0
     C                   MOVEL     CKBM11        F6CD11
     C                   ENDIF
     c     CKBM12        IFNE      0
     C                   MOVEL     CKBM12        F6CD12
     C                   ENDIF
     c     CKBM13        IFNE      0
     C                   MOVEL     CKBM13        F6CD13
     C                   ENDIF
     c     CKBM14        IFNE      0
     C                   MOVEL     CKBM14        F6CD14
     C                   ENDIF
     c     CKBM15        IFNE      0
     C                   MOVEL     CKBM15        F6CD15
     C                   ENDIF
      * Machine
     C                   MOVEL     CKKB01        F6MC01
     C                   MOVEL     CKKB02        F6MC02
     C                   MOVEL     CKKB03        F6MC03
     C                   MOVEL     CKKB04        F6MC04
     C                   MOVEL     CKKB05        F6MC05
     C                   MOVEL     CKKB06        F6MC06
     C                   MOVEL     CKKB07        F6MC07
     C                   MOVEL     CKKB08        F6MC08
     C                   MOVEL     CKKB09        F6MC09
     C                   MOVEL     CKKB10        F6MC10
     C                   MOVEL     CKKB11        F6MC11
     C                   MOVEL     CKKB12        F6MC12
     C                   MOVEL     CKKB13        F6MC13
     C                   MOVEL     CKKB14        F6MC14
     C                   MOVEL     CKKB15        F6MC15
JW5   * Machine Format Name
 |   C                   MOVEL     *BLANK        F6MF01
 |   C                   MOVEL     *BLANK        F6MF02
 |   C                   MOVEL     *BLANK        F6MF03
 |   C                   MOVEL     *BLANK        F6MF04
 |   C                   MOVEL     *BLANK        F6MF05
 |   C                   MOVEL     *BLANK        F6MF06
 |   C                   MOVEL     *BLANK        F6MF07
 |   C                   MOVEL     *BLANK        F6MF08
 |   C                   MOVEL     *BLANK        F6MF09
 |   C                   MOVEL     *BLANK        F6MF10
 |   C                   MOVEL     *BLANK        F6MF11
 |   C                   MOVEL     *BLANK        F6MF12
 |   C                   MOVEL     *BLANK        F6MF13
 |   C                   MOVEL     *BLANK        F6MF14
 |   C                   MOVEL     *BLANK        F6MF15
 |    *
 |   C     CKKB01        IFNE      *BLANK
 |   C     CKKB01        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF01
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB02        IFNE      *BLANK
 |   C     CKKB02        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF02
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB03        IFNE      *BLANK
 |   C     CKKB03        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF03
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB04        IFNE      *BLANK
 |   C     CKKB04        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF04
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB05        IFNE      *BLANK
 |   C     CKKB05        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF05
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB06        IFNE      *BLANK
 |   C     CKKB06        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF06
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB07        IFNE      *BLANK
 |   C     CKKB07        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF07
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB08        IFNE      *BLANK
 |   C     CKKB08        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF08
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB09        IFNE      *BLANK
 |   C     CKKB09        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF09
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB10        IFNE      *BLANK
 |   C     CKKB10        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF10
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB11        IFNE      *BLANK
 |   C     CKKB11        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF11
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB12        IFNE      *BLANK
 |   C     CKKB12        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF12
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB13        IFNE      *BLANK
 |   C     CKKB13        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF13
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB14        IFNE      *BLANK
 |   C     CKKB14        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF14
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB15        IFNE      *BLANK
 |   C     CKKB15        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F6MF15
 |   C                   ENDIF
JW5  C                   ENDIF
      *
JW2   *MATERIAL WGT
 |   C**                 MOVEL     A2SOZI        F6MWGT
 |   C                   EVAL      F6MWGT = %CHAR(A2SOZI)
 |    *FINISH   WGT
JW2  C**                 MOVEL     A2KASI        F6FWGT
JW2  C                   EVAL      F6FWGT = %CHAR(A2KASI)
      *MONTHLY SET
JW3  C**                 MOVEL     A2GEKN        F6MSET
JW3  C                   EVAL      F6MSET = %CHAR(A2GEKN)
      *SORT
JW4  C                   MOVEL     SVSHN1        D1HIN1
 |   C                   MOVEL     SVSHN2        D1HIN2
 |   C                   MOVEL     SVSHN3        D1HIN3
 |   C                   CALL      'AAFRS7'
 |   C                   PARM                    D1HIN1            5
 |   C                   PARM                    D1HIN2            5
 |   C                   PARM                    D1HIN3            2
 |   C                   PARM                    T@BAN1            1
 |   C                   PARM                    T@BAN2            2
 |   C                   PARM                    T@BAN3            2
 |   C                   PARM                    T@BAN4            1
 |   C                   PARM                    T@SRTN           20
 |   C                   PARM                    T@SRT#           20
 |   C*
 |   C                   MOVEL     T@SRTN        U@CHR1          128
 |   C                   MOVEL     T@SRT#        U@CHR2          128
 |   C                   MOVEL     *BLANK        U@CHR3          128
 |   C*
 |    **jw1              CALL      'APLC11'
 |   C                   CALL      'UTLC11'
 |   C                   PARM                    U@CHR1
 |   C                   PARM                    U@CHR2
 |   C                   PARM                    U@CHR3
JW4  C                   MOVEL     U@CHR3        F6SORT
      *
JW4   *LAST LOCATION
 |   C                   CALL      'UTLR13'
 |   C                   PARM                    D1HIN1
 |   C                   PARM                    D1HIN2
 |   C                   PARM                    D1HIN3
 |   C                   PARM                    $LOC1             1
 |   C                   PARM                    $LOC2             2
 |   C                   PARM                    $LOC3             2
 |   C                   PARM                    $LOC4             1
 |   C                   PARM                    $SYOS             5
 |   C                   PARM                    $RTN              1
 |   C                   EVAL      F6LLOC = $LOC1 + '-' + $LOC2 + '-'
JW4  C                                    + $LOC3 + '-' +$LOC4
      *
jw5  C                   MOVEL     A2UKER        F6UKER
JW8   * get Pickup Condition
 .   C                   MOVEL     F2SHIN        PSHIN
 .   c                   CALL      'UEXR06B'
 .   c                   PARM                    PSHIN            12
 .   c                   PARM                    PJOK             14
 .   c                   PARM                    PJNM            140
 .   C                   MOVEA     PJOK          JOK
 .   C                   MOVEA     PJNM          JNM
 .    * 1
 .   C     JOK(1)        IFEQ      '  '
 .   C                   EVAL      F6PKC1 = ' '
 .   C                   ELSE
 .   C                   EVAL      F6PKC1 = jok(1) + ': ' + jnm(1)
 .   C                   ENDIF
 .    * 2
 .   C     JOK(2)        IFEQ      '  '
 .   C                   EVAL      F6PKC2 = ' '
 .   C                   ELSE
 .   C                   EVAL      F6PKC2 = jok(2) + ': ' + jnm(2)
 .   C                   ENDIF
 .    * 3
 .   C     JOK(3)        IFEQ      '  '
 .   C                   EVAL      F6PKC3 = ' '
 .   C                   ELSE
 .   C                   EVAL      F6PKC3 = jok(3) + ': ' + jnm(3)
JW8  C                   ENDIF
     c
 .   C                   MOVEL     F2SHIN        $SHIN
JW7   * get Material Property
 .   C                   MOVEL     F2SHIN        $SHIN
 .   C                   CALL      'UEXR34B'
 .   C                   PARM                    $SHIN            12
 .   C                   PARM                    $ZAIS            15
 .   C                   PARM                    $ZAIK             5 2
 .   C                   PARM                    $KIKI             3 1
 .   C                   PARM                    $RTN              1
JW7  C                   EVAL      F6KIKI = %CHAR($KIKI)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *          PROCESS (SUMMARIZE BY PART, YEAR)
      *****************************************************************
     C     #PROC         BEGSR
      * GET CUSTOMER GROUP
     C                   MOVE      *BLANK        F6GRP
     C                   MOVEL     F4TOKU        LTR4              4
     C     LTR4          CHAIN     EDIPP42                            99
     C     *IN99         IFEQ      *OFF
     C**   E4SKJY        ANDNE     'D'
     C     E4GRP         CHAIN     EDIPP43                            98
     C     *IN98         IFEQ      *OFF
     C**   E3SKJY        ANDNE     'D'
     C                   MOVEL     E3GPNM        F6GRP
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     F4TOKU        F6TOKU
     C                   MOVEL     F4NONY        F6NONY
     C                   MOVE      *BLANK        F6TONM
      * GET CUST NAME
     C                   MOVEL     F4NONY        PMNONY
     C                   MOVE      'D'           PMOPT
     C                   CALL      'UTLR16'
     C                   PARM                    PMNONY            4
     C                   PARM                    PMOPT             1
     C                   PARM                    PMNAME           20
     C                   PARM                    PTOKU             4
     C                   PARM                    PMRTN             1
     C                   MOVEL     PMNAME        F6TONM
      *
     C                   MOVEL     F4NKOJ        F6NKOJ
     C                   MOVEL     F4NUKE        F6NUKE
     C                   MOVEL     F4MHN         F6MHIN
     C                   MOVEL     F4SHN         F6SHIN
      *
     C                   Z-ADD     *ZERO         @M
     C                   DO        @SIZI
     C                   ADD       1             @M
      *
     C     #H1(@M)       IFNE      F4TNEN
     C                   ITER
     C                   ENDIF
      *
     C                   Z-ADD     #H2(@M)       @N                2 0
     C                   Z-ADD     #TS(@N)       F3Q(@M)
     C                   Z-ADD     #TN(@N)       F3P(@M)
      *
     C                   Z-ADD     0             W@KING           15 0
     C     F3Q(@M)       MULT(H)   F3P(@M)       W@KING
     C                   Z-ADD     W@KING        F3A(@M)
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *          ADJUST UNIT PRICE (IF P@TYPE='2')
      *****************************************************************
     C     #UPRC         BEGSR
      *
JWA  c                   Z-ADD     0             F3P
     C                   Z-ADD     *ZERO         @M
     C                   DO        @SIZI
     C                   ADD       1             @M
      *
     C     #H1(@M)       IFEQ      0
     C                   GOTO      $UPRCX
     C                   ENDIF
      *
     C                   Z-ADD     #H1(@M)       TGT@YY
     C                   Z-ADD     #H2(@M)       TGT@MM
      *
     C                   MOVEL     TGT@DT        $DATE
     C                   MOVEL     SVTOKU        $TOKU
     C                   MOVEL     SVNONY        $NONY
     C                   MOVEL     SCPART        $CPART
     C                   CALL      'UTLR03'
     C                   PARM                    $DATE             6
     C                   PARM                    $TOKU             4
     C                   PARM                    $NONY             4
     C                   PARM                    $CPART           20
     C                   PARM                    $UP               9
     C                   PARM                    $RTN              1
      * CHANGE U/P AND AMOUNT
     C     $RTN          IFEQ      *BLANK
     C                   MOVEL     $UP           @UP               9 5
     C                   Z-ADD     @UP           F3P(@M)
     C     F3Q(@M)       MULT(H)   F3P(@M)       F3A(@M)
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     $UPRCX        TAG
     C                   ENDSR
      *----------------------------------------------------*
      *  SET PROCESS CODE FOR THE NEW HEADER
      *----------------------------------------------------*
     C**JW6#PROC0        BEGSR
      *
 |   C**                 CALL      'MBDRTA'
 |   C**                 PARM                    P@TOKU
 |   C**                 PARM                    P@NONY
 |   C**                 PARM                    P@NKOJ
 |   C**                 PARM                    P@NUKE
 |   C**                 PARM                    P@YYYY
 |   C**                 PARM                    P@MMMM
 |   C**                 PARM                    P@SIZI
 |   C**                 PARM                    P@TYPE
 |   C**                 PARM                    P@STS
      *
     C**                 ENDSR
      *----------------------------------------------------*
      *  INITIALIZATION
      *----------------------------------------------------*
     C     #INIT         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@TOKU            4
     C                   PARM                    P@NONY            4
     C                   PARM                    P@NKOJ            1
     C                   PARM                    P@NUKE            4
     C                   PARM                    P@YYYY            4
     C                   PARM                    P@MM              2
     C                   PARM                    P@SIZI            1
     C                   PARM                    P@TYPE            1
     C                   PARM                    P@STS             1
      *
     C     FCEKEY        KLIST
     C                   KFLD                    K@SHN1            5
     C                   KFLD                    K@SHN2            5
     C                   KFLD                    K@SHN3            2
      *
JW9  C                   TIME                    SDATE
     C                   MOVE      *BLANK        P@STS
     C                   MOVEL     P@TOKU        @TOKU             4 0
     C                   MOVEL     P@NONY        @NONY             4 0
     C                   MOVEL     P@NKOJ        @NKOJ             1
     C                   MOVEL     P@NUKE        @NUKE             4
     C                   MOVEL     P@YYYY        @YYYY             4 0
     C                   MOVEL     P@MM          @MM               2 0
     C                   CLEAR                   MBDWPT61
     C                   MOVEL     'Y'           FIRST             1
     C                   MOVEL     P@TYPE        @T                1 0
     C                   Z-ADD     0             @M                2 0
     C**                 Z-ADD     *DATE         @DATE             8 0
JW9  C                   Z-ADD     TODAY         @DATE             8 0
     C                   Z-ADD     0             F3Q
     C                   Z-ADD     0             F3A
     C                   Z-ADD     0             F3P
     C                   Z-ADD     0             F3C
      *
      ** SET MONTHLY INDICATOR
     C                   SELECT
     C     P@SIZI        WHENEQ    '1'
     C                   Z-ADD     6             @SIZI             2 0
     C     P@SIZI        WHENEQ    '2'
     C                   Z-ADD     12            @SIZI
     C     P@SIZI        WHENEQ    '3'
     C                   Z-ADD     24            @SIZI
     C     P@SIZI        WHENEQ    '4'
     C                   Z-ADD     60            @SIZI
     C                   ENDSL
     C                   Z-ADD     *ZERO         #H1
     C                   Z-ADD     *ZERO         #H2
     C                   EXSR      #MON
      * OUTPUT HEADER
     C                   EXSR      #HDR
     C                   CLEAR                   MBDWPT61
      *
     C                   ENDSR
      *----------------------------------------------------*
      * SET MONTHLY INDICATOR
      *----------------------------------------------------*
     C     #MON          BEGSR
      *
     C                   Z-ADD     *ZERO         @A                2 0
     C                   Z-ADD     @YYYY         W@YY              4 0
     C                   Z-ADD     @MM           W@MM              2 0
      *
     C                   DO        @SIZI
     C                   ADD       1             @A
      **
     C     @A            IFGT      @SIZI
     C                   GOTO      E#MON
     C                   ENDIF
      *
     C                   Z-ADD     W@YY          #H1(@A)
     C                   Z-ADD     W@MM          #H2(@A)
      *
     C     W@MM          IFLT      12
     C                   ADD       1             W@MM
     C                   ELSE
     C                   ADD       1             W@YY
     C                   Z-ADD     1             W@MM
     C                   ENDIF
      **
     C                   ENDDO
      *
     C     E#MON         ENDSR
      *----------------------------------------------------*
      * OUTPUT HEADER
      *----------------------------------------------------*
     C     #HDR          BEGSR
      *
     C                   CLEAR                   MBDWPT61
      *
     C                   MOVEL     'GROUP'       F6GRP
     C                   MOVEL     'CUST#'       F6TOKU
     C                   MOVEL     'DELIV#'      F6NONY
     C                   MOVEL     'CS_NAME'     F6TONM
     C                   MOVEL     'FACTORY'     F6NKOJ
     C                   MOVEL     'DOCK'        F6NUKE
     C                   MOVEL     'USR_PART'    F6MHIN
     C                   MOVEL     'IAF_PART'    F6SHIN
     C                   MOVEL     'MONTH_SET'   F6MSET
      *
     C                   EXSR      #HDR2
      *
     C                   MOVEL     'QTY_TTL'     F6QT99
     C                   MOVEL     'AMT_TTL'     F6AM99
      *
     C                   MOVEL     'QTY/CNT'     F6QPC
     C                   MOVEL     'MAT_NAME'    F6MATE
     C                   MOVEL     'MEKKI'       F6MEKI
     C                   MOVEL     'M_SIZE'      F6MSIZ
add  C                   MOVEL     'M_DIAMETER'  F6DIAM
     C                   MOVEL     'SHANK'       F6SHNK
      *
     C                   MOVEL     'PROC_01'     F6PC01
     C                   MOVEL     'PROC_02'     F6PC02
     C                   MOVEL     'PROC_03'     F6PC03
     C                   MOVEL     'PROC_04'     F6PC04
     C                   MOVEL     'PROC_05'     F6PC05
     C                   MOVEL     'PROC_06'     F6PC06
     C                   MOVEL     'PROC_07'     F6PC07
     C                   MOVEL     'PROC_08'     F6PC08
     C                   MOVEL     'PROC_09'     F6PC09
     C                   MOVEL     'PROC_10'     F6PC10
     C                   MOVEL     'PROC_11'     F6PC11
     C                   MOVEL     'PROC_12'     F6PC12
     C                   MOVEL     'PROC_13'     F6PC13
     C                   MOVEL     'PROC_14'     F6PC14
     C                   MOVEL     'PROC_15'     F6PC15
      *
     C                   MOVEL     'CODE_01'     F6CD01
     C                   MOVEL     'CODE_02'     F6CD02
     C                   MOVEL     'CODE_03'     F6CD03
     C                   MOVEL     'CODE_04'     F6CD04
     C                   MOVEL     'CODE_05'     F6CD05
     C                   MOVEL     'CODE_06'     F6CD06
     C                   MOVEL     'CODE_07'     F6CD07
     C                   MOVEL     'CODE_08'     F6CD08
     C                   MOVEL     'CODE_09'     F6CD09
     C                   MOVEL     'CODE_10'     F6CD10
     C                   MOVEL     'CODE_11'     F6CD11
     C                   MOVEL     'CODE_12'     F6CD12
     C                   MOVEL     'CODE_13'     F6CD13
     C                   MOVEL     'CODE_14'     F6CD14
     C                   MOVEL     'CODE_15'     F6CD15
      *
     C                   MOVEL     'MCN_01'      F6MC01
     C                   MOVEL     'MCN_02'      F6MC02
     C                   MOVEL     'MCN_03'      F6MC03
     C                   MOVEL     'MCN_04'      F6MC04
     C                   MOVEL     'MCN_05'      F6MC05
     C                   MOVEL     'MCN_06'      F6MC06
     C                   MOVEL     'MCN_07'      F6MC07
     C                   MOVEL     'MCN_08'      F6MC08
     C                   MOVEL     'MCN_09'      F6MC09
     C                   MOVEL     'MCN_10'      F6MC10
     C                   MOVEL     'MCN_11'      F6MC11
     C                   MOVEL     'MCN_12'      F6MC12
     C                   MOVEL     'MCN_13'      F6MC13
     C                   MOVEL     'MCN_14'      F6MC14
     C                   MOVEL     'MCN_15'      F6MC15
JW5   *
 |   C                   MOVEL     'MFN_01'      F6MF01
 |   C                   MOVEL     'MFN_02'      F6MF02
 |   C                   MOVEL     'MFN_03'      F6MF03
 |   C                   MOVEL     'MFN_04'      F6MF04
 |   C                   MOVEL     'MFN_05'      F6MF05
 |   C                   MOVEL     'MFN_06'      F6MF06
 |   C                   MOVEL     'MFN_07'      F6MF07
 |   C                   MOVEL     'MFN_08'      F6MF08
 |   C                   MOVEL     'MFN_09'      F6MF09
 |   C                   MOVEL     'MFN_10'      F6MF10
 |   C                   MOVEL     'MFN_11'      F6MF11
 |   C                   MOVEL     'MFN_12'      F6MF12
 |   C                   MOVEL     'MFN_13'      F6MF13
 |   C                   MOVEL     'MFN_14'      F6MF14
JW5  C                   MOVEL     'MFN_15'      F6MF15
      *
     C                   MOVEL     'MAT_WGT'     F6MWGT
     C                   MOVEL     'FIN_WGT'     F6FWGT
JW4  C                   MOVEL     'SORT   '     F6SORT
JW4  C                   MOVEL     'LAST_LOC'    F6LLOC
JW5  C                   MOVEL     'RCV_POINT'   F6UKER
JW8  C                   MOVEL     'PICKUP_1-1'  F6PKC1
JW8  C                   MOVEL     'PICKUP_1-2'  F6PKC2
JW8  C                   MOVEL     'PICKUP_1-3'  F6PKC3
JW7  C                   eval      F6KIKI= 'M_PROPERTY'
JW5  C                   eval      F6PGM = '(PGM: MBDRT9)'
      *
     C                   Z-ADD     0             @A                2 0
     C                   DO        @SIZI
     C                   ADD       1             @A
     C     #H1(@A)       MULT      100           NUM6              6 0
     C                   ADD       #H2(@A)       NUM6
     C**temp             Z-ADD     NUM6          F3Q(@A)
     C**temp             Z-ADD     NUM6          F3A(@A)
     C**temp             Z-ADD     NUM6          F3P(@A)
     C                   ENDDO
      *
     C                   WRITE     MBDWPT61
JW6   * HEADER
 .   C     *BLANK        CHAIN     MBDWPTB                            99
 .   C     *IN99         IFEQ      *ON
 .   C                   EXSR      #CLRM
 .   C                   ENDIF
 .   C                   MOVEL     'IAF PART'    FBPART
JW9  C                   MOVEL     'PROD_DATE'   FBPRHZ
JW6  C                   WRITE     MBDWT6A1
      *
     C                   ENDSR
      *----------------------------------------------------*
      * CLEAR MACHIN TABLE
      *----------------------------------------------------*
     C     #CLRM         BEGSR
      *
     C                   MOVE      *BLANK        FBMC01
     C                   MOVE      *BLANK        FBMC02
     C                   MOVE      *BLANK        FBMC03
     C                   MOVE      *BLANK        FBMC04
     C                   MOVE      *BLANK        FBMC05
     C                   MOVE      *BLANK        FBMC06
     C                   MOVE      *BLANK        FBMC07
     C                   MOVE      *BLANK        FBMC08
     C                   MOVE      *BLANK        FBMC09
     C                   MOVE      *BLANK        FBMC10
     C                   MOVE      *BLANK        FBMC11
     C                   MOVE      *BLANK        FBMC12
     C                   MOVE      *BLANK        FBMC13
     C                   MOVE      *BLANK        FBMC14
     C                   MOVE      *BLANK        FBMC15
     C                   MOVE      *BLANK        FBMC16
     C                   MOVE      *BLANK        FBMC17
     C                   MOVE      *BLANK        FBMC18
     C                   MOVE      *BLANK        FBMC19
     C                   MOVE      *BLANK        FBMC20
     C                   MOVE      *BLANK        FBMC21
     C                   MOVE      *BLANK        FBMC22
     C                   MOVE      *BLANK        FBMC23
     C                   MOVE      *BLANK        FBMC24
     C                   MOVE      *BLANK        FBMC25
     C                   MOVE      *BLANK        FBMC26
     C                   MOVE      *BLANK        FBMC27
     C                   MOVE      *BLANK        FBMC28
     C                   MOVE      *BLANK        FBMC29
     C                   MOVE      *BLANK        FBMC30
     C                   MOVE      *BLANK        FBMC31
     C                   MOVE      *BLANK        FBMC32
     C                   MOVE      *BLANK        FBMC33
     C                   MOVE      *BLANK        FBMC34
     C                   MOVE      *BLANK        FBMC35
     C                   MOVE      *BLANK        FBMC36
     C                   MOVE      *BLANK        FBMC37
     C                   MOVE      *BLANK        FBMC38
     C                   MOVE      *BLANK        FBMC39
     C                   MOVE      *BLANK        FBMC40
     C                   MOVE      *BLANK        FBMC41
     C                   MOVE      *BLANK        FBMC42
     C                   MOVE      *BLANK        FBMC43
     C                   MOVE      *BLANK        FBMC44
     C                   MOVE      *BLANK        FBMC45
     C                   MOVE      *BLANK        FBMC46
     C                   MOVE      *BLANK        FBMC47
     C                   MOVE      *BLANK        FBMC48
     C                   MOVE      *BLANK        FBMC49
     C                   MOVE      *BLANK        FBMC50
     C                   MOVE      *BLANK        FBMC51
     C                   MOVE      *BLANK        FBMC52
     C                   MOVE      *BLANK        FBMC53
     C                   MOVE      *BLANK        FBMC54
     C                   MOVE      *BLANK        FBMC55
     C                   MOVE      *BLANK        FBMC56
     C                   MOVE      *BLANK        FBMC57
     C                   MOVE      *BLANK        FBMC58
     C                   MOVE      *BLANK        FBMC59
     C                   MOVE      *BLANK        FBMC60
      *
     C                   ENDSR
      *----------------------------------------------------*
      * HEADER YEAR-MONTH
      *----------------------------------------------------*
     C     #HDR2         BEGSR
      *
     C                   Z-ADD     *ZERO         @A                2 0
     C                   MOVEL     'QTY_'        #QTY              4
     C                   MOVEL     'AMT_'        #AMT              4
     C                   MOVEL     'UPR_'        #UPR              4
      *
     C                   DO        @SIZI
     C                   ADD       1             @A
      *
     C     @A            IFGT      @SIZI
     C                   LEAVE
     C                   ENDIF
      *
     C     #H1(@A)       MULT      100           @YYMM             6 0
     C                   ADD       #H2(@A)       @YYMM
     C                   MOVEL     @YYMM         #YYMM             6
     C     #QTY          CAT       #YYMM         F6Q(@A)
     C     #AMT          CAT       #YYMM         F6A(@A)
     C     #UPR          CAT       #YYMM         F6P(@A)
      *
     C                   ENDDO
      *
     C                   ENDSR
      *----------------------------------------------------*
      * SET DETAIL QTY/AMT/UPR
      *----------------------------------------------------*
     C     #DTL2         BEGSR
      *
     C                   Z-ADD     *ZERO         @A                2 0
      *
     C                   DO        @SIZI
     C                   ADD       1             @A
      *
     C     @A            IFGT      @SIZI
     C                   LEAVE
     C                   ENDIF
      *
     C                   MOVEL     F3Q(@A)       F6Q(@A)
     C                   MOVEL     F3A(@A)       F6A(@A)
     C**                 MOVEL     F3P(@A)       F6P(@A)
     C                   EVAL      F6P(@A) = %CHAR(F3P(@A))
     C                   ENDDO
      *
     C                   ENDSR

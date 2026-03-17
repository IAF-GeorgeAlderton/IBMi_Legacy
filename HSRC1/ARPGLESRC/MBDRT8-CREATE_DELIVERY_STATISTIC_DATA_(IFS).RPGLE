     H DATEDIT(*YMD/)
     F*** MBDRT8 *******************************************
     F* CREATE DELIVERY STATISTIC DATA (IFS)               *
     *** CAUTION !!! COMPLIE WITH RPGLE (not RPG3) ***
     F* JW(SRA) 2016/07/07 CRT                             *
JW4  F* JW(SRA) 2017/10/03 add SORT Field                  *
JW5  F* JW(SRA) 2018/06/15 add Machine Form Name           *
JW6  F* JW(SRA) 2020/01/10 add Component Part 1/2/3        *
JW6  F* JW6     2020/04/17 CHG APLC11 --> UTLC11           *
JW7  F* JW7     2021/05/17 add Part/Machine                *
JW8  F* JW8     2021/07/01 add Material Property           *
JW9  F* JW9     2022/09/22 add Pickup Condition            *
 .   F*  .      2022/10/28 chg price method                *
 .   F* JW9     2023/02/02 add Production Date             *
JWA  F* JWA     2023/08/15 fix Price (#UPRC)               *
     F******************************************************
     FMBDPL11   IF   E           K DISK
     FFCEPL01   IF   E           K DISK
     FAAMPL11   IF   E           K DISK
     FEDIPP42   IF   E           K DISK
     FEDIPP43   IF   E           K DISK
JW5  FMFAPL34   IF   E           K DISK
JW6  FAEBPL01   IF   E           K DISK
JW6  FFCEPL40   IF   E           K DISK
      *
     FMBDWPT5   O    E             DISK
JW7  FMBDWPT5A  O    E             DISK
JW7  FMBDWPTB   IF   E           K DISK
      *****************************************************************
     D S               S              2  0
     D #H1             S              4  0 DIM(24)
     D #H2             S              2  0 DIM(24)
     D F3S             S              3  0 DIM(15)
     D F3C             S              4  0 DIM(15)
JW9  D JOK             S              2    DIM(7)
JW9  D JNM             S             20    DIM(7)
      *
      *----------------------------------------------------------------
JWA  D                 DS
 .   D  SDATE                  1     14  0
 .   D  NOW                    1      6  0
 .   D  TODAY                  7     14  0
JWA  D                 DS
 .   D  A2TAHZ                 1      8  0
 .   D  A2TAYY                 1      4  0
 .   D  A2TAMM                 5      6  0
JWA  D  A2TADD                 7      8  0
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
     D F3Q                     1    168  0 DIM(24)
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
      *MBDWPT51 (QTY)
     D                 DS
     D F5Q                     1    240    DIM(24)
     D F5QT01                  1     10
     D F5QT02                 11     20
     D F5QT03                 21     30
     D F5QT04                 31     40
     D F5QT05                 41     50
     D F5QT06                 51     60
     D F5QT07                 61     70
     D F5QT08                 71     80
     D F5QT09                 81     90
     D F5QT10                 91    100
     D F5QT11                101    110
     D F5QT12                111    120
     D F5QT13                121    130
     D F5QT14                131    140
     D F5QT15                141    150
     D F5QT16                151    160
     D F5QT17                161    170
     D F5QT18                171    180
     D F5QT19                181    190
     D F5QT20                191    200
     D F5QT21                201    210
     D F5QT22                211    220
     D F5QT23                221    230
     D F5QT24                231    240
      *MBDWPT31 (AMT)
     D                 DS
     D F3A                     1    168  0 DIM(24)
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
      *MBDWPT51 (AMT)
     D                 DS
     D F5A                     1    240    DIM(24)
     D F5AM01                  1     10
     D F5AM02                 11     20
     D F5AM03                 21     30
     D F5AM04                 31     40
     D F5AM05                 41     50
     D F5AM06                 51     60
     D F5AM07                 61     70
     D F5AM08                 71     80
     D F5AM09                 81     90
     D F5AM10                 91    100
     D F5AM11                101    110
     D F5AM12                111    120
     D F5AM13                121    130
     D F5AM14                131    140
     D F5AM15                141    150
     D F5AM16                151    160
     D F5AM17                161    170
     D F5AM18                171    180
     D F5AM19                181    190
     D F5AM20                191    200
     D F5AM21                201    210
     D F5AM22                211    220
     D F5AM23                221    230
     D F5AM24                231    240
      *MBDWPT31 (PRICE)
     D                 DS
     D F3P                     1    264  5 DIM(24)
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
      *MBDWPT51 (PRICE)
     D                 DS
     D F5P                     1    264    DIM(24)
     D F5PR01                  1     11
     D F5PR02                 12     22
     D F5PR03                 23     33
     D F5PR04                 34     44
     D F5PR05                 45     55
     D F5PR06                 56     66
     D F5PR07                 67     77
     D F5PR08                 78     88
     D F5PR09                 89     99
     D F5PR10                100    110
     D F5PR11                111    121
     D F5PR12                122    132
     D F5PR13                133    143
     D F5PR14                144    154
     D F5PR15                155    165
     D F5PR16                166    176
     D F5PR17                177    187
     D F5PR18                188    198
     D F5PR19                199    209
     D F5PR20                210    220
     D F5PR21                221    231
     D F5PR22                232    242
     D F5PR23                243    253
     D F5PR24                254    264
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
JW8   * SHIN
 .   D                 DS
 .   D F2SHIN                  1     12
 .   D D1HIN1                  1      5
 .   D D1HIN2                  6     10
JW8  D D1HIN3                 11     12
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
      *
JW6  D                 DS
 |   D CMP                     1     75    DIM(5)
 |   D F5CMP1                  1     15
 |   D F5CMP2                 16     30
 |   D F5CMP3                 31     45
 |   D F5CMP4                 46     60
JW6  D F5CMP5                 61     75
      *
JW6  D                 DS
 |   D AFKHN                   1     14
 |   D AFKHN1                  1      5
 |   D AFK1                    6      6
 |   D AFKHN2                  7     11
 |   D AFK2                   12     12
JW6  D AFKHN3                 13     14
      *****************************************************************
      *                    MAIN ROUTINE
      *****************************************************************
      * INIT
     C                   EXSR      #INIT
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
      * OUTPUT AB#WPT5
     C                   XFOOT     F3Q           F3QT99            8 0
     C                   XFOOT     F3A           F3AM99            8 0
     C                   MOVEL     F3QT99        F5QT99
     C                   MOVEL     F3AM99        F5AM99
      * GET FCEPP INFO.
     C                   EXSR      #FCEP
     C                   EXSR      #DTL2
     C                   WRITE     MBDWPT51
     C                   ADD       1             RCNT              6 0
JW7   * DETAIL
 .   C     F5SHIN        CHAIN     MBDWPTB                            99
 .   C     *IN99         IFEQ      *ON
 .   C                   EXSR      #CLRM
 .   C                   MOVEL     F5SHIN        FBPART
 .   C                   MOVE      '*'           FBPART
 .   C                   ENDIF
JWA  C                   EVAL      FBPRHZ = %EDITC(A2TAHZ:'Y')
JW7  C                   WRITE     MBDWT5A1
      *
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
     C                   CLEAR                   MBDWPT51
jw1  C                   z-add     0             F3Q
jw1  C                   z-add     0             F3A
jw1  C                   z-add     0             F3P
      *
     C                   ENDSR
      *----------------------------------------------------*
      *          GET PRODUCTION INFORMATION
      *----------------------------------------------------*
     C     #FCEP         BEGSR
      *
     C                   SETOFF                                       53
     C                   MOVE      SVSHN1        K@SHN1
     C                   MOVE      SVSHN2        K@SHN2
     C                   MOVE      SVSHN3        K@SHN3
     C     FCEKEY        CHAIN     FCEPL011                           53
     C     *IN53         IFEQ      *OFF
     C     A2GSKD        IFEQ      'D'
     C**   A2GSH8        ANDLE     *DATE
JWA  C     A2GSH8        ANDLE     TODAY
     C                   SETON                                        53
     C                   ENDIF
     C                   ENDIF
      * get BPT
     C     FCEKEY        CHAIN     FCEPL40                            96
     C     *IN96         IFEQ      *OFF
     C                   EVAL      F5BPT=F4HPR1 + '-' + F4HPR2 +
     C                                            '-' + F4HPR3
     C                   ENDIF
      *
     C     FCEKEY        CHAIN     AAMPL111                           53
     C**   *IN53         IFEQ      '0'
     C**   CKSKJY        IFEQ      'D'
     C**   CKGSH8        ANDLE     *DATE
     C**                 SETON                                        53
     C**                 ENDIF
     C**                 ENDIF
      *
     C     *IN53         IFEQ      *OFF
     C**                 MOVEL     A2TUSZ        F5MSIZ
add  C                   EVAL      F5MSIZ = %CHAR(A2TUSZ)
add  C                   EVAL      F5DIAM = %CHAR(A2KAZI)
     C                   MOVEL     A2KUBI        F5SHNK
     C                   MOVEL     A2SSYS        F5QPC
     C                   MOVEL     A2MEK         F5MEKI
     C                   MOVEL     A2ZANM        F5MATE
      * Process
     C                   MOVEL     CKKO01        F5PC01
     C                   MOVEL     CKKO02        F5PC02
     C                   MOVEL     CKKO03        F5PC03
     C                   MOVEL     CKKO04        F5PC04
     C                   MOVEL     CKKO05        F5PC05
     C                   MOVEL     CKKO06        F5PC06
     C                   MOVEL     CKKO07        F5PC07
     C                   MOVEL     CKKO08        F5PC08
     C                   MOVEL     CKKO09        F5PC09
     C                   MOVEL     CKKO10        F5PC10
     C                   MOVEL     CKKO11        F5PC11
     C                   MOVEL     CKKO12        F5PC12
     C                   MOVEL     CKKO13        F5PC13
     C                   MOVEL     CKKO14        F5PC14
     C                   MOVEL     CKKO15        F5PC15
      * Dept
     c     CKBM01        IFNE      0
     C                   MOVEL     CKBM01        F5CD01
     C                   ENDIF
     c     CKBM02        IFNE      0
     C                   MOVEL     CKBM02        F5CD02
     C                   ENDIF
     c     CKBM03        IFNE      0
     C                   MOVEL     CKBM03        F5CD03
     C                   ENDIF
     c     CKBM04        IFNE      0
     C                   MOVEL     CKBM04        F5CD04
     C                   ENDIF
     c     CKBM05        IFNE      0
     C                   MOVEL     CKBM05        F5CD05
     C                   ENDIF
     c     CKBM06        IFNE      0
     C                   MOVEL     CKBM06        F5CD06
     C                   ENDIF
     c     CKBM07        IFNE      0
     C                   MOVEL     CKBM07        F5CD07
     C                   ENDIF
     c     CKBM08        IFNE      0
     C                   MOVEL     CKBM08        F5CD08
     C                   ENDIF
     c     CKBM09        IFNE      0
     C                   MOVEL     CKBM09        F5CD09
     C                   ENDIF
     c     CKBM10        IFNE      0
     C                   MOVEL     CKBM10        F5CD10
     C                   ENDIF
     c     CKBM11        IFNE      0
     C                   MOVEL     CKBM11        F5CD11
     C                   ENDIF
     c     CKBM12        IFNE      0
     C                   MOVEL     CKBM12        F5CD12
     C                   ENDIF
     c     CKBM13        IFNE      0
     C                   MOVEL     CKBM13        F5CD13
     C                   ENDIF
     c     CKBM14        IFNE      0
     C                   MOVEL     CKBM14        F5CD14
     C                   ENDIF
     c     CKBM15        IFNE      0
     C                   MOVEL     CKBM15        F5CD15
     C                   ENDIF
      * Machine
     C                   MOVEL     CKKB01        F5MC01
     C                   MOVEL     CKKB02        F5MC02
     C                   MOVEL     CKKB03        F5MC03
     C                   MOVEL     CKKB04        F5MC04
     C                   MOVEL     CKKB05        F5MC05
     C                   MOVEL     CKKB06        F5MC06
     C                   MOVEL     CKKB07        F5MC07
     C                   MOVEL     CKKB08        F5MC08
     C                   MOVEL     CKKB09        F5MC09
     C                   MOVEL     CKKB10        F5MC10
     C                   MOVEL     CKKB11        F5MC11
     C                   MOVEL     CKKB12        F5MC12
     C                   MOVEL     CKKB13        F5MC13
     C                   MOVEL     CKKB14        F5MC14
     C                   MOVEL     CKKB15        F5MC15
JW5   * Machine Format Nmae
 |   C                   MOVEL     *BLANK        F5MF01
 |   C                   MOVEL     *BLANK        F5MF02
 |   C                   MOVEL     *BLANK        F5MF03
 |   C                   MOVEL     *BLANK        F5MF04
 |   C                   MOVEL     *BLANK        F5MF05
 |   C                   MOVEL     *BLANK        F5MF06
 |   C                   MOVEL     *BLANK        F5MF07
 |   C                   MOVEL     *BLANK        F5MF08
 |   C                   MOVEL     *BLANK        F5MF09
 |   C                   MOVEL     *BLANK        F5MF10
 |   C                   MOVEL     *BLANK        F5MF11
 |   C                   MOVEL     *BLANK        F5MF12
 |   C                   MOVEL     *BLANK        F5MF13
 |   C                   MOVEL     *BLANK        F5MF14
 |   C                   MOVEL     *BLANK        F5MF15
 |    *
 |   C     CKKB01        IFNE      *BLANK
 |   C     CKKB01        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF01
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB02        IFNE      *BLANK
 |   C     CKKB02        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF02
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB03        IFNE      *BLANK
 |   C     CKKB03        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF03
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB04        IFNE      *BLANK
 |   C     CKKB04        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF04
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB05        IFNE      *BLANK
 |   C     CKKB05        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF05
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB06        IFNE      *BLANK
 |   C     CKKB06        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF06
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB07        IFNE      *BLANK
 |   C     CKKB07        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF07
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB08        IFNE      *BLANK
 |   C     CKKB08        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF08
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB09        IFNE      *BLANK
 |   C     CKKB09        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF09
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB10        IFNE      *BLANK
 |   C     CKKB10        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF10
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB11        IFNE      *BLANK
 |   C     CKKB11        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF11
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB12        IFNE      *BLANK
 |   C     CKKB12        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF12
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB13        IFNE      *BLANK
 |   C     CKKB13        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF13
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB14        IFNE      *BLANK
 |   C     CKKB14        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF14
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB15        IFNE      *BLANK
 |   C     CKKB15        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F5MF15
 |   C                   ENDIF
JW5  C                   ENDIF
      *
JW2   *MATERIAL WGT
 |   C**                 MOVEL     A2SOZI        F5MWGT
 |   C                   EVAL      F5MWGT = %CHAR(A2SOZI)
 |    *FINISH   WGT
JW2  C**                 MOVEL     A2KASI        F5FWGT
JW2  C                   EVAL      F5FWGT = %CHAR(A2KASI)
      *MONTHLY SET
JW3  C**                 MOVEL     A2GEKN        F5MSET
JW3  C                   EVAL      F5MSET = %CHAR(A2GEKN)
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
JW4  C                   MOVEL     U@CHR3        F5SORT
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
 |   C                   EVAL      F5LLOC = $LOC1 + '-' + $LOC2 + '-'
JW4  C                                    + $LOC3 + '-' +$LOC4
      *
jw5  C                   MOVEL     A2UKER        F5UKER
JW9   * get Pickup Condition
 .   C                   MOVEL     F2SHIN        PSHIN
 .   c                   CALL      'UEXR06B'
 .   c                   PARM                    PSHIN            12
 .   c                   PARM                    PJOK             14
 .   c                   PARM                    PJNM            140
 .   C                   MOVEA     PJOK          JOK
 .   C                   MOVEA     PJNM          JNM
 .    * 1
 .   C     JOK(1)        IFEQ      '  '
 .   C                   EVAL      F5PKC1 = ' '
 .   C                   ELSE
 .   C                   EVAL      F5PKC1 = jok(1) + ': ' + jnm(1)
 .   C                   ENDIF
 .    * 2
 .   C     JOK(2)        IFEQ      '  '
 .   C                   EVAL      F5PKC2 = ' '
 .   C                   ELSE
 .   C                   EVAL      F5PKC2 = jok(2) + ': ' + jnm(2)
 .   C                   ENDIF
 .    * 3
 .   C     JOK(3)        IFEQ      '  '
 .   C                   EVAL      F5PKC3 = ' '
 .   C                   ELSE
 .   C                   EVAL      F5PKC3 = jok(3) + ': ' + jnm(3)
JW9  C                   ENDIF
      *
JW8   * get Material Property
 .   C                   MOVEL     F2SHIN        $SHIN
 .   C                   CALL      'UEXR34B'
 .   C                   PARM                    $SHIN            12
 .   C                   PARM                    $ZAIS            15
 .   C                   PARM                    $ZAIK             5 2
 .   C                   PARM                    $KIKI             3 1
 .   C                   PARM                    $RTN              1
JW8  C                   EVAL      F5KIKI = %CHAR($KIKI)
JW6   * get Component Part
 |   C                   MOVEA     *BLANK        CMP
 |   C                   Z-ADD     0             IX                2 0
 |   C     FCEKEY        SETLL     AEBPL01
 |    *
 |   C                   DO        *HIVAL
 |   C     FCEKEY        READE     AEBPL01                                97
 |   C   97              LEAVE
      *
 |   C                   IF        AFSKJY<>*BLANK
 |   C                   ITER
 |   C                   ENDIF
 |    *
 |   C                   ADD       1             IX
 |   C                   IF        IX >= 6
 |   C                   LEAVE
 |   C                   ENDIF
 |    *
 |   C                   MOVE      ' '           AFK1
 |   C                   MOVE      ' '           AFK2
 |   C                   IF        AFKHN2<>*BLANK
 |   C                   MOVE      '-'           AFK1
 |   C                   ENDIF
 |   C                   IF        AFKHN3<>*BLANK
 |   C                   MOVE      '-'           AFK2
 |   C                   ENDIF
 |   C                   MOVEL     AFKHN         CMP(IX)
 |    *
JW6  C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *          PROCESS (SUMMARIZE BY PART, YEAR)
      *****************************************************************
     C     #PROC         BEGSR
      * GET CUSTOMER GROUP
     C                   MOVE      *BLANK        F5GRP
     C                   MOVEL     F4TOKU        LTR4              4
     C     LTR4          CHAIN     EDIPP42                            99
     C     *IN99         IFEQ      *OFF
     C**   E4SKJY        ANDNE     'D'
     C     E4GRP         CHAIN     EDIPP43                            98
     C     *IN98         IFEQ      *OFF
     C**   E3SKJY        ANDNE     'D'
     C                   MOVEL     E3GPNM        F5GRP
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     F4TOKU        F5TOKU
     C                   MOVEL     F4NONY        F5NONY
     C                   MOVE      *BLANK        F5TONM
      * GET CUST NAME
     C                   MOVEL     F4NONY        PMNONY
     C                   MOVE      'D'           PMOPT
     C                   CALL      'UTLR16'
     C                   PARM                    PMNONY            4
     C                   PARM                    PMOPT             1
     C                   PARM                    PMNAME           20
     C                   PARM                    PTOKU             4
     C                   PARM                    PMRTN             1
     C                   MOVEL     PMNAME        F5TONM
      *
     C                   MOVEL     F4NKOJ        F5NKOJ
     C                   MOVEL     F4NUKE        F5NUKE
     C                   MOVEL     F4MHN         F5MHIN
     C                   MOVEL     F4SHN         F5SHIN
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
      * LOOP
     C                   DO        @SIZI
     C                   ADD       1             @M
      *
     C     #H1(@M)       IFEQ      0
     C                   GOTO      $UPRCX
     C                   ENDIF
      *
     C                   Z-ADD     #H1(@M)       TGT@YY
     C                   Z-ADD     #H2(@M)       TGT@MM
      * GET PRICE
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
     C**   K#PL01        KLIST
     C**                 KFLD                    A2SHN1
     C**                 KFLD                    A2SHN2
     C**                 KFLD                    A2SHN3
      *
JWA  C                   TIME                    SDATE
     C                   MOVE      *BLANK        P@STS
     C                   MOVEL     P@TOKU        @TOKU             4 0
     C                   MOVEL     P@NONY        @NONY             4 0
     C                   MOVEL     P@NKOJ        @NKOJ             1
     C                   MOVEL     P@NUKE        @NUKE             4
     C                   MOVEL     P@YYYY        @YYYY             4 0
     C                   MOVEL     P@MM          @MM               2 0
     C                   CLEAR                   MBDWPT51
     C                   MOVEL     'Y'           FIRST             1
     C                   MOVEL     P@TYPE        @T                1 0
     C                   Z-ADD     0             @M                2 0
     C**                 Z-ADD     *DATE         @DATE             8 0
JWA  C                   Z-ADD     TODAY         @DATE             8 0
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
     C                   ENDSL
     C                   Z-ADD     *ZERO         #H1
     C                   Z-ADD     *ZERO         #H2
     C                   EXSR      #MON
      * OUTPUT HEADER
     C                   EXSR      #HDR
     C                   CLEAR                   MBDWPT51
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
     C                   CLEAR                   MBDWPT51
      *
     C                   MOVEL     'GROUP'       F5GRP
     C                   MOVEL     'CUST#'       F5TOKU
     C                   MOVEL     'DELIV#'      F5NONY
     C                   MOVEL     'CS_NAME'     F5TONM
     C                   MOVEL     'FACTORY'     F5NKOJ
     C                   MOVEL     'DOCK'        F5NUKE
     C                   MOVEL     'USR_PART'    F5MHIN
     C                   MOVEL     'IAF_PART'    F5SHIN
     C                   MOVEL     'MONTH_SET'   F5MSET
      *
     C                   EXSR      #HDR2
      *
     C                   MOVEL     'QTY_TTL'     F5QT99
     C                   MOVEL     'AMT_TTL'     F5AM99
      *
     C                   MOVEL     'QTY/CNT'     F5QPC
     C                   MOVEL     'MAT_NAME'    F5MATE
     C                   MOVEL     'MEKKI'       F5MEKI
     C                   MOVEL     'M_SIZE'      F5MSIZ
add  C                   MOVEL     'M_DIAMETER'  F5DIAM
     C                   MOVEL     'SHANK'       F5SHNK
      *
     C                   MOVEL     'PROC_01'     F5PC01
     C                   MOVEL     'PROC_02'     F5PC02
     C                   MOVEL     'PROC_03'     F5PC03
     C                   MOVEL     'PROC_04'     F5PC04
     C                   MOVEL     'PROC_05'     F5PC05
     C                   MOVEL     'PROC_06'     F5PC06
     C                   MOVEL     'PROC_07'     F5PC07
     C                   MOVEL     'PROC_08'     F5PC08
     C                   MOVEL     'PROC_09'     F5PC09
     C                   MOVEL     'PROC_10'     F5PC10
     C                   MOVEL     'PROC_11'     F5PC11
     C                   MOVEL     'PROC_12'     F5PC12
     C                   MOVEL     'PROC_13'     F5PC13
     C                   MOVEL     'PROC_14'     F5PC14
     C                   MOVEL     'PROC_15'     F5PC15
      *
     C                   MOVEL     'CODE_01'     F5CD01
     C                   MOVEL     'CODE_02'     F5CD02
     C                   MOVEL     'CODE_03'     F5CD03
     C                   MOVEL     'CODE_04'     F5CD04
     C                   MOVEL     'CODE_05'     F5CD05
     C                   MOVEL     'CODE_06'     F5CD06
     C                   MOVEL     'CODE_07'     F5CD07
     C                   MOVEL     'CODE_08'     F5CD08
     C                   MOVEL     'CODE_09'     F5CD09
     C                   MOVEL     'CODE_10'     F5CD10
     C                   MOVEL     'CODE_11'     F5CD11
     C                   MOVEL     'CODE_12'     F5CD12
     C                   MOVEL     'CODE_13'     F5CD13
     C                   MOVEL     'CODE_14'     F5CD14
     C                   MOVEL     'CODE_15'     F5CD15
      *
     C                   MOVEL     'MCN_01'      F5MC01
     C                   MOVEL     'MCN_02'      F5MC02
     C                   MOVEL     'MCN_03'      F5MC03
     C                   MOVEL     'MCN_04'      F5MC04
     C                   MOVEL     'MCN_05'      F5MC05
     C                   MOVEL     'MCN_06'      F5MC06
     C                   MOVEL     'MCN_07'      F5MC07
     C                   MOVEL     'MCN_08'      F5MC08
     C                   MOVEL     'MCN_09'      F5MC09
     C                   MOVEL     'MCN_10'      F5MC10
     C                   MOVEL     'MCN_11'      F5MC11
     C                   MOVEL     'MCN_12'      F5MC12
     C                   MOVEL     'MCN_13'      F5MC13
     C                   MOVEL     'MCN_14'      F5MC14
     C                   MOVEL     'MCN_15'      F5MC15
JW5   *
 |   C                   MOVEL     'MFN_01'      F5MF01
 |   C                   MOVEL     'MFN_02'      F5MF02
 |   C                   MOVEL     'MFN_03'      F5MF03
 |   C                   MOVEL     'MFN_04'      F5MF04
 |   C                   MOVEL     'MFN_05'      F5MF05
 |   C                   MOVEL     'MFN_06'      F5MF06
 |   C                   MOVEL     'MFN_07'      F5MF07
 |   C                   MOVEL     'MFN_08'      F5MF08
 |   C                   MOVEL     'MFN_09'      F5MF09
 |   C                   MOVEL     'MFN_10'      F5MF10
 |   C                   MOVEL     'MFN_11'      F5MF11
 |   C                   MOVEL     'MFN_12'      F5MF12
 |   C                   MOVEL     'MFN_13'      F5MF13
 |   C                   MOVEL     'MFN_14'      F5MF14
JW5  C                   MOVEL     'MFN_15'      F5MF15
      *
     C                   MOVEL     'MAT_WGT'     F5MWGT
     C                   MOVEL     'FIN_WGT'     F5FWGT
JW4  C                   MOVEL     'SORT   '     F5SORT
JW4  C                   MOVEL     'LAST_LOC'    F5LLOC
JW5  C                   MOVEL     'RCV_POINT'   F5UKER
JW8  C                   MOVEL     'PICKUP_1-1'  F5PKC1
JW8  C                   MOVEL     'PICKUP_1-2'  F5PKC2
JW8  C                   MOVEL     'PICKUP_1-3'  F5PKC3
JW8  C                   eval      F5KIKI= 'M_PROPERTY'
JW5  C                   eval      F5PGM = '(PGM: MBDCT7)'
      *
JW6  C                   MOVEL     'COMPO_1'     F5CMP1
 |   C                   MOVEL     'COMPO_2'     F5CMP2
 |   C                   MOVEL     'COMPO_3'     F5CMP3
 |   C                   MOVEL     'COMPO_4'     F5CMP4
JW6  C                   MOVEL     'COMPO_5'     F5CMP5
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
JW6  C                   MOVEL     'HALF_FINISH' F5BPT
      *
     C                   WRITE     MBDWPT51
JW7   * HEADER
 .   C     *BLANK        CHAIN     MBDWPTB                            99
 .   C                   MOVEL     'IAF PART'    FBPART
JWA  C                   MOVEL     'PROD_DATE'   FBPRHZ
 .   C     *IN99         IFEQ      *ON
 .   C                   EXSR      #CLRM
 .   C                   ENDIF
      *
JW7  C                   WRITE     MBDWT5A1
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
     C     #QTY          CAT       #YYMM         F5Q(@A)
     C     #AMT          CAT       #YYMM         F5A(@A)
     C     #UPR          CAT       #YYMM         F5P(@A)
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
     C                   MOVEL     F3Q(@A)       F5Q(@A)
     C                   MOVEL     F3A(@A)       F5A(@A)
     C**                 MOVEL     F3P(@A)       F5P(@A)
     C                   EVAL      F5P(@A) = %CHAR(F3P(@A))
     C                   ENDDO
      *
     C                   ENDSR

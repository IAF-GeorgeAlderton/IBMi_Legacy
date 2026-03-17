     H DATEDIT(*YMD/)
     F*** MBDRT8 *******************************************
     F* CREATE DELIVERY STATISTIC DATA (IFS)               *
     *** CAUTION !!! COMPLIE WITH RPGLE (not RPG3) ***
     F* JW(SRA) 2016/07/07 CRT                             *
JW4  F* JW(SRA) 2017/10/03 add SORT Field                  *
JW5  F* JW(SRA) 2018/06/15 add Machine Form Name           *
JW5  F* JW1     2020/04/17 CHG APLC11 --> UTLC11           *
     F******************************************************
     FMBDPL18   IF   E           K DISK
     FFCEPL01   IF   E           K DISK
     FAAMPL11   IF   E           K DISK
     FEDIPP42   IF   E           K DISK
     FEDIPP43   IF   E           K DISK
JW5  FMFAPL34   IF   E           K DISK
     FMBDWPP8   O    E             DISK
      *****************************************************************
     D S               S              2  0
     D #H1             S              4  0 DIM(24)
     D #H2             S              2  0 DIM(24)
      *
      *----------------------------------------------------------------
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
      *MBDPL18(QTY)
     D                 DS
     D F4Q                     1     84  0 DIM(12)
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
      ** WORK(QTY) **
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
      *MBDWPP81 (QTY)
     D                 DS
     D F8Q                     1    240    DIM(24)
     D F8QT01                  1     10
     D F8QT02                 11     20
     D F8QT03                 21     30
     D F8QT04                 31     40
     D F8QT05                 41     50
     D F8QT06                 51     60
     D F8QT07                 61     70
     D F8QT08                 71     80
     D F8QT09                 81     90
     D F8QT10                 91    100
     D F8QT11                101    110
     D F8QT12                111    120
     D F8QT13                121    130
     D F8QT14                131    140
     D F8QT15                141    150
     D F8QT16                151    160
     D F8QT17                161    170
     D F8QT18                171    180
     D F8QT19                181    190
     D F8QT20                191    200
     D F8QT21                201    210
     D F8QT22                211    220
     D F8QT23                221    230
     D F8QT24                231    240
      *MBDWPP81 (BOX)
     D                 DS
     D F8B                     1    240    DIM(24)
     D F8BX01                  1     10
     D F8BX02                 11     20
     D F8BX03                 21     30
     D F8BX04                 31     40
     D F8BX05                 41     50
     D F8BX06                 51     60
     D F8BX07                 61     70
     D F8BX08                 71     80
     D F8BX09                 81     90
     D F8BX10                 91    100
     D F8BX11                101    110
     D F8BX12                111    120
     D F8BX13                121    130
     D F8BX14                131    140
     D F8BX15                141    150
     D F8BX16                151    160
     D F8BX17                161    170
     D F8BX18                171    180
     D F8BX19                181    190
     D F8BX20                191    200
     D F8BX21                201    210
     D F8BX22                211    220
     D F8BX23                221    230
     D F8BX24                231    240
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
      * SETLL
     C     @TOKU         IFEQ      9999
     C     *LOVAL        SETLL     MBDPL18
     C                   ELSE
     C     @TOKU         SETLL     MBDPL18
     C                   ENDIF
      * LOOP -----------------------------------
     C     *IN90         DOWEQ     *OFF
      * READ
     C                   READ      MBDPL18                                90
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
     C**   @NKOJ         IFNE      *BLANK
     C**   @NKOJ         ANDNE     F4NKOJ
     C**                 ITER
     C**                 ENDIF
     C* SELECT DOCK
     C**   @NUKE         IFNE      *BLANK
     C**   @NUKE         ANDNE     F4NUKE
     C**                 ITER
     C**                 ENDIF
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
     C**                 MOVEL     F4NKOJ        SVNKOJ            1
     C**                 MOVEL     F4NUKE        SVNUKE            4
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
     C**   F4NKOJ        ORNE      SVNKOJ
     C**   F4NUKE        ORNE      SVNUKE
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
      * OUTPUT AB#WPT3
     C                   XFOOT     F3Q           F3QT99            8 0
     C                   MOVEL     F3QT99        F8QT99
      * GET FCEPP INFO.
     C                   EXSR      #FCEP
     C                   EXSR      #DTL2
     C                   MOVEL     @BOX          F8BX99
     C                   WRITE     MBDWPP81
     C                   ADD       1             RCNT              6 0
      * SAVE KEY
     C                   Z-ADD     F4TOKU        SVTOKU
     C                   Z-ADD     F4NONY        SVNONY
     C**                 MOVEL     F4NKOJ        SVNKOJ
     C**                 MOVEL     F4NUKE        SVNUKE
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
     C                   CLEAR                   MBDWPP81
jw1  C                   Z-ADD     0             F3Q
jw1  C                   Z-ADD     0             @BOX
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
     C     A2GSH8        ANDLE     *DATE
     C                   SETON                                        53
     C                   ENDIF
     C                   ENDIF
     C     FCEKEY        CHAIN     AAMPL111                           53
     C     *IN53         IFEQ      *OFF
     C                   MOVEL     A2TUSZ        F8MSIZ
add  C                   EVAL      F8DIAM = %CHAR(A2KAZI)
     C                   MOVEL     A2KUBI        F8SHNK
     C                   MOVEL     A2SSYS        F8QPC
     C                   Z-ADD     A2SSYS        @QPC              6 0
     C                   MOVEL     A2MEK         F8MEKI
     C                   MOVEL     A2ZANM        F8MATE
      * Process
     C                   MOVEL     CKKO01        F8PC01
     C                   MOVEL     CKKO02        F8PC02
     C                   MOVEL     CKKO03        F8PC03
     C                   MOVEL     CKKO04        F8PC04
     C                   MOVEL     CKKO05        F8PC05
     C                   MOVEL     CKKO06        F8PC06
     C                   MOVEL     CKKO07        F8PC07
     C                   MOVEL     CKKO08        F8PC08
     C                   MOVEL     CKKO09        F8PC09
     C                   MOVEL     CKKO10        F8PC10
     C                   MOVEL     CKKO11        F8PC11
     C                   MOVEL     CKKO12        F8PC12
     C                   MOVEL     CKKO13        F8PC13
     C                   MOVEL     CKKO14        F8PC14
     C                   MOVEL     CKKO15        F8PC15
      * Dept
     c     CKBM01        IFNE      0
     C                   MOVEL     CKBM01        F8CD01
     C                   ENDIF
     c     CKBM02        IFNE      0
     C                   MOVEL     CKBM02        F8CD02
     C                   ENDIF
     c     CKBM03        IFNE      0
     C                   MOVEL     CKBM03        F8CD03
     C                   ENDIF
     c     CKBM04        IFNE      0
     C                   MOVEL     CKBM04        F8CD04
     C                   ENDIF
     c     CKBM05        IFNE      0
     C                   MOVEL     CKBM05        F8CD05
     C                   ENDIF
     c     CKBM06        IFNE      0
     C                   MOVEL     CKBM06        F8CD06
     C                   ENDIF
     c     CKBM07        IFNE      0
     C                   MOVEL     CKBM07        F8CD07
     C                   ENDIF
     c     CKBM08        IFNE      0
     C                   MOVEL     CKBM08        F8CD08
     C                   ENDIF
     c     CKBM09        IFNE      0
     C                   MOVEL     CKBM09        F8CD09
     C                   ENDIF
     c     CKBM10        IFNE      0
     C                   MOVEL     CKBM10        F8CD10
     C                   ENDIF
     c     CKBM11        IFNE      0
     C                   MOVEL     CKBM11        F8CD11
     C                   ENDIF
     c     CKBM12        IFNE      0
     C                   MOVEL     CKBM12        F8CD12
     C                   ENDIF
     c     CKBM13        IFNE      0
     C                   MOVEL     CKBM13        F8CD13
     C                   ENDIF
     c     CKBM14        IFNE      0
     C                   MOVEL     CKBM14        F8CD14
     C                   ENDIF
     c     CKBM15        IFNE      0
     C                   MOVEL     CKBM15        F8CD15
     C                   ENDIF
      * Machine
     C                   MOVEL     CKKB01        F8MC01
     C                   MOVEL     CKKB02        F8MC02
     C                   MOVEL     CKKB03        F8MC03
     C                   MOVEL     CKKB04        F8MC04
     C                   MOVEL     CKKB05        F8MC05
     C                   MOVEL     CKKB06        F8MC06
     C                   MOVEL     CKKB07        F8MC07
     C                   MOVEL     CKKB08        F8MC08
     C                   MOVEL     CKKB09        F8MC09
     C                   MOVEL     CKKB10        F8MC10
     C                   MOVEL     CKKB11        F8MC11
     C                   MOVEL     CKKB12        F8MC12
     C                   MOVEL     CKKB13        F8MC13
     C                   MOVEL     CKKB14        F8MC14
     C                   MOVEL     CKKB15        F8MC15
JW5   * Machine Format Nmae
 |   C                   MOVEL     *BLANK        F8MF01
 |   C                   MOVEL     *BLANK        F8MF02
 |   C                   MOVEL     *BLANK        F8MF03
 |   C                   MOVEL     *BLANK        F8MF04
 |   C                   MOVEL     *BLANK        F8MF05
 |   C                   MOVEL     *BLANK        F8MF06
 |   C                   MOVEL     *BLANK        F8MF07
 |   C                   MOVEL     *BLANK        F8MF08
 |   C                   MOVEL     *BLANK        F8MF09
 |   C                   MOVEL     *BLANK        F8MF10
 |   C                   MOVEL     *BLANK        F8MF11
 |   C                   MOVEL     *BLANK        F8MF12
 |   C                   MOVEL     *BLANK        F8MF13
 |   C                   MOVEL     *BLANK        F8MF14
 |   C                   MOVEL     *BLANK        F8MF15
 |    *
 |   C     CKKB01        IFNE      *BLANK
 |   C     CKKB01        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF01
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB02        IFNE      *BLANK
 |   C     CKKB02        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF02
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB03        IFNE      *BLANK
 |   C     CKKB03        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF03
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB04        IFNE      *BLANK
 |   C     CKKB04        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF04
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB05        IFNE      *BLANK
 |   C     CKKB05        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF05
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB06        IFNE      *BLANK
 |   C     CKKB06        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF06
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB07        IFNE      *BLANK
 |   C     CKKB07        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF07
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB08        IFNE      *BLANK
 |   C     CKKB08        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF08
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB09        IFNE      *BLANK
 |   C     CKKB09        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF09
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB10        IFNE      *BLANK
 |   C     CKKB10        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF10
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB11        IFNE      *BLANK
 |   C     CKKB11        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF11
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB12        IFNE      *BLANK
 |   C     CKKB12        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF12
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB13        IFNE      *BLANK
 |   C     CKKB13        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF13
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB14        IFNE      *BLANK
 |   C     CKKB14        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF14
 |   C                   ENDIF
 |   C                   ENDIF
 |    *
 |   C     CKKB15        IFNE      *BLANK
 |   C     CKKB15        CHAIN     MFAPL34                            99
 |   C     *IN99         IFEQ      *OFF
 |   C                   MOVEL     M@KEIS        F8MF15
 |   C                   ENDIF
JW5  C                   ENDIF
      *
JW2   *MATERIAL WGT
 |   C**                 MOVEL     A2SOZI        F8MWGT
 |   C                   EVAL      F8MWGT = %CHAR(A2SOZI)
 |    *FINISH   WGT
JW2  C**                 MOVEL     A2KASI        F8FWGT
JW2  C                   EVAL      F8FWGT = %CHAR(A2KASI)
      *MONTHLY SET
JW3  C**                 MOVEL     A2GEKN        F8MSET
JW3  C                   EVAL      F8MSET = %CHAR(A2GEKN)
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
JW4  C                   MOVEL     U@CHR3        F8SORT
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
 |   C                   EVAL      F8LLOC = $LOC1 + '-' + $LOC2 + '-'
JW4  C                                    + $LOC3 + '-' +$LOC4
      *
jw5  C                   MOVEL     A2UKER        F8UKER
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *          PROCESS (SUMMARIZE BY PART, YEAR)
      *****************************************************************
     C     #PROC         BEGSR
      *
     C                   MOVEL     F4TOKU        F8TOKU
     C                   MOVEL     F4NONY        F8NONY
     C                   MOVE      *BLANK        F8TONM
      * GET CUST NAME
     C                   MOVEL     F4NONY        PMNONY
     C                   MOVE      'D'           PMOPT
     C                   CALL      'UTLR16'
     C                   PARM                    PMNONY            4
     C                   PARM                    PMOPT             1
     C                   PARM                    PMNAME           20
     C                   PARM                    PTOKU             4
     C                   PARM                    PMRTN             1
     C                   MOVEL     PMNAME        F8TONM
      *
     C**                 MOVEL     F4NKOJ        F8NKOJ
     C**                 MOVEL     F4NUKE        F8NUKE
     C                   MOVEL     F4MHN         F8MHIN
     C                   MOVEL     F4SHN         F8SHIN
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
     C                   ADD       F4Q(@N)       F3Q(@M)
      *
     C                   ENDDO
      *
     C                   ENDSR
      *----------------------------------------------------*
      *  INITIALIZATION
      *----------------------------------------------------*
     C     #INIT         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@TOKU            4
     C                   PARM                    P@NONY            4
     C**                 PARM                    P@NKOJ            1
     C**                 PARM                    P@NUKE            4
     C                   PARM                    P@YYYY            4
     C                   PARM                    P@MM              2
     C                   PARM                    P@SIZI            1
     C                   PARM                    P@STS             1
      *
     C     FCEKEY        KLIST
     C                   KFLD                    K@SHN1            5
     C                   KFLD                    K@SHN2            5
     C                   KFLD                    K@SHN3            2
      *
     C                   MOVE      *BLANK        P@STS
     C                   MOVEL     P@TOKU        @TOKU             4 0
     C                   MOVEL     P@NONY        @NONY             4 0
     C**                 MOVEL     P@NKOJ        @NKOJ             1
     C**                 MOVEL     P@NUKE        @NUKE             4
     C                   MOVEL     P@YYYY        @YYYY             4 0
     C                   MOVEL     P@MM          @MM               2 0
     C                   CLEAR                   MBDWPP81
     C                   MOVEL     'Y'           FIRST             1
     C**                 MOVEL     P@TYPE        @T                1 0
     C                   Z-ADD     0             @M                2 0
     C                   Z-ADD     *DATE         @DATE             8 0
     C                   Z-ADD     0             F3Q
     C                   Z-ADD     0             @BOX              6 0
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
     C                   CLEAR                   MBDWPP81
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
     C                   CLEAR                   MBDWPP81
      *
     C**                 MOVEL     'GROUP'       F8GRP
     C                   MOVEL     'CUST#'       F8TOKU
     C                   MOVEL     'DELIV#'      F8NONY
     C                   MOVEL     'CS_NAME'     F8TONM
     C**                 MOVEL     'FACTORY'     F8NKOJ
     C**                 MOVEL     'DOCK'        F8NUKE
     C                   MOVEL     'USR_PART'    F8MHIN
     C                   MOVEL     'IAF_PART'    F8SHIN
     C                   MOVEL     'MONTH_SET'   F8MSET
      *
     C                   EXSR      #HDR2
      *
     C                   MOVEL     'QTY_TTL'     F8QT99
     C                   MOVEL     'BOX_TTL'     F8BX99
      *
     C                   MOVEL     'QTY/CNT'     F8QPC
     C                   MOVEL     'MAT_NAME'    F8MATE
     C                   MOVEL     'MEKKI'       F8MEKI
     C                   MOVEL     'M_SIZE'      F8MSIZ
add  C                   MOVEL     'M_DIAMETER'  F8DIAM
     C                   MOVEL     'SHANK'       F8SHNK
      *
     C                   MOVEL     'PROC_01'     F8PC01
     C                   MOVEL     'PROC_02'     F8PC02
     C                   MOVEL     'PROC_03'     F8PC03
     C                   MOVEL     'PROC_04'     F8PC04
     C                   MOVEL     'PROC_05'     F8PC05
     C                   MOVEL     'PROC_06'     F8PC06
     C                   MOVEL     'PROC_07'     F8PC07
     C                   MOVEL     'PROC_08'     F8PC08
     C                   MOVEL     'PROC_09'     F8PC09
     C                   MOVEL     'PROC_10'     F8PC10
     C                   MOVEL     'PROC_11'     F8PC11
     C                   MOVEL     'PROC_12'     F8PC12
     C                   MOVEL     'PROC_13'     F8PC13
     C                   MOVEL     'PROC_14'     F8PC14
     C                   MOVEL     'PROC_15'     F8PC15
      *
     C                   MOVEL     'CODE_01'     F8CD01
     C                   MOVEL     'CODE_02'     F8CD02
     C                   MOVEL     'CODE_03'     F8CD03
     C                   MOVEL     'CODE_04'     F8CD04
     C                   MOVEL     'CODE_05'     F8CD05
     C                   MOVEL     'CODE_06'     F8CD06
     C                   MOVEL     'CODE_07'     F8CD07
     C                   MOVEL     'CODE_08'     F8CD08
     C                   MOVEL     'CODE_09'     F8CD09
     C                   MOVEL     'CODE_10'     F8CD10
     C                   MOVEL     'CODE_11'     F8CD11
     C                   MOVEL     'CODE_12'     F8CD12
     C                   MOVEL     'CODE_13'     F8CD13
     C                   MOVEL     'CODE_14'     F8CD14
     C                   MOVEL     'CODE_15'     F8CD15
      *
     C                   MOVEL     'MCN_01'      F8MC01
     C                   MOVEL     'MCN_02'      F8MC02
     C                   MOVEL     'MCN_03'      F8MC03
     C                   MOVEL     'MCN_04'      F8MC04
     C                   MOVEL     'MCN_05'      F8MC05
     C                   MOVEL     'MCN_06'      F8MC06
     C                   MOVEL     'MCN_07'      F8MC07
     C                   MOVEL     'MCN_08'      F8MC08
     C                   MOVEL     'MCN_09'      F8MC09
     C                   MOVEL     'MCN_10'      F8MC10
     C                   MOVEL     'MCN_11'      F8MC11
     C                   MOVEL     'MCN_12'      F8MC12
     C                   MOVEL     'MCN_13'      F8MC13
     C                   MOVEL     'MCN_14'      F8MC14
     C                   MOVEL     'MCN_15'      F8MC15
JW5   *
 |   C                   MOVEL     'MFN_01'      F8MF01
 |   C                   MOVEL     'MFN_02'      F8MF02
 |   C                   MOVEL     'MFN_03'      F8MF03
 |   C                   MOVEL     'MFN_04'      F8MF04
 |   C                   MOVEL     'MFN_05'      F8MF05
 |   C                   MOVEL     'MFN_06'      F8MF06
 |   C                   MOVEL     'MFN_07'      F8MF07
 |   C                   MOVEL     'MFN_08'      F8MF08
 |   C                   MOVEL     'MFN_09'      F8MF09
 |   C                   MOVEL     'MFN_10'      F8MF10
 |   C                   MOVEL     'MFN_11'      F8MF11
 |   C                   MOVEL     'MFN_12'      F8MF12
 |   C                   MOVEL     'MFN_13'      F8MF13
 |   C                   MOVEL     'MFN_14'      F8MF14
JW5  C                   MOVEL     'MFN_15'      F8MF15
      *
     C                   MOVEL     'MAT_WGT'     F8MWGT
     C                   MOVEL     'FIN_WGT'     F8FWGT
JW4  C                   MOVEL     'SORT   '     F8SORT
JW4  C                   MOVEL     'LAST_LOC'    F8LLOC
JW5  C                   MOVEL     'RCV_POINT'   F8UKER
JW5  C                   eval      F8PGM = '(PGM: MBDCP8)'
      *
     C                   Z-ADD     0             @A                2 0
     C                   DO        @SIZI
     C                   ADD       1             @A
     C     #H1(@A)       MULT      100           NUM6              6 0
     C                   ADD       #H2(@A)       NUM6
     C                   ENDDO
      *
     C                   WRITE     MBDWPP81
      *
     C                   ENDSR
      *----------------------------------------------------*
      * HEADER YEAR-MONTH
      *----------------------------------------------------*
     C     #HDR2         BEGSR
      *
     C                   Z-ADD     *ZERO         @A                2 0
     C                   MOVEL     'QTY_'        #QTY              4
     C                   MOVEL     'BOX_'        #BOX              4
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
     C     #QTY          CAT       #YYMM         F8Q(@A)
     C     #BOX          CAT       #YYMM         F8B(@A)
      *
     C                   ENDDO
      *
     C                   ENDSR
      *----------------------------------------------------*
      * SET DETAIL QTY/BOX/
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
     C                   MOVEL     F3Q(@A)       F8Q(@A)
      *
     C     @QPC          IFEQ      0
     C                   MOVEL     '0'           F8B(@A)
     C                   ELSE
     C     F3Q(@A)       DIV       @QPC          NUM50             5 0
     C                   MVR                     REM               5 3
     C                   IF        REM > 0
     C                   ADD       1             NUM50
     C                   ENDIF
     C                   MOVEL     NUM50         F8B(@A)
     C                   ADD       NUM50         @BOX
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR

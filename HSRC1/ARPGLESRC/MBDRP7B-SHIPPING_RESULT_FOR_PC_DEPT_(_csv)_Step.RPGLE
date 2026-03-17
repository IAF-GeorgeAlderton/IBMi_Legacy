     H DATEDIT(*YMD/)
     F** MBDRP7B *******************************************
     F*  SHIPPING RESULT FOR PC DEPT (Step 2)              *
     *** CAUTION !!! COMPLIE WITH RPGLE (not RPG3) ***    *
     F*  jw1      2020.04.17 CHG APLC11 --> UTLC11         *
     F******************************************************
     FMBDPL11   IF   E           K DISK
     FFCEPL01   IF   E           K DISK
     FAAMPL11   IF   E           K DISK
     FMBDWPP7   O    E             DISK
      *****************************************************************
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
      *MBDWPP71 (QTY)
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
      *MBDWPP71 (BOX)
     D                 DS
     D F5B                     1    240    DIM(24)
     D F5BX01                  1     10
     D F5BX02                 11     20
     D F5BX03                 21     30
     D F5BX04                 31     40
     D F5BX05                 41     50
     D F5BX06                 51     60
     D F5BX07                 61     70
     D F5BX08                 71     80
     D F5BX09                 81     90
     D F5BX10                 91    100
     D F5BX11                101    110
     D F5BX12                111    120
     D F5BX13                121    130
     D F5BX14                131    140
     D F5BX15                141    150
     D F5BX16                151    160
     D F5BX17                161    170
     D F5BX18                171    180
     D F5BX19                181    190
     D F5BX20                191    200
     D F5BX21                201    210
     D F5BX22                211    220
     D F5BX23                221    230
     D F5BX24                231    240
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
      * OUTPUT AB#WPT3
     C                   XFOOT     F3Q           F3QT99            8 0
     C                   MOVEL     F3QT99        F5QT99
      * GET FCEPP INFO.
     C                   EXSR      #FCEP
     C                   EXSR      #DTL2
     C                   MOVEL     @BOX          F5BX99
     C                   WRITE     MBDWPP71
     C                   ADD       1             RCNT              6 0
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
     C                   CLEAR                   MBDWPP71
jw1  C                   z-add     0             F3Q
     C                   Z-ADD     0             @BOX
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
     C                   MOVEL     A2SSYS        F5QPC
     C                   Z-ADD     A2SSYS        @QPC              6 0
      *MONTHLY SET
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
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *          PROCESS (SUMMARIZE BY PART, YEAR)
      *****************************************************************
     C     #PROC         BEGSR
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
     C                   PARM                    P@NKOJ            1
     C                   PARM                    P@NUKE            4
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
     C                   MOVEL     P@NKOJ        @NKOJ             1
     C                   MOVEL     P@NUKE        @NUKE             4
     C                   MOVEL     P@YYYY        @YYYY             4 0
     C                   MOVEL     P@MM          @MM               2 0
     C                   CLEAR                   MBDWPP71
     C                   MOVEL     'Y'           FIRST             1
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
     C                   CLEAR                   MBDWPP71
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
     C                   CLEAR                   MBDWPP71
      *
     C                   MOVEL     'CUST#'       F5TOKU
     C                   MOVEL     'DELIV#'      F5NONY
     C                   MOVEL     'NAME   '     F5TONM
     C                   MOVEL     'FACTORY'     F5NKOJ
     C                   MOVEL     'DOCK'        F5NUKE
     C                   MOVEL     'USR_PART'    F5MHIN
     C                   MOVEL     'IAF_PART'    F5SHIN
     C                   MOVEL     'MONTH_SET'   F5MSET
      *
     C                   EXSR      #HDR2
      *
     C                   MOVEL     'QTY_TTL'     F5QT99
     C                   MOVEL     'BOX_TTL'     F5BX99
      *
     C                   MOVEL     'QTY/CNT'     F5QPC
JW4  C                   MOVEL     'SORT   '     F5SORT
JW4  C                   MOVEL     'LAST_LOC'    F5LLOC
JW5  C                   MOVEL     'RCV_POINT'   F5UKER
JW5  C                   eval      F5PGM = '(PGM: MBDCP7B)'
      *
     C                   WRITE     MBDWPP71
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
     C     #BOX          CAT       #YYMM         F5B(@A)
      *
     C                   ENDDO
      *
     C                   ENDSR
      *----------------------------------------------------*
      * SET DETAIL QTY
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
     C     @QPC          IFEQ      0
     C                   MOVEL     '0'           F5B(@A)
     C                   ELSE
     C     F3Q(@A)       DIV       @QPC          NUM50             5 0
     C                   MOVEL     NUM50         F5B(@A)
     C                   ADD       NUM50         @BOX
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR

     H DATEDIT(*YMD.)
     F** VRFR44 ****************************************************
     F*  REFORMATION FOR STAPP10/20                                *
     F*  T-SAKAKI    CRT 2020.03.24                                *
     F*  ----------------------------------                        *
     F*  * ADD VRFR44  TO UTLC20                                   *
     F*  * ADD STAPP10 BY OPT#1 (FILE REFORMATION MASTER UPDATE)   *
     F**************************************************************
     FSTAPP10   UF   E             DISK    INFDS(INF1)
     FSTAPP20   UF   E             DISK
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
      *
     D                 DS
     D  S1BARC                 1     20
     D  S1IKBN                 1      1
     D  S1PAGT                 8      8
     D  S1PROC                 9     11
     D  S1PAGI                12     14
     D  S1WKBN                14     14
      ***************************************************
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
      ***************************************************
      *
     C                   MOVE      PDATE         XDATE             8 0
      *
      *--------------------------------------------
      *  STAPP10
      *--------------------------------------------
     C     1             SETLL     STAPP10
      * LOOP
     C                   DO        *HIVAL
     C                   READ      STAPP10                                91
     C   91              LEAVE
      *
     C     S1KOHZ        IFLE      XDATE
      *
     C                   SELECT
     C*---------------------------------------
      * PT/BPT KANBAN -  AFTER STORE IN
     C*---------------------------------------
     C     S1IKBN        WHENEQ    'I'
     C     S1TUHK        IFNE      0
     C                   ITER
     C                   ENDIF
     C*---------------------------------------
     C*   PLASTIC
     C*---------------------------------------
     C     S1IKBN        WHENEQ    'A'
     C     S1IKBN        OREQ      'R'
     C*  A888899X01050C. <- IF "X" IS DIGIT , NORMAL KANBAN
     C     S1PAGT        IFGE      '0'
     C     S1PAGT        ANDLE     '9'
     C                   ITER
     C*  A888899X01050C. <- IF "X" IS NOT DIGIT, TEMP KANBAN
     C                   ELSE
     C     S1TUHK        IFNE      0
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*---------------------------------------
     C*   INTRA / WASHER
     C*---------------------------------------
     C     S1IKBN        WHENGE    '0'
     C     S1IKBN        ANDLE     '9'
      *   INTRA
     C     S1WKBN        IFNE      *BLANK
     C                   MOVE      S1PAGI        W1PAGI            3 0
     C*  IF PAGE NO IS LESS THAN 300, NORMAL KANBAN
     C     W1PAGI        IFLT      300
     C                   ITER
     C*  IF PAGE NO IS 300 OR MORE, TEMP KANBAN
     C                   ELSE
     C     S1TUHK        IFNE      0
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*---------------------------------------
     C                   ENDSL
      *
     C                   ADD       1             WDEL              9 0
     C                   DELETE    STAPP101
      *
     C                   ENDIF
      *
     C                   ENDDO
      *--------------------------------------------
      *  STAPP20
      *--------------------------------------------
     C     1             SETLL     STAPP20
      * LOOP
     C                   DO        *HIVAL
     C                   READ      STAPP20                                91
     C   91              LEAVE
      *
     C     S2CRHZ        IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   DELETE    STAPP201
     C                   ENDIF
      *
     C                   ENDDO
      *--------------------------------------------
      *
      * FOOT
     C                   Z-ADD     RCNT          WREC1             9 0
     C                   MOVE      WREC1         PREC1
     C     WREC1         SUB       WDEL          WREC2             9 0
     C                   MOVE      WREC2         PREC2
      *
      *--------------------------------------------
     C                   MOVE      *ON           *INLR
     C                   RETURN

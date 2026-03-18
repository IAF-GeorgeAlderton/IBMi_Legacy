00000 *******************************************************************
00000 *         WRITTEN BY    M. FIORILLO                               *
00000*         DATE:         10/01/01                                  *
00000 *         USAGE   :     USER-DEFINED SEU LINE COMMANDS            *
00000 *******************************************************************
00000 * ATRXXXX COMMANDS PLACE HEXADECIMAL ATTRIBUTES ON RPG/COBOL      *
00000 *  COMMENT LINES, OR ANY LINES IN TXT MEMBERS.                     *"
00000 * USABLE COMMANDS ARE                                             *
00000 *                                                                 *
00000 * COMMAND  EFFECT             ATTRIBUTE                           *
00000 * ATRNAT   NATURAL COLOR      X'20'                               *
00000 * ATRNATR  NATURAL REVERSE    X'21'                               *
00000 * ATRWHT   WHITE              X'22'                               *
00000 * ATRWHTR  WHITE REVERSE      X'23'                               *
00000 * ATRRED   RED                X'28'                               *
00000 * ATRREDR  RED REVERSE        X'29'                               *
00000 *   ATRTRQ   TURQUOISE          X'30'                               *
00000 * ATRTRQR  TURQUOISE REVERSE  X'31'                               *
00000 * ATRYEL   YELLOW             X'32'                               *
00000 * ATRYELR  YELLOW REVERSE     X'33'                               *
00000 * ATRLLC   LILAC              X'38'                               *
00000 * ATRLLCR  LILAC REVERSE      X'39'                               *
00000 * ATR      NO SPECIAL         X'40' (BLANK)                       *
00000 *                                                                 *
00000 *  IN ADDITION, THE COMMAND ATRNN MAY BE USED, WHERE 'NN'          *"
00000 * IS A HEXADECIMAL NUMBER BETWEEN X'20' AND X'40' INCLUSIVE.      *
00000 *                                                                   *
00000 *  IF A BLOCK COMMAND EFFECT IS DESIRED, THE ATR COMMAND MAY       *"
00000 * BE PLACED ON THE FIRST AND LAST LINES OF THE BLOCK.  NOTE:      *
00000 * USE OF THE COMMAND LINE TO GO TO TOP ('T') OR BOTTOM ('B')      *
00000 * WILL NOT WORK WITH BLOCK COMMANDS.  PAGE UP OR DOWN WILL        *
00000 * WORK WITH BLOCK COMMANDS.  THE FIRST AND LAST ATRXXX COMMAND    *
00000 * MUST USE THE SAME ATTRIBUTES IN ORDER TO BE TREATED AS A        *
00000 * BLOCK COMMAND (E.G. BOTH MAY BE ATRRED).                        *
00000 *                                                                 *
00000 *   NOTE: THIS INITIALLY WORKS ONLY FOR RPG SOURCE MEMBERS.         *
00000 *  NOTE: ONLY COMMENT LINES ('*' IN COLUMN 7, BLANK COLUMN 6)      *"
00000 * WILL BE UPDATED.                                                *
00000 *                                                                 *
00000 * ADDITIONAL COMMANDS (10/04/01)                                  *
00000 * THE CMTOUT COMMAND LOOKS FOR RPG LINES CONTAINING A NON-        *
00000 * BLANK CHARACTER IN COLUMN 6 AND AN ASTERISK IN COLUMN           *
00000 *  7, AND PLACES A RED (X'28') BYTE IN COLUMN 8.  IF COLUMN        *"
00000 *  8 IS NON-BLANK, THE LINE STARTING WITH COLUMN 8 IS SHIFTED      *"
00000 * RIGHT ONE POSITION (THE EXISTING LAST BYTE IS LOST).            *
00000 *                                                                 *
00000 *   THE LOWER COMMAND CONVERTS AN ENTIRE LINE TO LOWERCASE.         *
00000 *                                                                 *
00000 * THE CAPS COMMAND CONVERTS AN ENTIRE LINE BY CHANGING THE        *
00000 * FIRST CHARACTER OF EACH WORD TO UPPERCASE.                      *
00000 *                                                                 *
00000 *******************************************************************
00000 *                    C H A N G E   L O G                          *
00000 *    DATE    USER ID   | EXPLANATION                              *
00000 *  10/03/01  M. FIORILLO SUPPORT COBOL WITH * OR / IN COLUMN 7    *
00000 *   10/03/01  M. FIORILLO SUPPORT TXT MEMBERS, ATTRIBUTE COLUMN 1  *"
00000 *   10/03/01  M. FIORILLO SUPPORT NEW COMMANDS CMTOUT, LOWER, AND  *"
00000 *                        CAPS.                                    *
00000 *******************************************************************
00000 *
00000 **********************************************************************
00000 * INPUT PARAMETERS (POINTERS TO USER SPACE FROM SEU)
00000 **********************************************************************
00000 *
00000D P1@             S               *
00000D P2@             S               *
00000D P3@             S               *
00000 *
00000 **********************************************************************
00000 * DATA STRUCTURES
00000 **********************************************************************
00000 *
00000 * DATA STRUCTURE -- INPUT INFORMATION FROM SEU
00000D HEDINF          DS                  BASED(P1@)
00000D   HRLEN                 1      4B 0
00000D   HCRRN                 5      8B 0
00000D   HCPOS                 9     12B 0
00000D   HCCSID               13     16B 0
00000D   HRECI                17     20B 0
00000D   HMNAM                21     30
00000D   HFNAM                31     40
00000D   HLNAM                41     50
00000D   HMTYP                51     60
00000D   HFKEY                61     61
00000D   HMODE                62     62
00000D   HSSES                63     63
00000D   HRSV1                64     64
00000
00000 *・ DATA STRUCTURE FOR RETURN INFO TO SEU
00000D RETINF          DS                  BASED(P2@)
00000D   RRETC                 1      1
00000D   RRSV2                 2      4
00000D   RRECO                 5      8B 0
00000D   RSEQN                 9     15
00000D   RRSV3                16     37
00000 *"*  RETURN CODES - 0=ALL DATA PROCESSED, SEU UPDATES SOURCE."
00000 *"*  RETURN CODES - 1=ALL DATA PROCESSED, NO SOURCE UPDATE"
00000 *"*  RETURN CODES - 2=DATA PROCESSED, SOME LINE COMMANDS UNRESOLVED"
00000 * RETURN CODES - 3=NO DATA PROCESSED.
00000
00000 * DATA STRUCTURE FOR LINE DATA FROM SEU
00000D LININF          DS                  BASED(P3@)
00000D   LCMD                  1      7
00000D   LRET                  8      8
00000D   LINPSEQ               9     14
00000D   LCHGDT               15     20
00000D   LTXT1                21    256
00000
00000 * MESSAGE API DATA STRUCTURE
00000 * THIS DATA STRUCTURE IS NOT USED HERE BUT SUPPORTS FUTURE USE OF MESSAG
00000D                 DS
00000D   MSGID                 1      7    INZ('       ')
00000D   MSGF                  8     27    INZ('USRMSGF   USRLIB    ')
00000D   MSGDTA               28     28    INZ(' ')
00000D   MSGLEN               29     32B 0 INZ(1)
00000D   MSGTYP               33     42    INZ('*INFO')
00000D   MSGENT               43     52    INZ('*')
00000D   MSGCNT               53     56B 0 INZ(2)
00000D   MSGKEY               57     60
00000D   MSGERR               61     84
00000
00000 **********************************************************************
00000 * CONSTANTS
00000 **********************************************************************
00000
00000D RESET           C                    X'40'
00000D NATURAL         C                    X'20'
00000D NATURAL_RVS     C                    X'21'
00000D WHITE           C                    X'22'
00000D WHITE_RVS       C                    X'23'
00000D RED             C                    X'28'
00000D RED_RVS         C                    X'29'
00000D TURQ            C                    X'30'
00000D TURQ_RVS        C                    X'31'
00000D YELLOW          C                    X'32'
00000D YELLOW_RVS      C                    X'33'
00000D LILAC           C                    X'38'
00000D LILAC_RVS       C                    X'39'
00000D UPR             C                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
00000D LWR             C                    'abcdefghijklmnopqrstuvwxyx'
00000
00000 **********************************************************************
00000 * WORKING VARIABLES
00000 **********************************************************************
00000
00000D*・HR3            S              3
00000D CHR2            S              2
00000D CHRWRK          S              1
00000D COLM1           S              1
00000D COLM6           S              1
00000D COLM7           S              1
00000D COLM8           S              1
00000D COLUMN          S              2  0
00000D LCMDSV          S                   LIKE(LCMD)
00000D LOOP            S              4  0 INZ(1)
00000D LTXTWRK         S            +20    LIKE(LININF)
00000D NDX             S              3  0
00000D PX@             S               *
00000D SRCTYPE         S              3
00000
00000 **********************************************************************
00000 * ENTRY PARAMETERS
00000 **********************************************************************
00000
00000C     *ENTRY        PLIST
00000C                   PARM                    P1@
00000C                   PARM                    P2@
00000C                   PARM                    P3@
00000
00000 **********************************************************************
00000 * MAINLINE PROGRAM
00000 **********************************************************************
00000
00000C                   EVAL      SRCTYPE = %SUBST(HMTYP:1:3)
00000C                   IF        HFKEY = '0'
00000C                             AND (SRCTYPE = 'RPG' OR SRCTYPE = 'CBL'
00000C                                  OR SRCTYPE = 'TXT')
00000C                   EXSR      @REPLCT
00000C                   EVAL      LOOP = 1
00000C                   EVAL      COLUMN = 6
00000C                   IF        SRCTYPE = 'TXT'
00000C                   EVAL      COLUMN = 1
00000C                   ENDIF
00000C                   IF        HMODE = 'U'
00000C                   IF        HCPOS = 0
00000C                   EVAL      HCPOS = 1
00000C                   ENDIF
00000C                   DOU       LOOP = HRECI
00000C                   EVAL      COLM1 = %SUBST(LTXT1:1:1)
00000C                   EVAL      COLM6 = %SUBST(LTXT1:6:1)
00000C                   EVAL      COLM7 = %SUBST(LTXT1:7:1)
00000C                   SELECT
00000C                   WHEN      %SUBST(LCMD:1:3) = 'ATR'
00000C                   EXSR      @ATR
00000C                   WHEN      %SUBST(LCMD:1:6) = 'CMTOUT'
00000C                   EXSR      @CMTOUT
00000C                   WHEN      %SUBST(LCMD:1:4) = 'CAPS'
00000C                             AND %SUBST(LCMD:5:1) <> 'L'
00000C                   EXSR      @CAPS
00000C                   WHEN      %SUBST(LCMD:1:5) = 'CAPSL'
00000C                   EXSR      @CAPSL
00000C                   WHEN      %SUBST(LCMD:1:5) = 'LOWER'
00000C                             AND %SUBST(LCMD:6:1) <> 'L'
00000C                             AND %SUBST(LCMD:6:1) <> '6'
00000C                             AND %SUBST(LCMD:6:1) <> 'C'
00000C                   EXSR      @LOWER
00000C                   WHEN      %SUBST(LCMD:1:6) = 'LOWERL'
00000C                   EXSR      @LOWERL
00000C                   WHEN      %SUBST(LCMD:1:6) = 'LOWER6'
00000C                   EXSR      @LOWER6
00000C                   WHEN      %SUBST(LCMD:1:6) = 'LOWERC'
00000C                   EXSR      @LOWERC
00000C                   WHEN      %SUBST(LCMD:1:5) = 'UPPER'
00000C                             AND %SUBST(LCMD:6:1) <> 'L'
00000C                             AND %SUBST(LCMD:6:1) <> '6'
00000C                             AND %SUBST(LCMD:6:1) <> 'C'
00000C                   EXSR      @UPPER
00000C                   WHEN      %SUBST(LCMD:1:6) = 'UPPERL'
00000C                   EXSR      @UPPERL
00000C                   WHEN      %SUBST(LCMD:1:6) = 'UPPER6'
00000C                   EXSR      @UPPER6
00000C                   WHEN      %SUBST(LCMD:1:6) = 'UPPERC'
00000C                   EXSR      @UPPERC
00000C                   ENDSL
00000C                   EVAL      LCMD  = *BLANKS
00000C                   EVAL      LOOP = LOOP + 1
00000C                   EVAL      P3@ = P3@ + HRLEN + 20
00000C                   EVAL      RRECO = HRECI - 1
00000C                   ENDDO
00000C                   ENDIF
00000C                   ENDIF
00000C                   EXSR      @EXIT
00000
00000 **********************************************************************
00000 **     SUBROUTINES  **                                              **
00000 **********************************************************************
00000
00000 **********************************************************************
00000 *      REPLICATE ALL LINES FOR BLOCK COMMAND
00000 **********************************************************************
00000C     @REPLCT       BEGSR
00000C                   EVAL      PX@ = P3@
00000C                   EVAL      LCMDSV = LCMD
00000C                   EVAL      P3@ = P3@ + ( (HRLEN + 20) * (HRECI - 2) )
00000C                   IF        LCMD = LCMDSV
00000C                   EVAL      LOOP  = 1
00000C                   EVAL      P3@  = PX@
00000C                   DOU       LOOP  = HRECI
00000C                   EVAL      LCMD = LCMDSV
00000C                   EVAL      LOOP  = LOOP  + 1
00000C                   EVAL      P3@ = P3@ + HRLEN + 20
00000C                   ENDDO
00000C                   ENDIF
00000C                   EVAL      P3@ = PX@
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *      PROCESS ATRXXX COMMANDS
00000 **********************************************************************
00000C     @ATR          BEGSR
00000C                   EVAL      COLM1 = %SUBST(LTXT1:1:1)
00000C                   EVAL      COLM6 = %SUBST(LTXT1:6:1)
00000C                   EVAL      COLM7 = %SUBST(LTXT1:7:1)
00000C                   IF        COLM6 <= X'40'
00000C                             AND (
00000C                                  COLM7  = '*'
00000C                                  OR (COLM7 = '/' AND SRCTYPE = 'CBL')
00000C                                  )
00000C                             OR (SRCTYPE = 'TXT' AND COLM1 <= X'40')
00000C                   SELECT
00000C                   WHEN      LCMD = 'ATR    '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = RESET
00000C                   WHEN      LCMD = 'ATRNAT '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = NATURAL
00000C                   WHEN      LCMD = 'ATRNATR'
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = NATURAL_RVS
00000C                   WHEN      LCMD = 'ATRWHT '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = WHITE
00000C                   WHEN      LCMD = 'ATRWHTR'
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = WHITE_RVS
00000C                   WHEN      LCMD = 'ATRRED '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = RED
00000C                   WHEN      LCMD = 'ATRREDR'
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = RED_RVS
00000C                   WHEN      LCMD = 'ATRTRQ '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = TURQ
00000C                   WHEN      LCMD = 'ATRTRQR'
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = TURQ_RVS
00000C                   WHEN      LCMD = 'ATRYEL '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = YELLOW
00000C                   WHEN      LCMD = 'ATRYELR'
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = YELLOW_RVS
00000C                   WHEN      LCMD = 'ATRLLC '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = LILAC
00000C                   WHEN      LCMD = 'ATRLLCR'
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = LILAC_RVS
00000C                   WHEN      LCMD = 'ATR20  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'20'
00000C                   WHEN      LCMD = 'ATR21  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'21'
00000C                   WHEN      LCMD = 'ATR22  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'22'
00000C                   WHEN      LCMD = 'ATR23  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'23'
00000C                   WHEN      LCMD = 'ATR24  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'24'
00000C                   WHEN      LCMD = 'ATR25  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'25'
00000C                   WHEN      LCMD = 'ATR26  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'26'
00000C                   WHEN      LCMD = 'ATR27  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'27'
00000C                   WHEN      LCMD = 'ATR28  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'28'
00000C                   WHEN      LCMD = 'ATR29  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'29'
00000C                   WHEN      LCMD = 'ATR2A  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'2A'
00000C                   WHEN      LCMD = 'ATR2B  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'2B'
00000C                   WHEN      LCMD = 'ATR2C  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'2C'
00000C                   WHEN      LCMD = 'ATR2D  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'2D'
00000C                   WHEN      LCMD = 'ATR2E  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'2E'
00000C                   WHEN      LCMD = 'ATR2F  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'2F'
00000C                   WHEN      LCMD = 'ATR30  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'30'
00000C                   WHEN      LCMD = 'ATR31  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'31'
00000C                   WHEN      LCMD = 'ATR32  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'32'
00000C                   WHEN      LCMD = 'ATR33  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'33'
00000C                   WHEN      LCMD = 'ATR34  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'34'
00000C                   WHEN      LCMD = 'ATR35  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'35'
00000C                   WHEN      LCMD = 'ATR36  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'36'
00000C                   WHEN      LCMD = 'ATR37  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'37'
00000C                   WHEN      LCMD = 'ATR38  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'38'
00000C                   WHEN      LCMD = 'ATR39  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'39'
00000C                   WHEN      LCMD = 'ATR3A  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'3A'
00000C                   WHEN      LCMD = 'ATR3B  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'3B'
00000C                   WHEN      LCMD = 'ATR3C  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'3C'
00000C                   WHEN      LCMD = 'ATR3D  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'3D'
00000C                   WHEN      LCMD = 'ATR3E  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'3E'
00000C                   WHEN      LCMD = 'ATR3F  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'3F'
00000C                   WHEN      LCMD = 'ATR40  '
00000C                   EVAL      %SUBST(LTXT1:COLUMN:1) = X'40'
00000C                   ENDSL
00000C                   ENDIF
00000C                   EXSR      @RTNCD
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    COMMENT-OUT PROCESSOR
00000 **********************************************************************
00000C     @CMTOUT       BEGSR
00000C                   EVAL      COLM8 = %SUBST(LTXT1:8:1)
00000C                   IF        (SRCTYPE = 'RPG' OR SRCTYPE = 'CBL')
00000C                             AND COLM6 > X'40'
00000C                             AND COLM7 = '*'
00000C                             AND LCMD  = 'CMTOUT'
00000C                   IF        COLM8 >  X'40'
00000C                   EVAL      %SUBST(LTXT1:9:(HRLEN - 9) )
00000C                             = %SUBST(LTXT1:8:HRLEN - 8)
00000C                   ENDIF
00000C                   EVAL      %SUBST(LTXT1:8:1) = X'28'
00000C                   EXSR      @RTNCD
00000C                   ENDIF
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    CAPS-ON-FIRST-LETTER (RIGHT OF CURSOR POSITION)
00000 **********************************************************************
00000C     @CAPS         BEGSR
00000C*                  EVAL      NDX = 1
00000C                   EVAL      NDX = HCPOS
00000C*・                DOU       NDX = (HRLEN - 2)
00000C*・                EVAL      CHR3 = %SUBST(LTXT1:NDX:3)
00000C                   DOU       NDX >= (HRLEN)
00000C                   EVAL      CHR2 = %SUBST(LTXT1:NDX:2)
00000C*・                EVAL      CHRWRK = %SUBST(CHR3:1:1)
00000C                   EVAL      CHRWRK = %SUBST(CHR2:1:1)
00000C     CHRWRK        SCAN      LWR
00000C                   IF        NOT %FOUND
00000C     CHRWRK        SCAN      UPR
00000C                   ENDIF
00000C*・                EVAL      CHRWRK = %SUBST(CHR3:2:1)
00000C                   EVAL      CHRWRK = %SUBST(CHR2:2:1)
00000C                   IF        (NOT %FOUND OR CHRWRK <= X'40')
00000C*・                          AND %SUBST(CHR3:3:1) > *BLANK
00000C     LWR:UPR       XLATE     CHRWRK        CHRWRK
00000C                   EVAL      %SUBST(LTXT1:(NDX + 1):1) = CHRWRK
00000C                   ENDIF
00000C                   EVAL      NDX = NDX + 1
00000C                   ENDDO
00000C                   EXSR      @RTNCD
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    CAPS-ON-FIRST-LETTER (LEFT OF CURSOR POSITION)
00000 **********************************************************************
00000C     @CAPSL        BEGSR
00000C                   EVAL      NDX = 1
00000C                   DOW       NDX <= (HCPOS)
00000C                   EVAL      CHR2 = %SUBST(LTXT1:NDX:2)
00000
00000C                   EVAL      CHRWRK = %SUBST(CHR2:1:1)
00000C     CHRWRK        SCAN      LWR
00000C                   IF        NOT %FOUND
00000C     CHRWRK        SCAN      UPR
00000C                   ENDIF
00000C                   EVAL      CHRWRK = %SUBST(CHR2:2:1)
00000C                   IF        (NOT %FOUND OR CHRWRK <= X'40')
00000C*・*                          AND %SUBST(CHR2:2:1) > *BLANK
00000C     LWR:UPR       XLATE     CHRWRK        CHRWRK
00000C                   EVAL      %SUBST(LTXT1:(NDX + 1):1) = CHRWRK
00000C                   ENDIF
00000C                   EVAL      NDX = NDX + 1
00000C                   ENDDO
00000C                   EXSR      @RTNCD
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    LOWER-CASE LINE (RIGHT OF CURSOR POSITION)
00000 **********************************************************************
00000C     @LOWER        BEGSR
00000C*・                EVAL      LTXTWRK = %SUBST(LTXT1:1:(HRLEN))
00000C                   EVAL      LTXTWRK = %SUBST(LTXT1:HCPOS:(HRLEN-HCPOS+1))
00000C     UPR:LWR       XLATE     LTXTWRK       LTXTWRK
00000C*・                EVAL      %SUBST(LTXT1:1:(HRLEN)) = LTXTWRK
00000C                   EVAL      %SUBST(LTXT1:HCPOS:(HRLEN-HCPOS+1)) = LTXTWRK
00000C                   EXSR      @RTNCD
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    LOWER-CASE LINE (LEFT OF CURSOR POSITION
00000 **********************************************************************
00000C     @LOWERL       BEGSR
00000C                   EVAL      LTXTWRK = %SUBST(LTXT1:1:(HCPOS-1))
00000C     UPR:LWR       XLATE     LTXTWRK       LTXTWRK
00000C                   EVAL      %SUBST(LTXT1:1:(HCPOS-1)) = LTXTWRK
00000C                   EXSR      @RTNCD
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    LOWER-CASE COLUMN 6 (RPG FORM TYPE)
00000 **********************************************************************
00000C     @LOWER6       BEGSR
00000C                   EVAL      LTXTWRK = %SUBST(LTXT1:6:1)
00000C     UPR:LWR       XLATE     LTXTWRK       LTXTWRK
00000C                   EVAL      %SUBST(LTXT1:6:1) = LTXTWRK
00000C                   EXSR      @RTNCD
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    LOWER-CASE COLUMN AT CURSOR POSITION
00000 **********************************************************************
00000C     @LOWERC       BEGSR
00000C                   EVAL      LTXTWRK = %SUBST(LTXT1:HCPOS:1)
00000C     UPR:LWR       XLATE     LTXTWRK       LTXTWRK
00000C                   EVAL      %SUBST(LTXT1:HCPOS:1) = LTXTWRK
00000C                   EXSR      @RTNCD
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    UPPER-CASE LINE (RIGHT OF CURSOR POSITION)
00000 **********************************************************************
00000C     @UPPER        BEGSR
00000C*・                EVAL      LTXTWRK = %SUBST(LTXT1:1:(HRLEN))
00000C                   EVAL      LTXTWRK = %SUBST(LTXT1:HCPOS:(HRLEN-HCPOS+1))
00000C     LWR:UPR       XLATE     LTXTWRK       LTXTWRK
00000C*・                EVAL      %SUBST(LTXT1:1:(HRLEN)) = LTXTWRK
00000C                   EVAL      %SUBST(LTXT1:HCPOS:(HRLEN-HCPOS+1)) = LTXTWRK
00000C                   EXSR      @RTNCD
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    UPPER-CASE LINE (LEFT OF CURSOR POSITION
00000 **********************************************************************
00000C     @UPPERL       BEGSR
00000C                   EVAL      LTXTWRK = %SUBST(LTXT1:1:(HCPOS-1))
00000C     LWR:UPR       XLATE     LTXTWRK       LTXTWRK
00000C                   EVAL      %SUBST(LTXT1:1:(HCPOS-1)) = LTXTWRK
00000C                   EXSR      @RTNCD
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    UPPER-CASE COLUMN 6 (RPG FORM TYPE)
00000 **********************************************************************
00000C     @UPPER6       BEGSR
00000C                   EVAL      LTXTWRK = %SUBST(LTXT1:6:1)
00000C     LWR:UPR       XLATE     LTXTWRK       LTXTWRK
00000C                   EVAL      %SUBST(LTXT1:6:1) = LTXTWRK
00000C                   EXSR      @RTNCD
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    UPPER-CASE COLUMN AT CURSOR POSITION
00000 **********************************************************************
00000C     @UPPERC       BEGSR
00000C                   EVAL      LTXTWRK = %SUBST(LTXT1:HCPOS:1)
00000C     LWR:UPR       XLATE     LTXTWRK       LTXTWRK
00000C                   EVAL      %SUBST(LTXT1:HCPOS:1) = LTXTWRK
00000C                   EXSR      @RTNCD
00000C                   ENDSR
00000
00000 **********************************************************************
00000 *    SEND MESSAGE API
00000 **********************************************************************
00000 * THIS SUBROUTINE IS NOT USED HERE BUT SUPPORTS FUTURE USE OF MESSAGING
00000C     SNDMSG        BEGSR
00000C                   CALL      'QMHSNDPM'
00000C                   PARM                    MSGID
00000C                   PARM                    MSGF
00000C                   PARM                    MSGDTA
00000C                   PARM                    MSGLEN
00000C                   PARM                    MSGTYP
00000C                   PARM                    MSGENT
00000C                   PARM                    MSGCNT
00000C                   PARM                    MSGKEY
00000C                   PARM                    MSGERR
00000C                   ENDSR
00000 *
00000 **********************************************************************
00000 * SET RETURN CODE
00000 **********************************************************************
00000C     @RTNCD        BEGSR
00000C                   EVAL      RSEQN = '0AAAAAA'
00000C                   EVAL      RRETC = '0'
00000C                   ENDSR
00000 **********************************************************************
00000 * EXIT
00000 **********************************************************************
00000C     @EXIT         BEGSR
00000C                   EVAL      *INLR = *ON
00000C                   RETURN
00000C                   ENDSR

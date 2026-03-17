      *   PROGRAM UXDBG1R -- ELEMENT LEVEL USER EXIT FOR DEBUGGING ASSISTANCE
      *   FILE UXDBGCTL CONSISTS OF TWO FIELDS -- TYPE (ALPHA- 1 BYTE) AND LOC (
      *   TYPE IS EITHER  "C" FOR CONSTANT, "A" FOR ACCUMULATOR, OR "H" FOR HASH
      *   LOC IS THE ITEM NUMBER (EXAMPLE FOR CONSTANT-13, LOC = 13)
      *   THESE RECORDS SHOULD BE ADDED TO UXDBGCTL USING DFU OR A THIRD-PARTY U
      *   THEY WILL CONTROL THE OUTPUT.  FOR EXAMPLE, TO HAVE THE CONTENTS PRINT
      *   CONSTANT-12, CONSTANT-18, ACCUMULATOR-06, AND HASH-TOTAL-07, THERE SHO
      *   RECORDS IN UXDBGCTL AS FOLLOWS:
      *   TYPE      LOC
      *   =====     =====
      *     C        12
      *     C        18
      *     A        06
      *     H        07
      *
      *   THESE FOUR RECORDS SHOULD BE THE ONLY RECORDS IN UXDBGCTL.  THE DATA P
      *   FOR THE ELEMENT CONTAINING THE USER EXIT WILL BE PRINTED FIRST, FOLLOW
      *   CONSTANTS, ACCUMULATORS, AND HASH TOTALS AS DEFINED BY UXDBGCTL.
      *   THIS PROGRAM PRODUCES POORLY FORMATTED OUTPUT (NO PAGE BREAK LOGIC IS
      *   INTENDED TO PRODUCE OUTPUT THAT WILL BE VIEWED IN SPOOL FILES, AND NOT
      *
     FUXDBGCTL  IF   E             DISK
     FQSYSPRT   O    F  132        PRINTER
      *
      *   VARIABLE DATA COMMUNICATED BETWEEN GENTRAN AND USER EXIT VIA EXIT BLOC
     DEXIT             DS
      *  OPT INDICATES WHERE USER EXIT EXECUTES - S = START OF PROCESS,
      *                                           P = ELEMENT LEVEL
      *                                           E = END OF PROCESS
     DOPT                      1      1
      *  USRARA IS 80-BYTES NOT USED BY GENTRAN, CAN BE USED TO
      *  COMMUNICATE BETWEEN USER EXITS
     DUSRARA                   2     81
      *  EXTFLD IS 80 BYTES BEING MAPPED, CAN BE CHANGED BY PROGRAM
     DEXTFLD                  82    161
      *  FLDLNG IS THE LENGTH OF EDI DATA TO BE MAPPED
     DFLDLNG                 162    163B 0
      *  FLDMIN IS THE MINIMUM LENGTH OF FIELD BEING MAPPED, PER STANDARDS
     DFLDMIN                 164    165B 0
      *  FLDMAX IS THE MAXIMUM LENGTH OF FIELD BEING MAPPED, PER STANDARDS
     DFLDMAX                 166    167B 0
      *  FLDTYP IS DATA TYPE (AN, S0, CY, ETC.)
     DFLDTYP                 168    169
     D*ARRAY                    1    256
      *
      *   ARRAYS PASSED BY GENTRAN IN EXIT BLOCK
      *   CON = ARRAY OF 99 CONSTANTS
     DCON              S             80    DIM(99)
      *   HSH = ARRAY OF 80 HASH-TOTALS (6 DECIMAL PLACES)
     DHSH              S             18  6 DIM(80)
      *   ACC = ARRAY OF 80 ACCUMULATORS
     DACC              S             18  0 DIM(80)
      *
      *
     DWRK              S              1    DIM(80)
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    EXTBLK          169
     C                   PARM                    CON
     C                   PARM                    HSH
     C                   PARM                    ACC
      *
     C                   MOVEL     EXTBLK        EXIT
     C                   MOVEA     EXTFLD        WRK
     C                   EXCEPT    INPUT
     C     1             SETLL     UXDBGCTL
     C                   READ      UXDBGCTL                               51
     C                   DOW       *IN51 = *OFF
     C                   SELECT
     C                   WHEN      TYPE = 'C'
     C                   MOVEL(P)  CON(LOC)      CONSTNT          80
     C                   EXCEPT    CONST
     C                   WHEN      TYPE = 'A'
     C                   MOVEL(P)  ACC(LOC)      ACCUMLT          18 0
     C                   EXCEPT    ACCUM
     C                   WHEN      TYPE = 'H'
     C                   MOVEL(P)  HSH(LOC)      HASHTTL          18 6
     C                   EXCEPT    HASHT
     C                   ENDSL
     C                   READ      UXDBGCTL                               51
     C                   ENDDO
     C                   MOVEL     EXIT          EXTBLK
     C                   MOVEL     *ON           *INRT
      * THIS USER EXIT SHOULD BE USED IN BATCH RUNS ONLY.  IF INTERACTIVE, NO *I
      *  IS SET ON, AND SPOOL FILE WILL NOT CLOSE UNTIL EOJ.
      *
     OQSYSPRT   E            INPUT          1
     O                                           24 '------------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O          E            INPUT          1
     O                                           10 'INPUT    ='
     O                       WRK                 92
     OQSYSPRT   E            HASHT          1
     O                                            4 'HSH '
     O                       LOC                  8 ' 0'
     O                                           10 ' ='
     O                       HASHTTL             30
     OQSYSPRT   E            CONST          1
     O                                            4 'CST '
     O                       LOC                  8 ' 0'
     O                                           10 ' ='
     O                       CONSTNT             92
     OQSYSPRT   E            ACCUM          1
     O                                            4 'ACC '
     O                       LOC                  8 ' 0'
     O                                           10 ' ='
     O                       ACCUMLT             30

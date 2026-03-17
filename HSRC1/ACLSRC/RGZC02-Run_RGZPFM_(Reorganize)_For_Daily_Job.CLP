             PGM        PARM(&PGM)
             /** RGZC02 **********************************************/
             /*  RUN RGZPFM (REORGANIZE)                             */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  J.WATANAE  2019.03.25                               */
             /********************************************************/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1 )

 /* SET PROGRAM NAME */
             IF         COND(&PGM *EQ ' ') THEN(DO)
             CHGVAR     VAR(&PGM ) VALUE('RGZC02    ')
             ENDDO

 /* 1. REORGANIZE GDGPP10 DAYLY ORDER DATA BEFOR ADD --- */
             CHGVAR     VAR(&LIB ) VALUE('HFILE1    ')

             CHGVAR     VAR(&FILE) VALUE('GDGPP10   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 2. REORGANIZE GCQPP31 DIE ALLOTMENT M/F ------------ */
             CHGVAR     VAR(&FILE) VALUE('GCQPP31   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 3. REORGANIZE MBDPP11 SALES RESULT DATA BY YEAR ---- */
             CHGVAR     VAR(&FILE) VALUE('MBDPP11   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 4. REORGANIZE MBDPP01 SALES RESULT DATA BY YEAR ---- */
             CHGVAR     VAR(&FILE) VALUE('MBDPP01   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 5. REORGANIZE ABBPP90 DAYLY INVENTORY FILE --------- */
             CHGVAR     VAR(&FILE) VALUE('ABBPP90   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 6. REORGANIZE AH#PP70 YELLOW/ORANGE FLAG FILE ------ */
             CHGVAR     VAR(&FILE) VALUE('AH#PP70   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 7. REORGANIZE AH#PP11 FIXED ORDER DATA ACCUMULATION (KANBAN) -- */
             CHGVAR     VAR(&FILE) VALUE('AH#PP11   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 8. REORGANIZE ABF2P01 EDI862 FORD DATA  ------------ */
             CHGVAR     VAR(&FILE) VALUE('ABF2P01   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 9. REORGANIZE AB#PPA1 IAF FIXED ORDER DATA --------- */
             CHGVAR     VAR(&FILE) VALUE('AB#PPA1   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 10. REORGANIZE ABBPP9A FLAG INVENTORY FILE  --------- */
             CHGVAR     VAR(&FILE) VALUE('ABBPP9A   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 11. REORGANIZE FCCPP11 KANBAN M/F  ------------------ */
             CHGVAR     VAR(&FILE) VALUE('FCCPP11   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 12. REORGANIZE ABBPP01 FORECAST ACCUM FILE ---------- */
             CHGVAR     VAR(&FILE) VALUE('ABBPP01   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

 /* 13. REORGANIZE INVPP41 (HWFILE1) -------------------- */
             CHGVAR     VAR(&FILE) VALUE('INVPP41   ')
             CHGVAR     VAR(&LIB ) VALUE('HWFILE1   ')
             CALL       PGM(UTLR63) PARM(&FILE &RTN)
             IF         COND(&RTN *EQ 'Y') THEN(DO)
             CALL       PGM(RGZC01) PARM(&FILE &LIB &PGM)
             ENDDO

             ENDPGM

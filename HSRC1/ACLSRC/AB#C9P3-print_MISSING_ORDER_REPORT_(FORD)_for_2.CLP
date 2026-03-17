/** AB#C9P3 ***********************************************/
/*  PRINT FORD MISSING ORDER REPORT FOR 2 NEXT DAYS       */
/*  RUNS IN VJBC73 (1:03PM EVERY DAY)                     */
/*  J.WATANABE  2026.02.19                                */
/**********************************************************/
             PGM        PARM(&SDATE)

             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DT8  ) TYPE(*CHAR) LEN(8)

/* DEFAULT DATE */
             IF         (&SDATE *EQ ' ') THEN(DO)
             CALL       PGM(UTLR02T) PARM(&DT8)
             CHGVAR     VAR(&SDATE) VALUE(&DT8)
             ENDDO

/* AB#C9P3ODAY(N)'S ORDER */
             CALL       PGM(AB#C9P) PARM(&SDATE)

/* CHECK (N+1)'S ORDER */
             CALL       PGM(UTLR10) PARM(&SDATE '+' '0001' 'N' &DT8 ' ')
             CHGVAR     VAR(&SDATE) VALUE(&DT8)
             CALL       PGM(AB#C9P) PARM(&SDATE)

/* CHECK (N+2)'S ORDER */
             CALL       PGM(UTLR10) PARM(&SDATE '+' '0001' 'N' &DT8 ' ')
             CHGVAR     VAR(&SDATE) VALUE(&DT8)
             CALL       PGM(AB#C9P) PARM(&SDATE)

             ENDPGM

             PGM
/** ABFCE3 ************************************************/
/*  FORD 5 DAYS EDI ORDERS                                */
/*  JW    2022.07.07                                      */
/**********************************************************/
             DCL        VAR(&F05 ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SDAT) TYPE(*CHAR) LEN(8)

             DCL        VAR(&PSYYY) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&PSMMM) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&PSDDD) TYPE(*DEC) LEN(2 0)

             CHGVAR     VAR(&F05  ) VALUE('Y')
             CHGVAR     VAR(&PSYYY) VALUE(2026)
             CHGVAR     VAR(&PSMMM) VALUE(02)
             CHGVAR     VAR(&PSDDD) VALUE(06)

/* "5 DAYS ORDER" REPORT  */
             IF         COND(&F05 *EQ 'Y') THEN(DO)
             CALL       PGM(UTLR02T) PARM(&PDAT)
             CALL       PGM(UTLR02M) PARM(&PSYYY &PSMMM &PSDDD &SDAT)
             CALL       PGM(ABFCE3 ) PARM(&SDAT &PDAT)
             ENDDO

             ENDPGM

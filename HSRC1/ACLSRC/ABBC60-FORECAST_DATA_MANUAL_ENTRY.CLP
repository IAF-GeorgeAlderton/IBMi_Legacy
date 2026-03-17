             PGM
/** ABBC60 ************************************************/
/*  FORECAST DATA MANUAL ENTRY                            */
/*  .CALL ABBC61                                          */
/*   PGM CALL - ABACJ1,ABBCJ1                             */
/*   I-HASADA                                             */
/*   2001.04.02                                           */
/*                                                        */
/* TCHK1 06/12/09 ADD TEMPORARY CHANGE CALENDAR M/F       */
/************************************************ ABBC60 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)

/* TCHK1 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK1 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK1 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&PYM) VALUE(%SST(&ABADS1 1 6))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ABBR60) PARM(&USER)

             IF         (%SWITCH(1XXXXXXX)) DO
             CALL       PGM(ABBC61) PARM(&PYM)
             ENDDO

             ENDPGM

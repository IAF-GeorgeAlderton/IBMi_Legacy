             PGM
             /** FCCC20 ************************************/
             /* KANBAN M/F                                 */
             /*                                            */
             /*  DATE (CODING):K.OKACHI        1997.10.16  */
             /************************************ FCCC20 **/
             DCL        VAR(&REC) TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)


             RTVJOBA    JOB(&WSID)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGVAR     VAR(&PM) VALUE(%SST(&ABADS1 5 2))
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(FCCR20) PARM(&PM)

             ENDPGM

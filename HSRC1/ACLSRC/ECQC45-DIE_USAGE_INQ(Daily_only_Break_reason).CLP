             PGM
/** ECQC45 ************************************************/
/*  DIE USAGE INQUIRY(DAILY ONLY + BREAK REASON)          */
/*                                                        */
/* TCHK  06/24/11 CREATE(COPY FROM ECQC15)                */
/**********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ECQR45)

             ENDPGM

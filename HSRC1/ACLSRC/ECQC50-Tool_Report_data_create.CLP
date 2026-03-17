 PGM
/** ECQC50 ************************************************/
/* TOOL REPORT DATA CREATE                                */
/*                                                        */
/* TCHK1 05/22/09 CRATE(COPY FROM ECSC30)                 */
/**********************************************************/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CLRPFM     FILE(HWFILE1/ECQWP50)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ECQR50)

             ENDPGM

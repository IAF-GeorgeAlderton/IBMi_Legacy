             PGM
/** FEAC41 *************************************************/
/*  COMPONENTS INFORMATION MASTER INQUIRY                  */
/*          M-OKUDA      1984.12.27                        */
/* TCHK1 07/17/09 CREATE(CONVERT ASJ SOURCE(FEAC41)        */
/***********************************************************/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7) VALUE('QPRINT ')
             RTVJOBA    JOB(&WS) USER(&US)
             CALL       PGM(DGAR00) PARM(&WS &PRT)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) OUTQ(&PRT) +
                          FORMTYPE(K6H1)
             CALL       PGM(FEAR41)
             DLTOVR     FILE(QPRINT)
             ENDPGM

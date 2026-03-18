             PGM        PARM(&RDAT &SDAT)
             /** AB#CFMP *********************************/
             /*  PRINT ADD-ON SHEETS                     */
             /*  JW    2026.03.18                        */
             /********************************************/
/* PROCESS DATE */  DCL        VAR(&RDAT)  TYPE(*CHAR) LEN(8)
/* SHIP DATE    */  DCL        VAR(&SDAT)  TYPE(*CHAR) LEN(8)
                    DCL        VAR(&TODAY) TYPE(*CHAR) LEN(8)
/* GET TODAY */
             CALL       PGM(UTLR02T) PARM((&TODAY))

/* ADD ON LIST  */
             OVRPRTF    FILE(QPRINT) OUTQ(WATAOUTQ) HOLD(*YES)
             OVRPRTF    FILE(QPRINT2) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(WATAOUTQ) FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(AB#RFMP) PARM(&RDAT &SDAT &TODAY)

             ENDPGM

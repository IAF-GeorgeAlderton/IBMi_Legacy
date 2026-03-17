             PGM        PARM(&RDAT &SDAT &TODAY)
             /** AB#CFMP *********************************/
             /*  PRINT ADD-ON SHEETS                     */
             /********************************************/
             DCL        VAR(&RDAT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SDAT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TODAY) TYPE(*CHAR) LEN(8)

/* RE-CREATE FRS(NIRVANA) */

             OVRPRTF    FILE(QPRINT) OUTQ(WATAOUTQ) HOLD(*YES)
             OVRPRTF    FILE(QPRINT2) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(WATAOUTQ) FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(AB#RFMP) PARM(&RDAT &SDAT &TODAY)

 END:        ENDPGM

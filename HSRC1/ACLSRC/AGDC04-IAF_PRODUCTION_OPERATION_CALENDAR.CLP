             PGM        PARM(&NO1 &NO2)
             /** AGDC04 ************************/
             /* IAF PRODUCTION PLACE OPERATION CALENDAR */
             /*                   -LIST CREATE - */
             /*        S.YAMAGAMI 91.01.07 */
             /********************** AGDC04 ****/
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NO1)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&NO2)  TYPE(*CHAR) LEN(1)
             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WS)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)

             CALL       PGM(AGDR04) PARM(&NO1 &NO2)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM

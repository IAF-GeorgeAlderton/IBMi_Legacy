             PGM
             /** AB#CS1 ***************************************/
             /*  SERVICE PARTS NON RESULT                     */
             /*                                               */
             /*************************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WS) USER(&USER)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) LPI(6) OVRFLW(65) +
                          RPLUNPRT(*YES) OUTQ(QPRINTC) +
                          FORMTYPE(K6H1)
             CALL       PGM(AB#RS1)

              ENDPGM

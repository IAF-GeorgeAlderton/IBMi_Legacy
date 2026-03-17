             PGM
             /** AJEC11 ******************************/
             /*  MENU ACCOUNT BOOK BY  PROGRAM       */
             /*  USING DEPARTMENT UNIT               */
             /* I-HASADA                88.11.18     */
             /****************************** AJEC11 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WS)

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6S1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AJER11)
             DLTOVR     FILE(QPRINT)

 END:        ENDPGM

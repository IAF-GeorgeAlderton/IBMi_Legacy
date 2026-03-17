             PGM
             /***MBDC13********************************************/
             /* RECEIVING CO. ORDER DELIVERY STATISTICAL LIST. */
             /*            A-SANGA 1981.11.13                     */
             /*****************************************************/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&US)
             CHGJOB     RUNPTY(40)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             DLTF       FILE(MBDWP13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MBDWP13) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRPRTF    FILE(QPRINT) TOFILE(*FILE) PAGESIZE(66 132) +
                          LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(QDKT) FORMTYPE(K6H1) COPIES(1) +
                          HOLD(*YES) IGCDTA(&PIGCD)
             CALL       PGM(MBDR13)
             DLTOVR     FILE(QPRINT)

             CHGJOB     RUNPTY(20)

             ENDPGM

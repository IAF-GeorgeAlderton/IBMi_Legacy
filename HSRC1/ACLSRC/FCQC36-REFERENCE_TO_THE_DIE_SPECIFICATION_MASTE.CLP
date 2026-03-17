             PGM
             /** FCQC36 ****************************/
             /*..REFERENCE TO THE DIE SPECIFICATION MASTER..*/
             /*     I-HASADA          94.07.04     */
             /**************************** FCQC36 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))

             CHGVAR     VAR(&FILE1) VALUE('FCQWP36' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('FCQWP35' *CAT &WS)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE1) RCDLEN(250) +
                          OPTION(*NOLIST) SIZE(10000 5000 2) +
                          LVLCHK(*NO)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE2) RCDLEN(250) +
                          OPTION(*NOLIST) SIZE(10000 5000 2) +
                          LVLCHK(*NO)

             OVRDBF     FILE(FCQWP36) TOFILE(&FILE1)
             CALL       PGM(FCQR36) PARM(&USER)
             DLTOVR     FILE(*ALL)

             DLTF       FILE(&FILE1)
             DLTF       FILE(&FILE2)

             ENDPGM

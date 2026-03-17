             PGM
             /*** AAGC01 ***************************************/
             /*   TUNNEL KANBAN M/F UPDATE                     */
             /*          H.ITO            86.09.18             */
             /*************************************** AAGC01 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(5)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE) VALUE('AAG' *CAT &WS)

             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE) RCDLEN(300) TEXT('TUNNEL +
                          KANBAN UPDATE M/F DATA') OPTION(*NOLIST) +
                          SIZE(2000) LVLCHK(*NO) AUT(*ALL)

             CHGJOB     OUTQ(&PRTG)
             OVRDBF     FILE(OUTPUT) TOFILE(&FILE)
             CALL       PGM(AAGR01) PARM(&USER &FILE)
             DLTOVR     FILE(OUTPUT)
             DLTF       FILE(&FILE)

             ENDPGM

             PGM
             /***AAFC01 ****************************************/
             /* PLATING KANBAN M/F UPDATE */
             /* H.ITO                           86.09.18       */
             /*************************************** AAFC01 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE) VALUE('AAF' *CAT &WS)

             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE) RCDLEN(300) +
                          TEXT('PLATING KANBAN UPDATE M/F DATA') +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)

             CHGJOB     OUTQ(&PRTG)
             OVRDBF     FILE(OUTPUT) TOFILE(&FILE)
             CALL       PGM(AAFR01) PARM(&USER &FILE)
             DLTOVR     FILE(OUTPUT)
             DLTF       FILE(&FILE)

             ENDPGM

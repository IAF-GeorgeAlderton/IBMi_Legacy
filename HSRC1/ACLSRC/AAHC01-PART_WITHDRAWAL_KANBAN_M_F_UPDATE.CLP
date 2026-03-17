             PGM
             /*** AAHC01 ***********************************/
             /* PART WITHDRAWAL KANBAN M/F UPDATE */
             /*            H.ITO          86.10.07         */
             /*********************************** AAHC01 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)
           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE) VALUE('AAH' *CAT &WS)

             DLTF       FILE(&WLIB/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE) RCDLEN(300) +
                          TEXT('PICK-UP KANBAN UPDATE M/F DATA') +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)

             CHGJOB     OUTQ(&PRTG)
             OVRDBF     FILE(OUTPUT) TOFILE(&WLIB/&FILE)
             CALL       PGM(AAHR01) PARM(&USER &FILE)
             DLTOVR     FILE(OUTPUT)
             DLTF       FILE(&FILE)

             ENDPGM

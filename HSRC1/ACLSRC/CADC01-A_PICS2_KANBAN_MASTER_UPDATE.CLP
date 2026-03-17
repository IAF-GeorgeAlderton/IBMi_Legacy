             PGM
             /** CADC01 ****************************/
             /*  .A-PICS2 KANBAN MASTER UPDATE ..  */
             /*     T-SAKAKI        2020.03.10     */
             /**************************** CADC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE) VALUE('CAD' *CAT &WS)
             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE) RCDLEN(300) +
                        OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                        AUT(*ALL)
             OVRDBF     FILE(OUTPUT) TOFILE(&FILE)

             CALL       PGM(CADR01) PARM(&USER &FILE)

             ENDPGM

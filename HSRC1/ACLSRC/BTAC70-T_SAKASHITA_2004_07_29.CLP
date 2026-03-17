             PGM       PARM(&PSYS)
             /** BTAC70 ********************/
             /* T.SAKASHITA 2004.07.29     */
             /******************** BTAC70 **/
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&FILE) VALUE('BTAWP62' *CAT &PSYS)
             DLTF       FILE(HWFILE1/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE) RCDLEN(1) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             ENDPGM

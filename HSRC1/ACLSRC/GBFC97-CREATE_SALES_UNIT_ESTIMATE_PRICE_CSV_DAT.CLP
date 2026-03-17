             PGM
             /** GBFC97 **************************************/
             /*  ..トヨタ自動車見積りデータ　エクセル化..  */
             /*       I-HASADA                99.02.04       */
             /************************************** GBFC97 **/

             CLRPFM     FILE(GBFWP98)

             DLTF       FILE(GBFWP97)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GBFWP97) RCDLEN(2048) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(GBFR97)

             ENDPGM

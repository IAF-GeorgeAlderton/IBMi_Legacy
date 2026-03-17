             PGM        PARM(&AYM)
             /*** ABAC77 ***************************************/
             /* 削除された内示データ異常変動リスト           */
             /*         A.INOUE             1998.03.28         */
             /*************************************** ABAC77 ***/
             DCL        VAR(&AYM) TYPE(*CHAR) LEN(4)
             DLTF       FILE(ABAWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(APWRKLIB/ABAWP32) RCDLEN(32) +
                          OPTION(*NOLIST) SIZE(30000 30000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(ABAR77) PARM(&AYM)
             CALL       PGM(ABAC75)
             DLTF       FILE(ABAWP32)

             ENDPGM

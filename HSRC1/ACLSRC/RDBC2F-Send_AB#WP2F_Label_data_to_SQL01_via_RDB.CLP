             PGM        PARM(&MBR &DTTM)

             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTTM) TYPE(*CHAR) LEN(20)

 /*  override to the correct file member...                 */
             OVRDBF     FILE(AB#WP2F) TOFILE(AB#WP2F) MBR(&MBR)
             MONMSG     MSGID(CPF0000)

 /*  send label data AB#WP2F to SQL01 via rdb connect       */
             CALL       PGM(RDBR2F) PARM(&DTTM)

             ENDPGM

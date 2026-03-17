             PGM        PARM(&MBR &DTTM)

             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTTM) TYPE(*CHAR) LEN(20)

 /*  override to the correct file member...                 */
             OVRDBF     FILE(AB#WP43) TOFILE(AB#WP43) MBR(&MBR)
             MONMSG     MSGID(CPF0000)

 /*  send Subaru manifest data to SQL01 via rdb connect     */
             CALL       PGM(RDBR25) PARM(&DTTM)

             ENDPGM

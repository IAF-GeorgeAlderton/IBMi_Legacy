             PGM        PARM(&MBR &DTTM)

             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTTM) TYPE(*CHAR) LEN(20)

 /*  override to the correct file member...                 */
             OVRDBF     FILE(AB#WP2I) TOFILE(AB#WP2I) MBR(&MBR)
             MONMSG     MSGID(CPF0000)

 /*  send AIAG label data to SQL01 via rdb connect          */
             CALL       PGM(RDBR24) PARM(&DTTM)

             ENDPGM

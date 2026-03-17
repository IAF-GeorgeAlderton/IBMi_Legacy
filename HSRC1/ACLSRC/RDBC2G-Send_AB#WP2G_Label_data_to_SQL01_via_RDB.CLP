             PGM        PARM(&MBR &DTTM)

             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTTM) TYPE(*CHAR) LEN(20)

             IF         COND(&DTTM *EQ '  ') THEN(DO)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&DTTM)
                                             ENDDO

 /*  override to the correct file member...                 */
             OVRDBF     FILE(AB#WP2G) TOFILE(AB#WP2G) MBR(&MBR)
             MONMSG     MSGID(CPF0000)

 /*  send label data AB#WP2G to SQL01 via rdb connect       */
             CALL       PGM(RDBR2G) PARM(&DTTM)

             ENDPGM

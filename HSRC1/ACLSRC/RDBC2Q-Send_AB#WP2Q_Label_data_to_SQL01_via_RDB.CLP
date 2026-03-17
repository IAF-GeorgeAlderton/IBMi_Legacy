             PGM        PARM(&DTTM)

             DCL        VAR(&DTTM) TYPE(*CHAR) LEN(20)

             IF         COND(&DTTM *EQ '  ') THEN(DO)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&DTTM)
                                             ENDDO

 /*  send label data AB#WP2Q to SQL01 via rdb connect       */
             CALL       PGM(RDBR2Q) PARM(&DTTM)

             ENDPGM

             PGM        PARM(&KEY)

             DCL        VAR(&KEY) TYPE(*CHAR) LEN(10)

             IF         COND(&KEY = ' ') THEN(DO)
             CALL       PGM(CHKC27)
             GOTO       CMDLBL(ENDP)
             ENDDO

             CALL       PGM(CHKR27) PARM(&KEY)

ENDP:        ENDPGM

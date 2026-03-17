             PGM

             DCL        VAR(&USRC) TYPE(*CHAR) LEN(6)

             CALL       PGM(MRHR75) PARM(&USRC)

             IF         COND(&USRC *EQ ' ') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

             CALL       PGM(CA#RC1) PARM(&USRC)


@END:
             ENDPGM

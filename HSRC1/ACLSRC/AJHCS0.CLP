             PGM

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(AJHRS0)

             IF         COND(&USER *EQ 'L') THEN(DO)
             SIGNOFF
             ENDDO

             ENDPGM

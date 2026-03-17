             PGM

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(AJHRS6) PARM('JC ')

             IF         COND(&USER *EQ 'L') THEN(DO)
             SIGNOFF
             ENDDO

             ENDPGM

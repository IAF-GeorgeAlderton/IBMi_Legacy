             PGM        PARM(&NONY)

             DCL        VAR(&NONY )    TYPE(*CHAR) LEN(4)
             DCL        VAR(&ADR1 )    TYPE(*CHAR) LEN(50)
             DCL        VAR(&ADR2 )    TYPE(*CHAR) LEN(50)
             DCL        VAR(&ADR3 )    TYPE(*CHAR) LEN(50)
             DCL        VAR(&ADR4 )    TYPE(*CHAR) LEN(50)
             DCL        VAR(&ADR5 )    TYPE(*CHAR) LEN(50)
             DCL        VAR(&ADR6 )    TYPE(*CHAR) LEN(50)
             DCL        VAR(&SKJY )    TYPE(*CHAR) LEN(1)

             CALL       PGM(AB#R2C2) PARM(&NONY &ADR1 &ADR2 &ADR3 +
                          &ADR4 &ADR5 &ADR6 &SKJY)

             ENDPGM

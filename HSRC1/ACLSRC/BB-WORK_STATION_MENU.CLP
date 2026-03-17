             PGM

             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PROF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HIZK) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSNO) USER(&PROF) NBR(&JOBN) DATE(&HIZK)

                        CALL PGM(DGAC91)

             ENDPGM

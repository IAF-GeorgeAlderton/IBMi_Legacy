             PGM

             DCL        VAR(&STAR) TYPE(*CHAR) LEN(1)

             OVRDBF     FILE(AB#WP90) TOFILE(TWFILE1/AB#WP90)

             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) OUTQ(EPRINT1) +
                          FORMTYPE(K6H1) HOLD(*YES) SAVE(*YES)

             CALL       PGM(AB#R1M )

             ENDPGM

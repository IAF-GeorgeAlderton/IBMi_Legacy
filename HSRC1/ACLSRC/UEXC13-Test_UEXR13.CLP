             PGM

             DCLF       FILE(UEXPW13)

             DCL        VAR(&QR) TYPE(*CHAR) LEN(512)
             DCL        VAR(&QR1) TYPE(*CHAR) LEN(256)
             DCL        VAR(&QR2) TYPE(*CHAR) LEN(256)
             DCL        VAR(&BAR) TYPE(*CHAR) LEN(20)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR ) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USR)

             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             CHGVAR     VAR(&QR1) VALUE(%SUBSTRING(&QR 1 256))
             CHGVAR     VAR(&QR2) VALUE(%SUBSTRING(&QR 257 256))

             CALL       PGM(UEXR13) PARM(&QR1 &QR2 &BAR)

ENDPGM:
             ENDPGM

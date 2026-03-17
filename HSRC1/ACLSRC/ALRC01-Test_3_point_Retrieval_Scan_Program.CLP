             PGM
             /** ALRC01 **********************************/

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6) VALUE('999999')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10) VALUE('QPGMR')

             CALL       PGM(ALRR01) PARM(&WKCD &USER)

             SIGNOFF

             ENDPGM

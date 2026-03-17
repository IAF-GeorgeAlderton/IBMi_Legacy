             PGM
             /** ABBC34 ********************************/
             /*  TEST ABBR34                           */
             /******************************************/

             DCL        VAR(&TOKU) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHIN) TYPE(*CHAR) LEN(20)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&TOKU) VALUE('5444')
             CHGVAR     VAR(&NONY) VALUE('5445')
             CHGVAR     VAR(&NKOJ) VALUE('0')
             CHGVAR     VAR(&NUKE) VALUE('00  ')
             CHGVAR     VAR(&MHIN) VALUE('82174      ')

             CALL       PGM(ABBR34) PARM(&TOKU &NONY &NKOJ &NUKE &MHIN &RTN)

             ENDPGM

             PGM
             /** UEXC50  **********************************************/
             /*  TEST UEXR50                                          */
             /*-------------------------------------------------------*/
             DCL        VAR(&TOKU ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHN1 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN2 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN3 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN4 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&QTY  ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1) VALUE(' ')

             CHGVAR     VAR(&TOKU) VALUE('0987')
             CHGVAR     VAR(&NONY) VALUE('0987')
             CHGVAR     VAR(&NKOJ) VALUE('0')
             CHGVAR     VAR(&NUKE) VALUE('00  ')
             CHGVAR     VAR(&MHN1) VALUE('45798')
             CHGVAR     VAR(&MHN2) VALUE('81013')
             CHGVAR     VAR(&MHN3) VALUE('0    ')
             CHGVAR     VAR(&MHN4) VALUE('     ')
             CHGVAR     VAR(&DATE) VALUE('202309')
             CHGVAR     VAR(&QTY ) VALUE('000099999')

             CALL       PGM(UEXR50) PARM(&TOKU &NONY &NKOJ &NUKE +
                          &MHN1 &MHN2 &MHN3 &MHN4 &DATE &QTY &RTN)

             ENDPGM

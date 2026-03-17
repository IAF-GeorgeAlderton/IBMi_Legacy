             PGM
 /*  **************************************************    */
 /*    TEST REFR01B                                        */
 /*  **************************************************    */
             DCL        VAR(&P1) TYPE(*CHAR) LEN( 5)
             DCL        VAR(&P2) TYPE(*CHAR) LEN( 6)
             DCL        VAR(&P3) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&P4) TYPE(*CHAR) LEN( 8)
             DCL        VAR(&P5) TYPE(*CHAR) LEN(20)
             DCL        VAR(&P6) TYPE(*CHAR) LEN( 4)
             DCL        VAR(&P7) TYPE(*CHAR) LEN( 2)
             DCL        VAR(&P8) TYPE(*CHAR) LEN( 2)
             DCL        VAR(&P9) TYPE(*CHAR) LEN(16)
             DCL        VAR(&QR) TYPE(*CHAR) LEN(150)

             CHGVAR     VAR(&P1) VALUE('ASBQR')
             CHGVAR     VAR(&P2) VALUE('3557')
             CHGVAR     VAR(&P3) VALUE('347151')
             CHGVAR     VAR(&P4) VALUE('00428130')
             CHGVAR     VAR(&P5) VALUE('991351-80618')
             CHGVAR     VAR(&P6) VALUE('2025')
             CHGVAR     VAR(&P7) VALUE('9')
             CHGVAR     VAR(&P8) VALUE(' ')
             CHGVAR     VAR(&P9) VALUE('214613-1584-23')

        CALL PGM(REFR01B) PARM(&P1 &P2 &P3 &P4 &P5 &P6 &P7 &P8 &P9 &QR)

             ENDPGM

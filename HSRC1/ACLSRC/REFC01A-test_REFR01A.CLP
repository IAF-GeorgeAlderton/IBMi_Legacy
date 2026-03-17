             PGM
 /*  **************************************************    */
 /*    TEST REFR01A                                        */
 /*  **************************************************    */
             DCL        VAR(&P1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&P3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&P4) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P5) TYPE(*CHAR) LEN(22)
             DCL        VAR(&P6) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P7) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P8) TYPE(*CHAR) LEN(16)
             DCL        VAR(&QR) TYPE(*CHAR) LEN(150)

             CHGVAR     VAR(&P1) VALUE('ASBQR')
             CHGVAR     VAR(&P2) VALUE('C710')
             CHGVAR     VAR(&P3) VALUE('0904-1')
             CHGVAR     VAR(&P4) VALUE('00054909')
             CHGVAR     VAR(&P5) VALUE('9010506A067')
             CHGVAR     VAR(&P6) VALUE('00002000')
             CHGVAR     VAR(&P7) VALUE(' ')
             CHGVAR     VAR(&P8) VALUE('GBH8730')

        CALL PGM(REFR01A) PARM(&P1 &P2 &P3 &P4 &P5 &P6 &P7 &P8 &QR)

             ENDPGM

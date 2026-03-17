             PGM
             /** ABAC1B  *************************************/
             /*  TEST ABAR1B                                 */
             /*  JW   2025.12.09                             */
             /************************************************/

             DCL        VAR(&DAT6) TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&DAT6) VALUE('202512')

             OVRDBF     FILE(ABAEP25) TOFILE(TFILE1/ABAEP25)
             OVRDBF     FILE(ABAWP25) TOFILE(TWFILE1/ABAWP25)

             CALL       PGM(ABAR1B) PARM(&DAT6)

             ENDPGM

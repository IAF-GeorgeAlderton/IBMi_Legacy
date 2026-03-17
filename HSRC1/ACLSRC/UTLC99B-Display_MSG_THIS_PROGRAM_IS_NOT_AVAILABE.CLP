             PGM        PARM(&PGM)
             /*= UTLC99B ==============================================*/
             /*  DISPLAY MESSAGE - "THIS PROGRAM IS NOT AVAILABEL."    */
             /*  JW      2023.06.29                                    */
             /*========================================================*/
             DCLF       FILE(UTLPW99 )
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&XLIN1) +
                        VALUE('THIS PROGRAM IS NOT AVAILABLE.')

             CHGVAR     VAR(&XLIN2) VALUE(&PGM)

             SNDRCVF    RCDFMT(DSP01)

             ENDPGM

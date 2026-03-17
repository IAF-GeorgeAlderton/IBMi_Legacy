             PGM
             /** ABBC10 *****************************************/
             /*  (MONTH END JOB)                                */
             /*  SAVE FORECAST DATA TO LIBRARY:BACKUP           */
             /*  J.WATANABE  2018.05.18                         */
             /***************************************************/
             DCL        VAR(&YYM) TYPE(*CHAR) LEN(3)
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TO ) TYPE(*CHAR) LEN(10)

             CALL       UTLR22 (&YYM &END)

/* MONTH END? */
             IF         COND(&END = 'Y') THEN(DO)
             CHGVAR     VAR(&TO) VALUE('ABBPP01' *CAT &YYM)
             CPYF       FROMFILE(HFILE1/ABBPP01) TOFILE(BACKUP/&TO) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

             CHGVAR     VAR(&TO) VALUE('ABBPP50' *CAT &YYM)
             CPYF       FROMFILE(HFILE1/ABBPP50) TOFILE(BACKUP/&TO) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

             CHGVAR     VAR(&TO) VALUE('ABBPP60' *CAT &YYM)
             CPYF       FROMFILE(HFILE1/ABBPP60) TOFILE(BACKUP/&TO) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             ENDDO

             ENDPGM

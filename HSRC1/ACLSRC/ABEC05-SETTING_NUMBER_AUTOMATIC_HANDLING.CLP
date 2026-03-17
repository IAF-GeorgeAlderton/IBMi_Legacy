             PGM        PARM(&PKBN &PYM &HIZK &PCD &PCD1 &PCD2 &PCD3 +
                          &PCD4 &PLIST &PKHIN &PKOTI &PKBMN &PNTKR +
                          &PKBMK &PKANB)
             /** ABEC05 **************************/
             /*SETTING NUMBER AUTOMATIC HANDLING  */
             /*   COMPONENTS KANBAN INCREASE AND DECREASE HANDLING */
             /* I-HASADA            92.10.06     */
             /************************** ABEC05 **/
             DCL        VAR(&PKBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HIZK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD1) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD2) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD4) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PLIST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKHIN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&PKOTI) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PKBMN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNTKR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PKBMK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKANB) TYPE(*CHAR) LEN(1)

             CLRPFM     FILE(ABEWP04)
             CLRPFM     FILE(ABEWP05)

             CALL       PGM(ABER05) PARM(&PYM &HIZK &PKHIN &PKOTI +
                          &PKBMN &PNTKR &PKBMK)

             CALL       PGM(ABER06) PARM(&PKBN &PCD &PCD1 &PCD2 +
                          &PCD3 &PCD4 &PLIST &PKANB)

             ENDPGM

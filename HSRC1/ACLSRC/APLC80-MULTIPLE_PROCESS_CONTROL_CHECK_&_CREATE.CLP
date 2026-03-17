             PGM        PARM(&PIPGMN &POWSID &POUSID &POKONA &POSTTS)
     /*= APLC80 ===============================================*/
     /*  MULTIPLE PROCESS CONTROL  CHECK & CREATE              */
     /*       T.SAKAKI    2016.11.04                           */
     /*========================================================*/
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POWSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)

             CALL       PGM(APLR80) PARM(&PIPGMN &POWSID &POUSID +
                          &POKONA &POSTTS)

          IF         COND(&POSTTS *EQ '2') THEN(DO)
             CHGVAR     VAR(&PMSG) VALUE(&POUSID *TCAT ' ' *TCAT +
                          &POKONA *TCAT ' IS USING AT ' *CAT +
                          &POWSID *TCAT '* NOW. PLEASE TRY AGAIN +
                          LATER.')
             CALL       PGM(QUILNGTX) PARM(&PMSG X'00000046' '       +
                          ' '                    ' X'00000000')
          ENDDO

END:
             ENDPGM

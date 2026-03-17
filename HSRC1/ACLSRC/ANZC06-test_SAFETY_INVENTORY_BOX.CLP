             PGM
/** ANZC06 ************************************************/
/*  TEST SAFETY INVENTORY BOX                             */
/*                                                        */
/*  JW   2018.12.21                                       */
/**********************************************************/
             DCL        VAR(&LOC1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LOC2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LOC3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LOC4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&YY  ) TYPE(*DEC ) LEN(4 0)
             DCL        VAR(&MM  ) TYPE(*DEC ) LEN(2 0)
             DCL        VAR(&DD  ) TYPE(*DEC ) LEN(2 0)
             DCL        VAR(&BIN ) TYPE(*DEC ) LEN(2 0)
             DCL        VAR(&BOX ) TYPE(*DEC ) LEN(4 0)

             CHGVAR     VAR(&LOC1) VALUE('0')
             CHGVAR     VAR(&LOC2) VALUE('48')
             CHGVAR     VAR(&LOC3) VALUE('24')
             CHGVAR     VAR(&LOC4) VALUE('0')
             CHGVAR     VAR(&YY  ) VALUE(2018)
             CHGVAR     VAR(&MM  ) VALUE(12)
             CHGVAR     VAR(&DD  ) VALUE(21)
             CHGVAR     VAR(&BIN ) VALUE(01)

             CALL       PGM(ANZR06) PARM(&LOC1 &LOC2 &LOC3 &LOC4 &YY +
                          &MM &DD &BIN &BOX)

             ENDPGM

             PGM
             /** KB#C08 *********************************************/
             /* ...VA.VEDATA 13MONTH DATE QUANTITY ... */
             /* I-HASADA                               87.02.05     */
             /********************************************* KB#C08 **/
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)

             CHGVAR     VAR(&PYM) VALUE(%SUBSTRING(&MCEDP01 1 6))
             CALL       PGM(KB#R08) PARM(&PYM)

             ENDPGM

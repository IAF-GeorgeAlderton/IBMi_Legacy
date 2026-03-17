             PGM
             /** NBGC11 **************************************/
             /* THE PURCHASING OLD & NEW DIE ACTUAL ACCUMULATION DATA CREATE */
             /* I-HASADA                      92.05.25       */
             /************************************** NBGC11 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             RTVJOBA    USER(&USER)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)

             CHGVAR     VAR(&PYM) VALUE(%SUBSTRING(&MCEDP01 1 6))
             CALL       PGM(NBGR11) PARM(&USER &PYM)

             ENDPGM

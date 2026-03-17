             PGM        PARM(&PYM)
             /** ABBC61 ************************************/
             /* ..FROM USER PRODUCT DEMAND FORECAST DATA.. */
             /* ..FORECAST DATA INPUT                      */
             /* ..PGM CALL - ABACJ1,ABBCJ1                 */
             /*     I-HASADA                2001.04.04     */
             /************************************ ABBC61 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&KEY )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG )  TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID)

/* JW SAVE LOG */
             CHGVAR     VAR(&KEY ) VALUE('ABBR61    ')
             CHGVAR     VAR(&MSG ) VALUE('ABBC61-->ABBR91: ADD FC DATA')
             CALL       PGM(UTLR07D) PARM(&KEY &MSG)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ABBR61) PARM(&PYM)

             ENDPGM

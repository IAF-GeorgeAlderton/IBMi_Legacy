             PGM
             /** CHKC38B *********************************************/
             /*  DELETE QTY=0 ORDER (HONDA)     -PP2A                */
             /*  J.WATANABE 2020.06.30                               */
             /********************************************************/
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&UPD)  TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&RTN) VALUE(' ')
             CHGVAR     VAR(&UPD) VALUE('Y')

/* DELETE QTY=0 ORDER (HONDA)  */

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES) +
                          USRDTA('DLT QTY=0')
             CALL       PGM(CHKR38C) PARM(&UPD &RTN)

             DLTOVR     FILE(QPRINT)

             ENDPGM

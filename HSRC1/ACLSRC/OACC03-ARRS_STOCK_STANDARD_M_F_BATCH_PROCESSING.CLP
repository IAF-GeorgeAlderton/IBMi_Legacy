             PGM
             /** OACC03 **************************************/
             /*   ARRS STOCK STANDARD M/F BATCH PROCESSING   */
             /* SETTING NUMBER AUTOMATIC HANDLING          */
             /* UPPER LIMIT NUMBER OF BOXES / THE BOTTOM NUMBER OF BOXES  */
             /* I-HASADA                       93.12.06      */
             /************************************** OACC03 **/
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)

             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             CHGVAR     VAR(&PYM) VALUE(%SST(&ABBDS3 1 6))
             CHGJOB     SWS(00000000)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(RPRINT9) FORMTYPE(K6H1)
             CALL       PGM(OACR02) PARM('Z' &PYM '          ')
             DLTOVR     FILE(*ALL)

             ENDPGM

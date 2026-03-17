             PGM
             /*** AKAC03 ****************************************/
             /*   USER PRODUCT DEMAND FORECAST NUMBER INQUIRY   */
             /*                <日付別の照会>                 */
             /*                   H.ITO          1991.04.09     */
             /*                   K.YASUDA       2001.07.13     */
             /**************************************** AKAC03 ***/
             DCL        VAR(&ABBDS1) TYPE(*CHAR) LEN(54)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             RTVDTAARA  DTAARA(ABBDS1) RTNVAR(&ABBDS1)

             CHGVAR     VAR(&PYM) VALUE(%SST(&ABBDS1 2 6))
             CALL       PGM(AKAR03) PARM(&PYM)

             ENDPGM

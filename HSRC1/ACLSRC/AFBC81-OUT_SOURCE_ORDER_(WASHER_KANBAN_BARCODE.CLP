             PGM
             /** AFBC81 ************************************/
             /* CALL READ COMPORNENT PARTS PROGRAM         */
             /* <LOCAL PARTS PROCUREMENT SYSTEM>           */
             /*    N.HYOTO 2001.04.11                      */
             /************************************ AFBC81 **/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKCD)  TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&WKCD) VALUE('999999')

             RTVJOBA    USER(&USER)

             CALL       PGM(AFBR81) PARM(&USER &WKCD)

             ENDPGM

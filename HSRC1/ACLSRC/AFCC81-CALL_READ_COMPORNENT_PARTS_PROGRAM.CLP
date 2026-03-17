             PGM
             /** AFCC81 ************************************/
             /* CALL READ COMPORNENT PARTS PROGRAM         */
             /* <LOCAL PARTS PROCUREMENT SYSTEM>           */
             /*            2001.08.03                      */
             /************************************ AFCC81 **/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKCD)  TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&WKCD) VALUE('999999')

             RTVJOBA    USER(&USER)

             CALL       PGM(AFCR81) PARM(&USER &WKCD)

             ENDPGM

             PGM
             /** UEXC90  **********************************************/
             /*  SET PACKING LIST# IN AB#PP10 (RUN EVERYDAY)          */
             /*  JW    2022.11.28                                     */
             /*-------------------------------------------------------*/

             DCL        VAR(&UPD) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&UPD) VALUE('Y')

             CALL       PGM(UEXR90A) PARM(&UPD)

             ENDPGM

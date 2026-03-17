             PGM
             /** AAVC14 ************************************/
             /*  DOWNLOAD AAVWP14A TO CSV                  */
             /*  JW    2022.11.04                          */
             /**********************************************/

             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&FNAM) VALUE('DAILY VOLUME')

             CALL       PGM(APLC94) PARM('2' 'AAVWP14A' 'QTEMP' +
                          &FNAM 'C' 'Y' 'Y')

             ENDPGM

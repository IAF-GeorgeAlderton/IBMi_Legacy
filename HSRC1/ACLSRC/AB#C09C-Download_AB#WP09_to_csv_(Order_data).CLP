             PGM
/** AB#C09C************************************************/
/*  DOWNLOAD AB#WP09  TO CSV  (ORDER DATA)                */
/*  JW    2023.12.06                                      */
/**********************************************************/
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&FNAM) VALUE('ORDER DATA')

             CALL       PGM(APLC97) PARM('2' 'AB#WP09 ' 'QTEMP' +
                          &FNAM 'Y' ' ' 'Y')

             ENDPGM

             PGM
/** ANZC09 ************************************************/
/*  TEST ANZR09                                           */
/*  JW   2024.04.10                                       */
/**********************************************************/
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)

             CLRPFM     FILE(ANZWP09)
             CLRPFM     FILE(ANZWP09A)

             CALL       PGM(ANZR09)

 /** DOWNLOAD TO CSV **/
             CHGVAR     VAR(&FNAM) VALUE('SAFETY STOCK')

             CALL       PGM(APLC97) PARM('2' 'ANZWP09A' 'HWFILE1' +
                          &FNAM 'Y' ' ' 'Y')

             ENDPGM

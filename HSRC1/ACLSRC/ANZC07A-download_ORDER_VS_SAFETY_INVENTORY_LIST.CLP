             PGM
/** ANZC07A ***********************************************/
/*  DOWNLOAD ORDER VS SAFETY INVENTORY LIST DATA          */
/*  JW   2024.01.05                                       */
/**********************************************************/
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             CLRPFM     FILE(HWFILE1/ANZWP07V)

             CALL       PGM(ANZR07A)

             CHGVAR     VAR(&FNAM) VALUE('ORD VS SAFE INVENTORY')

             CALL       PGM(APLC94) PARM('2' 'ANZWP07V' +
                          'HWFILE1' &FNAM   'Y'   ' '  'Y' )
             ENDPGM

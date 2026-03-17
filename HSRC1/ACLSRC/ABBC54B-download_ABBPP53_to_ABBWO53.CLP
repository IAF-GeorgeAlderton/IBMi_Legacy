             PGM
             /* ABBC54B *******************************************/
             /* DOWNLOAD ABBPP53 TO ABBWO53                       */
             /* J.W      2024.11.04                               */
             /*****************************************************/
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             CLRPFM     FILE(HWFILE1/ABBWP531)
             CLRPFM     FILE(HWFILE1/ABBWP532)

             CALL       PGM(ABBR54B) PARM('20241001' '99999999')

             CHGVAR     VAR(&FNAM) VALUE('FORD EDI862')
             CALL       PGM(APLC94) PARM('2' 'ABBWP532' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
             ENDPGM

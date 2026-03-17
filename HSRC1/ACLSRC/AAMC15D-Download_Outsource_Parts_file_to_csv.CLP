             PGM
             /* AAMC15D *******************************************/
             /* DOWNLOAD OUTSOURCE PARTS FILE TO CSV              */
             /* LEC      2022.05.05                               */
             /*****************************************************/
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&FNAM) VALUE('OUTSOURCE_PARTS')
             CALL       PGM(APLC94) PARM('2' 'AAMWP15' 'HWFILE1' &FNAM +
                          'Y' 'Y' 'Y')
             ENDPGM

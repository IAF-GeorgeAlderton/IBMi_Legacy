             PGM
             /* AAJC17 ********************************************/
             /* DOWNLOAD INTRA-PROCESS LOCATION CODE TO CSV       */
             /* J.W      2021.10.29                               */
             /*****************************************************/
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             CLRPFM     FILE(HWFILE1/AAJWP17)

             CALL       PGM(AAJR17)

             CHGVAR     VAR(&FNAM) VALUE('LOCATION DATA')
             CALL       PGM(APLC94) PARM('2' 'AAJWP17' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
             ENDPGM

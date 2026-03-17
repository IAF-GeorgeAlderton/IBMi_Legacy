             PGM
             /** ECQC15D *********************************/
             /*  DOWNLOAD DIE USAGE TO K DRIVE           */
             /*  JW       2025.01.17                     */
             /********************************************/

             DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             RTVMBRD    FILE(HWFILE1/ECQWP15) NBRCURRCD(&KEN)

             IF         (&KEN *GT 0) THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('ECQWP15#27')
             CALL       PGM(APLC94) PARM('2' 'ECQWP15' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
             ENDDO

             ENDPGM

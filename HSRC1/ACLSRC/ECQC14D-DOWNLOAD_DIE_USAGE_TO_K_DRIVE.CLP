             PGM
             /** ECQC14D *****************************************/
             /*  DOWNLOAD DIE USAGE TO K DRIVE                   */
             /*  JW       2025.01.17                             */
             /****************************************************/

             DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             RTVMBRD    FILE(HWFILE1/ECQWP16) NBRCURRCD(&KEN)

             IF         (&KEN *GT 0) THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('ECQWP16#67')
             CALL       PGM(APLC94) PARM('2' 'ECQWP16' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
             ENDDO

             ENDPGM

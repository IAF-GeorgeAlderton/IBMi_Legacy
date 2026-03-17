             PGM
             /** ECSC55D *****************************************/
             /*  DOWNLOAD DIE INVENTORY LIST TO K DRIVE          */
             /*  JW       2025.01.17                             */
             /****************************************************/

             DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             RTVMBRD    FILE(HWFILE1/ECSWP551) NBRCURRCD(&KEN)

             IF         (&KEN *GT 0) THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('ECSWP551#47')
             CALL       PGM(APLC94) PARM('2' 'ECSWP551' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
             ENDDO

             ENDPGM

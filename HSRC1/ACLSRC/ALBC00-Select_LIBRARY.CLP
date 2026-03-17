             PGM        PARM(&USER &WLIB)
             /** ALBC00 ************************/
             /*  LIBRARY                       */
             /*   I-HASADA         2000.09.25  */
             /************************ ALBC00 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             CHGVAR     VAR(&WLIB) VALUE('HWFILE1 ')

             IF         (&USER *EQ 'TEST      ') DO
             CHGVAR     VAR(&WLIB) VALUE('TWFILE1 ')
             ENDDO

             ENDPGM

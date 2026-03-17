             PGM        PARM(&USER &PLIB &WLIB)
             /** ALBC00 ************************/
             /*  LIBRARY  CHECK                */
             /*   I-HASADA         2015.11.04  */
             /************************ ALBC00 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             CHGVAR     VAR(&PLIB) VALUE('HFILE1  ')
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1 ')

             IF         (&USER *EQ 'TEST      ') DO
             CHGVAR     VAR(&PLIB) VALUE('TFILE1  ')
             CHGVAR     VAR(&WLIB) VALUE('TWFILE1 ')
             ENDDO

             ENDPGM

             PGM        PARM(&USER &OBJL)
             /** ALBC02 ************************/
             /*  CHG LIBLARY FOR TEST          */
             /*   T-SAKAKI         2016.12.02  */
             /************************ ALBC02 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&OBJL) VALUE('HOBJ1     ')

             IF         (&USER *EQ 'TEST      ') DO
             CHGVAR     VAR(&OBJL) VALUE('TOBJ1     ')
             CHGLIBL    LIBL(QGPL QTEMP QMGU QPCFSU TOBJ1 TFILE1 +
                          TWFILE1 TJRN1 HSRC1)
             ENDDO

             ENDPGM

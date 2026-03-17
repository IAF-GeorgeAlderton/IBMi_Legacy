             PGM
             /**AFBC93B *************************************************/
             /* JW      2024.06.18                                      */
             /***********************************************************/
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FROM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TO  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PART) TYPE(*CHAR) LEN(12)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&KEN)  TYPE(*DEC)  LEN(10 0)

 /* WORK FILE */
             DLTF       FILE(QTEMP/AFBWP93)
             MONMSG     MSGID(CPF0000)

           CRTDUPOBJ  OBJ(AFBWP93) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/AFBWP93

             CHGVAR     VAR(&SUPP) VALUE('    ')
             CHGVAR     VAR(&FROM) VALUE('20240501')
             CHGVAR     VAR(&TO  ) VALUE('20240620')
             CHGVAR     VAR(&PART) VALUE('             ')

             CALL AFBR93B PARM(&SUPP &FROM &TO &PART)

/******* TEMP *******/
/**      GOTO ENDP **/
/********************/

/*****************************************************/
/* DOWNLOAD INTRA-PROCESS LOCATION CODE TO CSV       */
/*****************************************************/

             RTVMBRD    FILE(QTEMP/AFBWP93) NBRCURRCD(&KEN)

             IF         (&KEN *LE 1) THEN(DO)
             CHGVAR     VAR(&RTN) VALUE('*')
             GOTO       ENDP
             ENDDO

             IF         (&KEN *GT 1) THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('WASHER_ODR' *BCAT &SUPP)
             CALL       PGM(APLC97) PARM('2' 'AFBWP93' 'QTEMP' &FNAM +
                          'Y' ' ' 'Y')
             ENDDO

ENDP:        ENDPGM

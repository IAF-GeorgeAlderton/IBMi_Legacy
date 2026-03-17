             PGM        PARM(&SUPP &FROM &TO &PART &RTN)
             /**AFBC93B *************************************************/
             /* DOWNLOAD OUTSRC WASHER ORDER TO CSV                     */
             /* <LOCAL PROCURMENT SYSTEM>                               */
             /* JW      2024.06.18                                      */
             /***********************************************************/
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FROM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TO  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PART) TYPE(*CHAR) LEN(12)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1) VALUE(' ')

             DCL        VAR(&KEN)  TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)
 /* WORK FILE */
             DLTF       FILE(QTEMP/AFBWP93)
             MONMSG     MSGID(CPF0000)

           CRTDUPOBJ  OBJ(AFBWP93) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/AFBWP93

             CALL AFBR93B PARM(&SUPP &FROM &TO &PART)

/* TEMP SAVE TO TWFILE1 */
             CPYF       FROMFILE(QTEMP/AFBWP93) +
                          TOFILE(TWFILE1/AFBWP93) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)

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

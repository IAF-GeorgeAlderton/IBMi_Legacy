             PGM        PARM(&SUPP &SUPX &FROM &TO &PART &RTN)
             /**AFDC05D ****************************/
             /* DOWNLOAD OUTSRC ORDER TO CSV       */
             /* <LOCAL PROCURMENT SYSTEM>          */
             /* JW      2023.08.04                 */
             /**************************************/
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SUPX) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FROM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TO  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PART) TYPE(*CHAR) LEN(12)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&KEN)  TYPE(*DEC)  LEN(10 0)
 /* WORK FILE */
             DLTF       FILE(QTEMP/AFDWP05D)
             MONMSG     MSGID(CPF0000)

           CRTDUPOBJ  OBJ(AFDWP05D) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/AFDWP05D

             CALL AFDR05D PARM(&SUPP &SUPX &FROM &TO &PART)

/* TEMP SAVE TO TWFILE1 */
             CPYF       FROMFILE(QTEMP/AFDWP05D) +
                          TOFILE(TWFILE1/AFDWP05D) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)

/*****************************************************/
/* DOWNLOAD INTRA-PROCESS LOCATION CODE TO CSV       */
/*****************************************************/

             RTVMBRD    FILE(QTEMP/AFDWP05D) NBRCURRCD(&KEN)

             IF         (&KEN *LE 1) THEN(DO)
             CHGVAR     VAR(&RTN) VALUE('*')
             GOTO       ENDP
             ENDDO

             IF         (&KEN *GT 1) THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('OUTSRC_ODR' *BCAT &SUPP)
             CALL       PGM(APLC97) PARM('2' 'AFDWP05D' 'QTEMP' &FNAM +
                          'Y' ' ' 'Y')
             ENDDO

ENDP:        ENDPGM

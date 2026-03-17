             PGM        PARM(&SUPP &FROM &TO &PART &RTN)
             /**AFDC05E ****************************/
             /* DOWNLOAD OUTSRC ORDER TO CSV       */
             /* <LOCAL PROCURMENT SYSTEM>          */
             /* JW      2023.10.11                 */
             /**************************************/
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FROM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TO  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PART) TYPE(*CHAR) LEN(12)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&KEN)  TYPE(*DEC)  LEN(10 0)
 /* WORK FILE */
             DLTF       FILE(QTEMP/AFDWP05E)
             MONMSG     MSGID(CPF0000)

           CRTDUPOBJ  OBJ(AFDWP05E) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/AFDWP05E

             CALL AFDR05E PARM(&SUPP &FROM &TO &PART)

/* TEMP SAVE TO TWFILE1 */
       /**   CPYF       FROMFILE(QTEMP/AFDWP05E) +                    **/
       /**                TOFILE(TWFILE1/AFDWP05E) MBROPT(*REPLACE) + **/
       /**                FMTOPT(*NOCHK)                              **/

/*****************************************************/
/* DOWNLOAD INTRA-PROCESS LOCATION CODE TO CSV       */
/*****************************************************/

             RTVMBRD    FILE(QTEMP/AFDWP05E) NBRCURRCD(&KEN)

             IF         (&KEN *LE 1) THEN(DO)
             CHGVAR     VAR(&RTN) VALUE('*')
             GOTO       ENDP
             ENDDO

             IF         (&KEN *GT 1) THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('OUTSRC_ODR' *BCAT &SUPP)
             CALL       PGM(APLC97) PARM('2' 'AFDWP05E' 'QTEMP' &FNAM +
                          'Y' ' ' 'Y')
             ENDDO

ENDP:        ENDPGM

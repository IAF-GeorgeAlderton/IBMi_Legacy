             PGM
             /** KFAC30 ********************************************/
             /*  UPDATE OPEN LOCATION DATE BY CSV                  */
             /*  JW     2024.08.20                                 */
             /******************************************************/
             DCLF       FILE(KFAPW30)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&UPD )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&STS )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&UCNT)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&ECNT)  TYPE(*CHAR) LEN(5)

             RTVJOBA    JOB(&WSID)

             /*** DISPLAY INITIAL SCREEN ***/
 DSP01:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&UPD) VALUE('N')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(XEND))
             IF         COND(&IN05 *EQ '1') THEN(CHGVAR VAR(&UPD) VALUE('Y'))


             /*** TRANSFER FROM J: ***/
             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          PC/Upload/KANBAN_LOC.csv') +
                          TOFILE(HWFILE1/KFAWP30) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)
             MONMSG     MSGID(CPF2817)

             CALL       PGM(KFAR30) PARM(&UPD &STS $UCNT &ECNT)

             IF         COND(&STS *NE ' ') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('Error!')
             GOTO       DSP01
             ENDDO

/** ENTR */  IF         COND(&UPD *EQ 'N') THEN(DO)
             IF         COND(&STS *EQ ' ') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('No Error. Press F5 to +
                          Update...')
             GOTO       DSP01
             ENDDO
             ENDDO

/** F5   */  IF         COND(&UPD *EQ 'Y') THEN(DO)
             IF         COND(&STS *EQ ' ') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('Updated successfully...')
             GOTO       XEND
             ENDDO
             ENDDO

XEND:
             ENDPGM

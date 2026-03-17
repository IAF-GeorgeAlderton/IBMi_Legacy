             PGM
/** ALCC05 ************************************************/
/*  THE NUMBER OF PROCESSED BOXES BY WORKER LIST          */
/*                                                        */
/*  TCHK1 06/03/09 CREATE(COPY FROM ALDC04)               */
/**********************************************************/
             DCLF       FILE(ALCPW05)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CHGVAR     VAR(&YEAR) VALUE(0)
             CHGVAR     VAR(&MM)   VALUE(0)
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ALCPW051)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&MSG ) VALUE(' ')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&YEAR *NE 0) GOTO STP2
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&MSG ) VALUE('ENTER YEAR!')
             GOTO       STP1

 STP2:
             IF         ((&MM *GE 01) *AND (&MM *LE 12)) GOTO STP3
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&MSG ) VALUE('DATE IS INVALID!')
             GOTO       STP1

 STP3:
             IF         COND(&IN05 *EQ '0' *AND &IN09 *EQ '0') THEN(DO)
             CHGVAR     VAR(&MSG ) VALUE('PRESS F5 TO PRINT...')
             GOTO       CMDLBL(STP1)
             ENDDO

             CLRPFM     FILE(ALCWP05)
       /*    MONMSG     MSGID(CPF0000)   */

             CLRPFM     FILE(ALCWP06)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(ALCR05) PARM(&YEAR &MM)
 /* F9 */
             IF         COND(&IN09 *EQ '1') THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(LANPRT10)
             CALL       PGM(ALCR11) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)
             GOTO END
             ENDDO
 /* F5 */
             OVRPRTF    FILE(QPRINT) HOLD(*YES) OUTQ(QPRINT)
             CALL       PGM(ALCR06) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)

             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT10)
             CALL       PGM(ALCR07) PARM(&USR &YEAR &MM)
             CALL       PGM(ALCR08) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)

             OVRPRTF    FILE(QPRINT) HOLD(*YES) OUTQ(QPRINT)
             CALL       PGM(ALCR09) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM

             PGM
/** ALCC06  ***********************************************/
/*  THE NUMBER OF PROCESSED BOXES BY WORKER LIST          */
/*                                                        */
/*  TCHK1 06/03/09 CREATE(COPY FROM ALDC04)               */
/**********************************************************/
             DCLF       FILE(ALCPW06 )
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT  ) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB ) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USR  &WLIB)
 /* PRINTER */
             CHGVAR     VAR(&PRT) VALUE('LANPRT10')
             IF  COND(&USR *EQ 'I0777') THEN(CHGVAR VAR(&PRT) VALUE('QPRINT'))
             IF  COND(&USR *EQ 'TEST ') THEN(CHGVAR VAR(&PRT) VALUE('QPRINT'))

             CHGVAR     VAR(&YEAR) VALUE(0)
             CHGVAR     VAR(&MM)   VALUE(0)
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

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

             CALL       PGM(ALCR051) PARM(&YEAR &MM)
 /* F9 */
             IF         COND(&IN09 *EQ '1') THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(&PRT)
             CALL       PGM(ALCR111) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)
             GOTO END
             ENDDO
 /* F5 */
             OVRPRTF    FILE(QPRINT) HOLD(*YES) OUTQ(QPRINT)
             CALL       PGM(ALCR061) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)

             OVRPRTF    FILE(QPRINT) OUTQ(&PRT)
             CALL       PGM(ALCR071) PARM(&USR &YEAR &MM)
             CALL       PGM(ALCR081) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)

             OVRPRTF    FILE(QPRINT) HOLD(*YES) OUTQ(QPRINT)
             CALL       PGM(ALCR091) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM

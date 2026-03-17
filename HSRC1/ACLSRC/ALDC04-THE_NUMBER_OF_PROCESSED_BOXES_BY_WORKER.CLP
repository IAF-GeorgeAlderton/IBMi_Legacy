             PGM
             /** ALDC04 **********************************************/
             /*  THE NUMBER OF PROCESSED BOXES BY WORKER LIST        */
             /*  TCH 00.08.14                                        */
             /*  THE NUMBER OF PROCESSED BOXES BY DATE(ALDR08)ADDED  */
             /*  TCH 00.01.15                                        */
             /*  ADD DAILY REPORT OPTION(F09)    TCH OCT/10/02       */
             /*                                                      */
             /********************************************** ALDC04 **/
             DCLF       FILE(ALDPW04)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CHGVAR     VAR(&YEAR) VALUE(0)
             CHGVAR     VAR(&MM)   VALUE(0)
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ALDPW041)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&YEAR *NE 0) GOTO STP2
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       STP1

 STP2:
             IF         ((&MM *GE 01) *AND (&MM *LE 12)) GOTO STP3
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       STP1


 STP3:
             IF         COND(&IN05 *EQ '0' *AND &IN09 *EQ '0') +
                          THEN(GOTO CMDLBL(STP1))

             CLRPFM     FILE(ALDWP05)
       /*    MONMSG     MSGID(CPF0000)   */

             CLRPFM     FILE(ALDWP06)
             MONMSG     MSGID(CPF0000)

             OVRPRTF    FILE(QPRINT) SAVE(*YES)
             CALL       PGM(ALDR05) PARM(&YEAR &MM)
             DLTOVR     FILE(*ALL)

             IF         COND(&IN09 *EQ '1') THEN(DO)
/* TCHK1     OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) */
/* TCHK1 */  OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(LANPRT06)
             CALL       PGM(ALDR11) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)
             GOTO END
             ENDDO

             OVRPRTF    FILE(QPRINT) HOLD(*YES)
             CALL       PGM(ALDR06) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)

/* TCHK1 */  OVRPRTF    FILE(QPRINT) OUTQ(LANPRT06)
             CALL       PGM(ALDR07) PARM(&USR &YEAR &MM)
             CALL       PGM(ALDR08) PARM(&USR &YEAR &MM)
/* TCHK1 */  DLTOVR     FILE(*ALL)

             OVRPRTF    FILE(QPRINT) HOLD(*YES)
             CALL       PGM(ALDR09) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM

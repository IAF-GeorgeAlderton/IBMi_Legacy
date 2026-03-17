             PGM
/** ALFC05 ************************************************/
/*  CONVEYANCE WASHER # OF PROCESSED BOXES BY WORKER LIST */
/*                                                        */
/* TCHK1 10/21/10 CREATE(COPY FROM ALCC05)                */
/**********************************************************/
             DCLF       FILE(ALFPW05)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CHGVAR     VAR(&YEAR) VALUE(0)
             CHGVAR     VAR(&MM)   VALUE(0)
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ALFPW051)

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

             CLRPFM     FILE(ALFWP05)
       /*    MONMSG     MSGID(CPF0000)   */

             CLRPFM     FILE(ALFWP06)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(ALFR05) PARM(&YEAR &MM)

             IF         COND(&IN09 *EQ '1') THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(LANPRT10)
             CALL       PGM(ALFR11) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)
             GOTO END
             ENDDO

             OVRPRTF    FILE(QPRINT) HOLD(*YES) OUTQ(QPRINT)
             CALL       PGM(ALFR06) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)

             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT10)
             CALL       PGM(ALFR07) PARM(&USR &YEAR &MM)
             CALL       PGM(ALFR08) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)

             OVRPRTF    FILE(QPRINT) HOLD(*YES) OUTQ(QPRINT)
             CALL       PGM(ALFR09) PARM(&USR &YEAR &MM)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM

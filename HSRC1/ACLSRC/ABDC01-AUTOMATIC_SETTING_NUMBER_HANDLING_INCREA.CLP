             PGM
             /** ABDC01 ***********************************/
             /* AUTOMATIC SETTING NUMBER HANDLING INCREASE AND DECREASE */
             /*     NUMBER OF SHEETS LIST BY EACH FACTORY */
             /* A-PICS1                                 */
             /* ABDC0B CHANGE                        */
             /* KOHHY.                   90.11.28         */
             /*********************************** ABDC01 **/
             DCLF       FILE(ABDPW01)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&HIZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&YMJ) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVDTAARA  DTAARA(ABDDS1) RTNVAR(&HIZ)
             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&YMJ)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ABDPW011)
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN02 *EQ '1') GOTO END

             IF         (&IN05 *NE '1') GOTO STP1

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(ABDR01) PARM(&YMJ &HIZ)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM

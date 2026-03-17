             PGM
             /** AAJC12 ************************************/
             /* INTRA-PROCESS LOCATION CODE M/F ACCOUNT BOOK CREATE CL */
             /*          M-OKUDA        1986.09.23         */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)
             MONMSG     MSGID(CPF2103)
             OVRPRTF    FILE(AAJPR12) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1) HOLD(*NO)
             OVRPRTF    FILE(AAJPR13) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1) HOLD(*NO)
             CALL       PGM(AAJR13)
             DLTOVR     FILE(AAJPR12)
             DLTOVR     FILE(AAJPR13)
             GOTO       END
 END:        ENDPGM

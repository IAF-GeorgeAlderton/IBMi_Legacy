             PGM
             /** AADC21 ************************************/
             /* INTRA-PROCESS KANBAN M/F ACCOUNT BOOK MAKING */
             /*          M-OKUDA        1987.02.05         */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             MONMSG     MSGID(CPF2103)
             OVRPRTF    FILE(AADPR21) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(AADR21)
             DLTOVR     FILE(AADPR21)
 END:        ENDPGM

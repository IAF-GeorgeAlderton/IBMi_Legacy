             PGM
             /** AAKC12 ************************************/
             /* INTRAL COMPANY SERVICE BIN M/F ACCOUNT BOOK CREAT CL */
             /*          M S K          1987.04.25         */
             /* CHANGE OUTQ                                */
             /*          K.KASHIWAGI    2001.04.23         */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

   /*        OVRPRTF    FILE(AAKPR12) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) OVRFLW(64) OUTQ(ZAPS1) +
                          FORMTYPE(K6H1) HOLD(*YES) SAVE(*YES)   */
             OVRPRTF    FILE(AAKPR12) PAGESIZE(66 132) OVRFLW(64) +
                          OUTQ(QPRINT) FORMTYPE(K6H1) HOLD(*YES) +
                          SAVE(*YES)
             CALL       PGM(AAKR12) PARM(&USER)
             DLTOVR     FILE(AAKPR12)

 END:        ENDPGM

             PGM
             /** FCQC42 ************************************/
             /*  LIST  OF STANDARD DIR LIFE SPAN           */
             /*  MSK.KUNIEDA                 98.05.25      */
             /**********************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&RPY)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             /*-----------------------------------------------------*/
             CHGJOB     OUTQ(&PRTG)

    /*       OVRPRTF    FILE(FCQPR42) DEVTYPE(*AFPDS) PAGESIZE(66 + */
    /*                    198) LPI(6) CPI(15) OVRFLW(64) +          */
    /*                    OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)     */

             OVRPRTF    FILE(FCQPR42)                 PAGESIZE(66 +
                          132) LPI(6)         OVRFLW(64) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(FCQR42) PARM(&USER)

             DLTOVR     FILE(*ALL)

 END:        CHGJOB     OUTQ(&PRT)

             ENDPGM

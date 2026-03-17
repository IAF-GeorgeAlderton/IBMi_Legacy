             PGM
             /** AGAC23 ************************************/
             /* LEVELLED PRODUCTION FIXED FILE ACCOUNT BOOK CREATE NO-2 */
             /*          M-OKUDA        1986.09.25         */
             /**********************************************/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO)

             CHGJOB     RUNPTY(40)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             OVRPRTF    FILE(AGAPR23) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)
             CALL       PGM(AGAR23)
             DLTOVR     FILE(AGAPR23)

             CHGJOB     RUNPTY(20)

             ENDPGM

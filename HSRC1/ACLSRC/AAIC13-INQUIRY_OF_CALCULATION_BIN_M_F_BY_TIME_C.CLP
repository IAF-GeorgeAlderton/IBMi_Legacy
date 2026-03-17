             PGM
             /** AAIC13 ************************************/
             /*INQUIRY OF CALCULATION BIN M/F BY TIME CL   */
             /*(CONFIRM STATUS OF PRODUCTION INSTRUCTION DATA */
             /*          M-OKUDA        1987.01.19         */
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
 STEP02:     CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AAIR13) PARM(&USER)
             CHGJOB     OUTQ(&PRT)
 END:        ENDPGM

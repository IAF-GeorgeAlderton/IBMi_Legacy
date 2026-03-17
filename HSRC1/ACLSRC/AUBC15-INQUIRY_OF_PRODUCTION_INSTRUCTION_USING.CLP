             PGM
             /** AUBC11 ************************************/
             /* INQUIRY  OF PRODUCTION INSTRUCTION USING RECEIPT DATA CL */
             /*PRODUCTION INSTRUCTION DATA STATUS CONFIRM */
             /*          M-OKUDA        1987.03.08         */
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
             CALL       PGM(AUBR15)
             CHGJOB     OUTQ(&PRT)
 END:        ENDPGM

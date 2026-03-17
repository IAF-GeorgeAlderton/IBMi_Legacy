             PGM
             /** AHAC12 ************************************/
             /*  確定発注累積データの照会                */
             /*                              94.08.31      */
             /* TCHK1 04/09/07 RMV CALLING PARM            */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BUMN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
 STEP02:     CHGJOB     OUTQ(&PRTG)
/* TCHK1     CALL       PGM(AHAR12) PARM(&USER) */
/* TCHK1 */  CALL       PGM(AHAR12)
 END:        CHGJOB     OUTQ(&PRT)
             ENDPGM

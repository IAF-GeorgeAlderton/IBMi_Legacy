             PGM
             /** AHAC11 ************************************/
             /* INQUIRY OF FIXED ORDERING ACCUMULATION DATA */
             /*                              87.01.06      */
             /* TCHK1 04/06/07 RMV CALLING PARM            */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BUMN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CODE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
 STEP02:     CHGJOB     OUTQ(&PRTG)
/* TCHK1     CHGVAR     VAR(&CODE) VALUE(%SST(&WSNO 1 1)) */
/* TCHK1     CALL       PGM(AHAR11) PARM(&CODE)           */
/* TCHK1 */  CALL       PGM(AHAR11)
 END:        CHGJOB     OUTQ(&PRT)
             ENDPGM

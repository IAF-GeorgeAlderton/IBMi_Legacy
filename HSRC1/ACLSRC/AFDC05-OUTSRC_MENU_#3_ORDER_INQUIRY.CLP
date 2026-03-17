             PGM        PARM(&SUPP &SUPX)
             /** AFDC05 ****************************/
             /* INQUIRY                            */
             /* <LOCAL PROCURMENT SYSTEM>          */
             /*    CREATE DATE  2001.12.17         */
             /**************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&SUPX)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&HIN1)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN2)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN3)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDAT)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

      /**********************************************************/
      /* IF SUPP= 5555(FAS), THEN SKIP TO STEP5555              */
      /**********************************************************/
             IF         (&SUPP *EQ '5555') GOTO STEP5555

      /**********************************************************/
      /* PROCESS AFDR05 THEN GOTO END                           */
      /**********************************************************/
             CALL       PGM(AFDR05) PARM(&SUPP &SUPX &HIN1 &HIN2 +
                          &HIN3 &SDAT)
             GOTO END

 STEP5555:
      /**********************************************************/
      /* PROCESS AFDR13 FOR FAS(5555)                           */
      /**********************************************************/
             CALL       PGM(AFDR13) PARM(&SUPP &SUPX &HIN1 &HIN2 +
                          &HIN3 &SDAT)

 END:
             ENDPGM

             PGM
             /*** AJHC17 ************************************************/
             /* INQUIRY OF JC LOADING RESULTS DATA(MACHINE NO)          */
             /*                             CREATE DATE  : 2014.12.12   */
             /*                             AUTHOR       : KIRI         */
             /************************************** CPOY FROM AJHC27 ***/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

 STEP02:     CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AJHR17N)

 END:        ENDPGM

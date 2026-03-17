             PGM
             /*** AJHC27 ************************************************/
             /* INQUIRY OF JC UNLOADING RESULTS DATA(MACHINE NO)        */
             /*                             CREATE DATE  : 2013.11.19   */
             /*                             AUTHOR       : KIRI         */
             /************************************************ AJHC27 ***/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

 STEP02:     CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AJHR27)

 END:        ENDPGM

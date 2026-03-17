             PGM
             /*** AJSC3A ************************************/
             /* INQUIRY OF DACRODIZING PLATING 2ND ADMIT RESULTS DATA */
             /*                 CREATE DATE  : 2014.08.11   */
             /*                 AUTHOR       : T.SAKASHITA  */
             /************************************ AJSC30 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

 STEP02:     CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AJSR3A) PARM(' ' '     ' '     ' '  ' +
                          '        ')

 END:        ENDPGM

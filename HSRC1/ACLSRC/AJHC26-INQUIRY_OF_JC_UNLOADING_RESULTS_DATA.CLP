             PGM
             /*** AJHC26 ************************************************/
             /* INQUIRY OF JC UNLOADING RESULTS DATA                    */
             /*                             CREATE DATE  : 2013.MAY.24  */
             /*                             AUTHOR       : T.SAKASHITA  */
             /************************************************ AJSC36 ***/
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
             CALL       PGM(AJHR26) PARM(' ' '     ' '     ' '  ' +
                          '        ')

 END:        ENDPGM

             PGM
             /*** AJHC16 ************************************************/
             /* INQUIRY OF JC LOADING RESULTS DATA                      */
             /*                             CREATE DATE  : 2014.12.12   */
             /*                             AUTHOR       : KIRI         */
             /************************************** COPY FROM AJHC26 ***/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)


             RTVJOBA    JOB(&WSNO)
             CHGJOB     SWS(00000000)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

 STEP01:     CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AJHR16) PARM(' ' '     ' '     ' '  ' +
                          '        ')

 END:        ENDPGM

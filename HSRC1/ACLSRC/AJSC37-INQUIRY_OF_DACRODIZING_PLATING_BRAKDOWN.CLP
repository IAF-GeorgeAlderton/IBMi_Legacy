             PGM
             /*** AJSC37 **************************************************/
             /* INQUIRY  OF DACRODIZING PLATING BRAKDOWN RESULTS DATA     */
             /*                               CREATE DATE  : 1997/MAR/13. */
             /*                               AUTHOR       : S.OHTAKE.    */
             /************************************************** AJSC37 ***/
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
             CALL       PGM(AJSR37)

 END:        ENDPGM

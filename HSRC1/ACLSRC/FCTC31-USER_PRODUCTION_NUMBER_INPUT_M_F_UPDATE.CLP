             PGM
             /** FCTC31 *************************************/
             /* ...USER PRODUCTION NUMBER INPUT M/F UPDATE ... */
             /* NEW PRODUCTION  DESIGN CHANGE CHANGE M/F UPDATE ...       */
             /*          I-HASADA         85.03.25          */
             /************************************* FCTC31 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(FCTR31) PARM(&USER)

             ENDPGM

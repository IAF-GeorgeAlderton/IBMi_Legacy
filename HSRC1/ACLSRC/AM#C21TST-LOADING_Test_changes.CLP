             PGM

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WUSRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&WUSRID)

/*******************************************************************/
/*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM((&WORKER) (&WUSRID) (&VALID))

/*******************************************************************/
             IF         COND(&VALID = 'Y') THEN(DO)
             CALL       PGM(TOBJ1/AM#R21) PARM((&WORKER) (&WUSRID) +
                          (&PCMD))
                                           ENDDO

/*******************************************************************/

             SIGNOFF

             ENDPGM

             PGM
             /** AM#C55 ************************/
             /* TOYOTA RFID LABEL SCAN         */
             /*   LEC.             2020.02.13  */
             /**********************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WUSRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&WUSRID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

  /*******************************************************************/
  /*  TEAM MEMBER SIGN-ON                                            */
              CALL       PGM(ALCR0Y) PARM(&WORKER &WUSRID &VALID)

  /*******************************************************************/

             IF         COND(&VALID = 'Y') THEN(DO)
             CALL       PGM(AM#R55) PARM(&WORKER &WUSRID)
                                           ENDDO

             SIGNOFF

             ENDPGM

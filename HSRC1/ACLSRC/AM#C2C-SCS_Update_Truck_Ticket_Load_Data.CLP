             PGM
  /** AM#C21F  *****************************************/
  /* SCS - UPDATE TRUCK TICKET LOAD DATA               */
  /*   LEC.             2024.02.21                     */
  /*****************************************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TT) TYPE(*CHAR) LEN(25)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)

/*******************************************************************/
/*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM(&WORKER &USER &VALID)

/*******************************************************************/

    IF         COND(&VALID = 'Y') THEN(DO)

             OVRDBF     FILE(AM#EX24) TOFILE(AM#PP24SS)
             CALL       PGM(AM#R21F) PARM(&WORKER)
             DLTOVR     FILE(*ALL)
    ENDDO

             ENDPGM

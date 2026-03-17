             PGM
  /** ASCC01   *****************************************/
  /* SCRAP SCAN PROGRAM TO REMOVE FROM INVENTORY       */
  /*   LEC.             2024.10.16                     */
  /*****************************************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)

/*******************************************************************/
/*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM(&WORKER &USER &VALID)

/*******************************************************************/
/*  IF WORKER CODE IS VALID,                                       */
/*     THEN RUN SCRAP SCAN...                                      */

    IF         COND(&VALID = 'Y') THEN(DO)
       CALL       PGM(ASCR01) PARM(&WORKER)
    ENDDO

 THEEND:     SIGNOFF

             ENDPGM

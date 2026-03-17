             PGM
  /** AM#C2R   *****************************************/
  /* LOADING - RESEND PALLET INFO AND RETRY LOAD SEND  */
  /*   LEC.             2023.12.18                     */
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
/*  IF WORKER CODE IS VALID,                                       */
/*     GET TRUCK TICKET, RESEND INFO FOR ALL PALLETS NOT CONFIRMED */
/*     THEN SEND TRUCK LOAD INFO...                                */

    IF         COND(&VALID = 'Y') THEN(DO)
       CALL       PGM(AM#R21Z) PARM(&WORKER &USER &TT &PCMD)
       IF         COND(&PCMD = '03') THEN(GOTO CMDLBL(THEEND))
       CALL       PGM(AM#R415) PARM(&WORKER &TT)
    ENDDO

 THEEND:     ENDPGM

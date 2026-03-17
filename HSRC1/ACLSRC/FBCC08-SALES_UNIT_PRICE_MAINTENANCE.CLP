             PGM
             /** FBCC08 ******************************/
             /* ..SALES UNIT PRICE MASTER ADDITION   */
             /*                        2003.02.03    */
             /****************************** FBCC04 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCLF       FILE(FBCPW08C)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
  @STRT:
             CHGVAR     VAR(&D@SLC) VALUE(' ')
             SNDRCVF    RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&D@SLC *EQ '1') THEN(CALL PGM(FBCR08))
             IF         COND(&D@SLC *EQ '2') THEN(CALL PGM(FBCR09))

             GOTO       CMDLBL(@STRT)
 @END:
             ENDPGM

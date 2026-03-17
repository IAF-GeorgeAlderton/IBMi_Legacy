             PGM
             /** CAAC50 ****************************/
             /*  INSTRUCTION KANBAN ISSUE       .  */
             /*  ..Ａ－ＰＩＣＳⅡ                */
             /*     T-SAKAKI         2020.08.18    */
             /*****COPY FROM CAAC10******* CAAC50 **/
             DCL        VAR(&SYS)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PBMON) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PBIN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WFILE) TYPE(*CHAR) LEN(9)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN1) TYPE(*CHAR) LEN(1)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    USER(&USER)
             CHGJOB     SWS(00000000)

    /********************************/
    /* CHECK LIBRARY                */
    /********************************/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

    /********************************/
    /* CHECK UNLOCK MANAGEMENT      */
    /********************************/
              CALL CHKC45 ('CAAHAK' 'CAAC50' 'Y'  'CHK' &RTN1)
              IF         COND(&RTN1 *NE ' ') THEN(GOTO SEND)

    /********************************/
    /* DISPLAY                      */
    /********************************/
          /* CAAR10 ->  CAAC17 DATA CREATE */
 @STP1:      CALL       PGM(CAAR10) PARM(&PBMON &PBIN)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  MSG('AN ERROR OCCURRED IN THE PROGRAM +
                          (CAAR10) ....< RETRY -> R  CANCEL -> C +
                          >') VALUES('R' 'C') MSGTYPE(*INQ) +
                          TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND(&RPY *EQ 'R' *OR &RPY *EQ 'r') +
                          THEN(GOTO CMDLBL(@STP1))
             RETURN
             ENDDO

    /* ERROR HAPPENED  */
             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       UEND
             ENDDO

             CHGVAR     VAR(&WFILE) VALUE('CAA' *TCAT &PBMON *TCAT +
                          &PBIN)

    /** INDICATION PAPER  *STOP*   **/
      /**    CALL       PGM(CAAC20) PARM(&WFILE)  **/

    /********************************/
    /* UPDATE CYCLE MASTER          */
    /********************************/
 @STP2:      CALL       PGM(CAAR11) PARM(&PBMON &PBIN)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  MSG('AN ERROR OCCURRED IN THE PROGRAM +
                          (CAAR11) .... <  RETRY -> R  CANCEL -> C  +
                          >') VALUES('R' 'C') MSGTYPE(*INQ) +
                          TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND(&RPY *EQ 'R' *OR &RPY *EQ 'r') +
                          THEN(GOTO CMDLBL(@STP2))
             RETURN
             ENDDO

    /********************************/
    /* *STOP   DOWNLOAD ISSUE DATA  */
    /********************************/
      /* STOP  TRANSFER TO PC VIA FTP JOB */

    /********************************/
    /* *STOP   ISSUE DETAIL LIST    */
    /********************************/
      /*     OVRDBF     FILE(CAA999901) TOFILE(&WFILE)  */
      /*     CALL       PGM(CAAC59)   */

    /********************************/
    /* UNLOCK                       */
    /********************************/
 UEND:       DLTOVR     FILE(*ALL)
             CALL       PGM(CHKC45) PARM('CAAHAK' 'CAAC50' 'N' '' '')

 SEND:       ENDPGM

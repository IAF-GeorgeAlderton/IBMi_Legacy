             PGM
             /** MYCC9A *********************************************/
             /*  MASTER DOWNLOAD MENU                               */
             /*  T-SAKAKI          2020/03/18                       */
             /*  JW        2021.01.14 ADD 7: WASHER KANBAN          */
             /*  JW        2021.02.05 ADD 8: PT     KANBAN          */
             /*  JW        2021.02.22 ADD 9: BPT    KANBAN          */
             /*******************************************************/
             DCLF       FILE(MYCPW9A)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS)

 STEPI:      SNDRCVF    DEV(&WS) RCDFMT(MYCPW9A1)
             CHGVAR VAR(&IN99) VALUE('0')
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

             IF         COND(&TYPE *EQ 0  ) THEN(DO)
             CHGVAR VAR(&MSG) VALUE('ENTER TYPE')
             CHGVAR VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STEPI)
             ENDDO

             IF         (&TYPE *EQ  1 ) GOTO STEP01
             IF         (&TYPE *EQ  2 ) GOTO STEP02
             IF         (&TYPE *EQ  3 ) GOTO STEP03
             IF         (&TYPE *EQ  4 ) GOTO STEP04
             IF         (&TYPE *EQ  5 ) GOTO STEP05
             IF         (&TYPE *EQ  6 ) GOTO STEP06
/*JW1*/      IF         (&TYPE *EQ  7 ) GOTO STEP07
/*JW1*/      IF         (&TYPE *EQ  8 ) GOTO STEP08
/*JW1*/      IF         (&TYPE *EQ  9 ) GOTO STEP09
/*JW1*/      IF         (&TYPE *EQ 10 ) GOTO STEP10
/*JW1*/      IF         (&TYPE *EQ 11 ) GOTO STEP11
/*JW1*/      IF         (&TYPE *EQ 12 ) GOTO STEP12

             CHGVAR VAR(&MSG) VALUE('ENTER VALID TYPE')
             CHGVAR VAR(&IN99) VALUE('1')
/*JW1*/      GOTO STEPI

 STEP01:     CALL MYCC90
             GOTO STEPI

 STEP02:     CALL MYCC94
             GOTO STEPI

 STEP03:     CALL MYCC91
             GOTO STEPI

 STEP04:     CALL MYCC92
             GOTO STEPI

 STEP05:     CALL MYCC93
             GOTO STEPI

 STEP06:     CALL MYCC95
             GOTO STEPI

 STEP07:     CALL MYCC96
             GOTO STEPI

 STEP08:     CALL MYCC97
             GOTO STEPI

 STEP09:     CALL MYCC98
             GOTO STEPI

 STEP10:     CALL MYCC99
             GOTO STEPI

 STEP11:     CALL MYCC80
             GOTO STEPI

 STEP12:     CALL ANZC09
             GOTO STEPI

 END:        ENDPGM

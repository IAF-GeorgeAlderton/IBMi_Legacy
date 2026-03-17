             PGM
             /** ALBC11 ************************************/
             /* KANBAN BACKSIDE PUBLICATION DATA CREATE    */
             /*   (CARE POWER)                             */
             /*          K.NAKAMURA     H3.12.19           */
             /************************************ ALBC11 **/
             DCL        VAR(&REC) TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PM) TYPE(*CHAR) LEN(2)
/*           DCL        VAR(&PER) TYPE(*CHAR) LEN(1)                 */
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
/*           CHGJOB     SWS(00000000)                                */

             RTVJOBA    JOB(&WSID)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGVAR     VAR(&PM) VALUE(%SST(&ABADS1 5 2))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)


 STP1:       CHKOBJ     OBJ(ALBTUR) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP2))

 STP3:       SNDPGMMSG  MSG('( G ) +
                          DURING TOPICS KANBAN BACKSIDE DATA CREATE.+
                           WAIT FOR A WHILE') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP3))
             GOTO       END

 STP2:       CRTDTAARA  DTAARA(ALBTUR) TYPE(*CHAR) LEN(10) +
                          TEXT('TOPICS KANBAN BACKSIDE DATA CREATE +
                          CHECK<TV>') AUT(*ALL)
             MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(STP1))

/*           CALL       PGM(ALBR13) PARM('C' &PER)                   */

/*           IF         (&PER *EQ 'M') DO                            */
/*  STP4:  SNDPGMMSG  MSG('( G ) ﾎｦbﾓm]c ﾃ]nﾜｰﾓuﾇjｰ( AAIPP21 ) p +
                          ALBNPK5 fﾞ ncﾜh ﾅﾛmbob...') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)                */
/*           RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)                                 */
/*           IF         (&KOTE *NE 'G') GOTO STP4                    */
/*           GOTO       SEND                                         */
/*           ENDDO                                                   */

/*           IF         (&PER *EQ 'N') DO                            */
/*  STP5:     SNDPGMMSG  MSG('( G ) +
                          TOPICS RECEIVES A MESSAGE OF KANBAN  +
                          BACKSIDE DATA,AND IS THERE NOT IT?') +
                            TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)                */
/*           RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)                                 */
/*           IF         (&KOTE *NE 'G') GOTO STP5                    */
/*           GOTO       SEND                                         */
/*           ENDDO                                                   */

             CHKOBJ     OBJ(ALBWP11) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(HWFILE1/ALBWP11) +
                          SRCMBR(ALBWP11) TEXT('TOPICS RECIEVE +
                          KANBAN BACKSIDE DATA<TV> ') +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL))
             CLRPFM     FILE(ALBWP11)

             CALL       PGM(ALBR11) PARM(&PM)

/*           IF         (%SWITCH(0XXXXXXX)) DO                       */
/*           CALL       PGM(ALBR13) PARM('O' &PER)                   */
/*           GOTO       SEND                                         */
/*           ENDDO                                                   */

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/ALBWP11) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(SEND))

             CHKOBJ     OBJ(ALBNPK5) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(HWFILE1/ALBNPK5) RCDLEN(130) +
                          TEXT('TOPICS RECIEVE KANBAN BACKSIDE DATA +
                          <TV>') OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) AUT(*ALL))
             CLRPFM     FILE(ALBNPK5)

             CALL       PGM(ALBR12)
             CLRPFM     FILE(ALBWP11)

/*           CALL       PGM(ALBR13) PARM(' ' &PER)                   */

 SEND:       DLTDTAARA  DTAARA(ALBTUR)
             MONMSG     MSGID(CPF2105)

 END:        ENDPGM

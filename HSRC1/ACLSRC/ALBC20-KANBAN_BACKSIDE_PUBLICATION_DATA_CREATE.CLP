             PGM
             /** ALBC20 ************************************/
             /* KANBAN BACKSIDE PUBLICATION DATA CREATE    */
             /*  (TX-1304)                                 */
             /*  DATE (CODING):K.OKACHI        1997.05.07  */
             /************************************ ALBC20 **/
             DCL        VAR(&REC) TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)


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

             CLRPFM     FILE(HWFILE1/ALBWP20)
             CLRPFM     FILE(HWFILE1/ALBWP11)

             CALL       PGM(ALBR20) PARM(&PM)


             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/ALBWP11) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(SEND))

             CHKOBJ     OBJ(ALBNPK5) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(HWFILE1/ALBNPK5) RCDLEN(130) +
                          TEXT('TOPICS RECIEVE KANBAN BACKSIDE DATA +
                          <TV> ') OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) AUT(*ALL))
             CLRPFM     FILE(ALBNPK5)

             CALL       PGM(ALBR12)
 SEND:       DLTDTAARA  DTAARA(ALBTUR)
             MONMSG     MSGID(CPF2105)

 END:        ENDPGM

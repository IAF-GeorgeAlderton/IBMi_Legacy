             PGM
             /** ADAC30 **************************/
             /*  UNWORKING NIGHT ATTENDANCE KANBAN HANDLING   */
             /************************** ADAC30 **/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CODE)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&DATA)  TYPE(*CHAR) LEN(150)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PARM7) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM8) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM9) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM10) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PARM11) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SAKUDT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SAKUNO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TENSO) TYPE(*CHAR) LEN(1) VALUE('Y')
             DCL        VAR(&RETRY) TYPE(*CHAR) LEN(1) VALUE('N')
/* TCHK1 */  DCL        VAR(&POUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(&WLIB/ADAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))
 STP2:       SNDPGMMSG  MSG('( G ) TEMPORARINESS. FORMER NIGHT DUTY +
                          KANBAN HANDLING SYSTEM IS ACTIVE, WAIT +
                          FOR A WHILE...') TOMSGQ(&WSNO) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP2))
             GOTO       END

 STP1:       CRTDTAARA  DTAARA(&WLIB/ADAACT) TYPE(*CHAR) LEN(10) +
                          TEXT('UNWORKING NIGHT ATTENDANCE.KANBAN +
                          HANDL SYS ACTIVE')

             CHGJOB     OUTQ(&PRTG) RUNPTY(40) LOGCLPGM(*YES)
             CHGVAR     VAR(&PARM1) VALUE(' ')
             CHGVAR     VAR(&PARM2) VALUE('00000000')
             CHGVAR     VAR(&PARM3) VALUE('00000000')
             CHGVAR     VAR(&PARM4) VALUE(' ')
             CHGVAR     VAR(&PARM5) VALUE(' ')
             CHGVAR     VAR(&PARM6) VALUE('000000')
             CHGVAR     VAR(&PARM7) VALUE('00000000')
             CHGVAR     VAR(&PARM8) VALUE('00000000')
             CHGVAR     VAR(&PARM9) VALUE(' ')
             CHGVAR     VAR(&PARM10) VALUE('000000')
             CHGVAR     VAR(&PARM11) VALUE(' ')

             CLRPFM     FILE(ADAWP30)
             MONMSG     MSGID(CPF3142 CPF3141)
             CLRPFM     FILE(ADAWPB1)
             MONMSG     MSGID(CPF3142 CPF3141)

             CALL       PGM(ADAR30) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5 &PARM6 &PARM7 &PARM8 &PARM9 &PARM10 +
                          &PARM11 &TENSO &RETRY &SAKUDT &SAKUNO &POUTQ)


 SEND:       DLTDTAARA  DTAARA(&WLIB/ADAACT)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM

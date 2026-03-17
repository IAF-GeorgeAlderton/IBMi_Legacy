             PGM
/** ADAC30 *************************************************/
/*  UNWORKING NIGHT ATTENDANCE KANBAN HANDLING             */
/*                                                         */
/* TCHK1 12/30/09 ADD OUTQ                                 */
/* TCHK2 02/26/10 BUG FIX                                  */
/************************************************* ADAC30 **/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CODE)  TYPE(*CHAR) LEN(2)
/* TCHK1 */  DCL        VAR(&DATA)  TYPE(*CHAR) LEN(200)
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

             IF  (&PARM1 *EQ  '*') DO
             CLRPFM     FILE(ADAWP30)
             MONMSG     MSGID(CPF3142 CPF3141)
             GOTO       SEND
             ENDDO

             /*THIS TIME DATA CREATE FROM LAST TIME DATA */
             IF      (&RETRY   *EQ 'Y')  DO
             CLRPFM     FILE(ADAWP30)
             MONMSG     MSGID(CPF3142 CPF3141)
             CALL       PGM(ADAR3A) PARM(&PARM6 &PARM7 &PARM8 &PARM9 +
                          &PARM10 &PARM11 &SAKUDT &SAKUNO)
             ENDDO
             /* CREATE INFORMATION WRITE */
             IF         COND(&RETRY *EQ 'N') THEN(DO)
             IF         COND(&TENSO *EQ 'N') THEN(DO)
             CALL       PGM(ADAR3B) PARM(&PARM6 &PARM7 &PARM8 &PARM9 +
                          &PARM10 &PARM11 &SAKUDT &SAKUNO)
             ENDDO
             ENDDO
             /*        */
             CHGVAR     VAR(&DATA) VALUE('CALL PGM(ADACJ3) PARM(''' +
                          *CAT &PARM1 *CAT ''' ''' *CAT &PARM2 *CAT +
                          ''' ''' *CAT &PARM3 *CAT ''' ''' *CAT +
                          &PARM4 *CAT ''' ''' *CAT &PARM5 *CAT ''' +
                          ''' *CAT &PARM6 *CAT ''' ''' *CAT &PARM7 +
                          *CAT ''' ''' *CAT &PARM8 *CAT ''' ''' +
                          *CAT &PARM9 *CAT ''' ''' *CAT &PARM10 +
                          *CAT ''' ''' *CAT &PARM11 *CAT ''' ''' +
                          *CAT &WSNO *CAT ''' ''' *CAT &USER *CAT +
                          ''' ''' *CAT &TENSO *CAT ''' ''' *CAT +
                          &RETRY *CAT ''' +
                          ''' *CAT &POUTQ *CAT ''' +
                                       )')

             SBMJOB     JOB(JOBQ2) JOBD(QBATCH2) JOBQ(JOBQ2) +
                          RTGDTA(*JOBD) RQSDTA(&DATA) INLLIBL(*JOBD)
             GOTO       END

 SEND:       DLTDTAARA  DTAARA(&WLIB/ADAACT)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM

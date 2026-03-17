             PGM
             /*= AJAC02 ===========================================*/
             /*  ..WEEKLY OPERATION..                              */
             /*    J.WATANBE        2018.01.05                     */
             /*  ADD JOB TO QGPL/@QSTRUP (AFTER IPL)               */
             /*                                                    */
             /*  JW   2018.08.06 ADD CHKR19 (GET QUICK IPL FLAG)   */
             /*====================================================*/

             DCL        VAR(&FLG) TYPE(*CHAR) LEN(1)

/*******************************************************************/
/* JW  SKIP ALL PROCESS FOR QUICK IPL                              */
             CALL       PGM(CHKR19) PARM(&FLG)
             IF         COND(&FLG = 'Y') THEN(GOTO CMDLBL(ENDP))
/*******************************************************************/

 /* SAVE OUTQ (CMDOUTQ) */
             DLTOBJ     OBJ(QUSRSYS/CMDOUTQSV) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF2105)

             CRTSAVF    FILE(QUSRSYS/CMDOUTQSV) TEXT('save CMDOUTQ')
             MONMSG     MSGID(CPF5813)

             SAVOBJ     OBJ(CMDOUTQ ) LIB(QUSRSYS) DEV(*SAVF) +
                          OBJTYPE(*OUTQ) SAVF(QUSRSYS/CMDOUTQSV) +
                          SPLFDTA(*ALL)
             MONMSG     MSGID(CPA4067)

 /* CLROUTQ */
             CLROUTQ    OUTQ(QUSRSYS/CMDOUTQ)
             MONMSG     MSGID(CPF0000)

 /* CLRLIB  */
             CLRLIB     LIB(WEEKDLT)
             MONMSG     MSGID(CPF0000)

 /* DLTEXPSPLF*/
             DLTEXPSPLF
             MONMSG     MSGID(CPF0000)

 /* CLEAR FRS LIST WORK FILE */
             CALL       PGM(AB#C0Y)
             MONMSG     MSGID(CPF0000)

 /* RGZPGM GCQPP31 */
             RGZPFM     FILE(GCQPP31)
             MONMSG     MSGID(CPF0000)

ENDP:
             ENDPGM

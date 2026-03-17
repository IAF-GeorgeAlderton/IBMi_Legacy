             PGM
             /** EDIC20 ************************************/
             /* IAF ONE WAY KANBAN PUBLICATION             */
             /*       CREATE DATE : SEP/17/1997.           */
             /*       AUTHOR      : K.OKACHI.              */
             /*       N.HYOTO 2001.02.08                   */
             /**********************************************/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGJOB     SWS(00000000)

 STP1:       CHKOBJ     OBJ(EDIC10ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP3))

 STP2:       SNDPGMMSG  MSG('( G ) ONE WAY KANBAN DATA CREATE.WAIT +
                          FOR A WHILE') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP2))
             GOTO       EXT

 STP3:       CRTDTAARA  DTAARA(EDIC10ACT) TYPE(*CHAR) LEN(10) +
                          TEXT('ONE WAY KANBAN DATA CREATE +
                          CHECK<TV>') AUT(*ALL)
             MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(STP1))

             CLRPFM     FILE(&WLIB/EDIWP10)
             CALL       PGM(EDIR20)

             IF         (%SWITCH(1XXXXXXX)) GOTO SEND

             CALL       PGM(EDIR11)

             DLTF       FILE(EDIWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/EDIWP11) RCDLEN(256) AUT(*ALL)
             FMTDTA     INFILE((&WLIB/EDIWP10)) +
                          OUTFILE(&WLIB/EDIWP11) SRCFILE(FMTSRC) +
                          SRCMBR(EDIS10) OPTION(*NOPRT)
             /* SEQ NO. UPDATE */
             CALL       PGM(EDIR12)
             /* DATA BACKUP FOR RE-PRINT */
             DLTF       FILE(&WLIB/EDIWP11BK)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/EDIWP11BK) RCDLEN(256) AUT(*ALL)
             CPYF       FROMFILE(&WLIB/EDIWP11) +
                          TOFILE(&WLIB/EDIWP11BK) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

 SEND:       DLTDTAARA  DTAARA(EDIC10ACT)
             MONMSG     MSGID(CPF2105)

 EXT:        ENDPGM

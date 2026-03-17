             PGM        PARM(&HIZU &PRT &US)
             /***MBECJ1********************************************/
             /*         FOR SALES TENTATIVE REPORT MONTHLY JOBQ OP-EDP */
             /*            M-OKUDA        1981.10.10              */
             /*****************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HIZU) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TP) TYPE(*CHAR) LEN(9)
             DCL        VAR(&AA) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&BB) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&CC) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&DD) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGVAR     VAR(&MM) VALUE(%SUBSTRING(&HIZU 5 2))

             CRTPF      FILE(HWFILE1/MBEWP11) RCDLEN(80) TEXT('SALES +
                          TENTATIVE REPORT WORK1') OPTION(*NOLIST) +
                          SIZE(200 100) LVLCHK(*NO)

             GRTOBJAUT  OBJ(MBEWP11) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             CALL       PGM(MBER11)

             CRTPF      FILE(HWFILE1/MBEWP12) RCDLEN(80) TEXT('SALES +
                          TENTATIVE REPORT WORK2') OPTION(*NOLIST) +
                          SIZE(200 100) LVLCHK(*NO)

             GRTOBJAUT  OBJ(MBEWP12) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             FMTDTA     INFILE((MBEWP11)) OUTFILE(MBEWP12) +
                          SRCFILE(FMTSRC) SRCMBR(MBES15) +
                          OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) RPLUNPRT(*YES) +
                          OUTQ(&PRT) FORMTYPE(K6S1) COPIES(1) +
                          FILESEP(0) IGCDTA(&PIGCD)
             CALL       PGM(MBER12) PARM(&HIZU)
             DLTOVR     FILE(QPRINT)
             DLTF       FILE(MBEWP11)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) RPLUNPRT(*YES) +
                          OUTQ(&PRT) FORMTYPE(K6H1) COPIES(1) +
                          FILESEP(0) IGCDTA(&PIGCD)
             CALL       PGM(MBER13) PARM(&HIZU &US)
             DLTOVR     FILE(QPRINT)
             DLTF       FILE(MBEWP12)

             CHGVAR     VAR(&AA) VALUE(%SUBSTRING(&HIZU 5 2))
             CHGVAR     VAR(&BB) VALUE(&AA / 2)
             CHGVAR     VAR(&CC) VALUE(&BB * 2)
             CHGVAR     VAR(&DD) VALUE(&AA - &CC)

             IF         (&DD *EQ 1) GOTO STEP01
             CHGVAR     VAR(&TP) VALUE('EVEN NUMBER MONTH')
             GOTO       STEP02

 STEP01:     CHGVAR     VAR(&TP) VALUE('ODD NUMBER MONTH')

 STEP02:     SNDPGMMSG  MSG('( G.B ) 01' *CAT &TP *CAT +
                          'SET SALES STATISTICS TAPE') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STEP03))
             IF         COND((&KOTAE = 'B') *OR (&KOTAE = 'b')) +
                          THEN(GOTO CMDLBL(STEP04))
             GOTO       STEP02

 STEP03:     INZTAP     DEV(TAPE1) NEWVOL(AOYAMA) CHECK(*NO)
             SAVOBJ     OBJ(MBEPP11) LIB(HFILE1) DEV(TAPE1) +
                          OBJTYPE(*FILE)

 STEP05:     SNDPGMMSG  MSG('( G ) 01 TAKE SALES STATISTICS TAPE +
                          OUT') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STEP04))
             GOTO       STEP05

 STEP04:     ENDPGM

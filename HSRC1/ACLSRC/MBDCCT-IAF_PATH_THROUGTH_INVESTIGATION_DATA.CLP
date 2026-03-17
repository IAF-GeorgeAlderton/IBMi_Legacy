             PGM
             /** MBDCCT *******************************************/
             /* IAF PATH THROUGTH INVESTIGATION DATA              */
             /*       K.HAYASHI           2011.07.20              */
             /*******************************COPY FORM    MBDCAT **/
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&MBAN)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)      TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&P1FYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&P1TYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&P1TOKU)   TYPE(*CHAR) LEN(4)

             DCL        VAR(&DFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WKAI) TYPE(*DEC) LEN(2)
             DCL        VAR(&FILE03) TYPE(*CHAR) LEN(10) VALUE(' ')

             CHGVAR     VAR(&FILE03) VALUE('MBDWPS4')

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)



             CHKOBJ     OBJ(MBDCCTACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))
 STP0:       SNDPGMMSG  MSG('( C +
                          )現在この処理を他のＴＶで使用中。') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE *NE 'C') GOTO STP0
             RETURN
             GOTO       @END2

 STP1:       CRTDTAARA  DTAARA(MBDCCTACT) TYPE(*CHAR) LEN(10) +
                          VALUE(&USER) AUT(*ALL)
 @GO:
             DLTF       FILE(&FILE03)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(MBDWPC1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWPC1) RCDLEN(1024) +
                          SIZE(5000000 10000)

             DLTF       FILE(MBDWPC2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWPC2) RCDLEN(1024) +
                          SIZE(5000000 10000)

             DLTF       FILE(MBDWPC3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWPC3) RCDLEN(1024) +
                          SIZE(5000000 10000)

             CALL       PGM(MBDRC1) PARM(&P1FYM &P1TYM &P1TOKU)

             FMTDTA     INFILE((HWFILE1/MBDWPC1)) +
                          OUTFILE(HWFILE1/MBDWPC2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(MBDSC2) +
                          OPTION(*NOPRT)

             CALL       PGM(MBDRC2) PARM(&P1FYM &P1TYM &P1TOKU)

 @END:
             DLTDTAARA  DTAARA(MBDCCTACT)
 @END2:      ENDPGM

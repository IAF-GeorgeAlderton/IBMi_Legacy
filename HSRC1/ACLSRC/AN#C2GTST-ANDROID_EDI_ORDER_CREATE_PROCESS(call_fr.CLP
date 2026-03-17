  PGM        PARM(&PSIRE &SELEC &RYYYY &RMMMM &RDDDD +
                  &SYYYY &SMMMM &SDDDD)
/** AN#C2G ************************************************/
/*  ANDROID EDI ORDER CREATE PROCESS                      */
/*                                                        */
/* TCHK1 07/12/06 CREATE(COPY FROM AB#C2G)                */
/**********************************************************/
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSIRK)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE4)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE5)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE6)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&SELEC)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&RYYYY)   TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&RMMMM)   TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&RDDDD)   TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&SYYYY)   TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&SMMMM)   TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&SDDDD)   TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&SR) VALUE('AN')
             CHGVAR     VAR(&FILE1) VALUE(AB#WP201 *CAT &SR)
             CHGVAR     VAR(&FILE2) VALUE(AB#WP202 *CAT &SR)
             CHGVAR     VAR(&FILE3) VALUE(AB#WP20 *CAT &SR)
             CHGVAR     VAR(&FILE4)  VALUE('MITANKF' *CAT &SR)
             CHGVAR     VAR(&FILE5) VALUE(AB#WP451 *CAT &SR)
             CHGVAR     VAR(&FILE6) VALUE(AB#WP452 *CAT &SR)

             DLTF       FILE(&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE5) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AB#WP451) TOFILE(&FILE5)

             CLRPFM     FILE(HWFILE1/ABWP455)

/* CREATE FRS           */
             IF         COND(&SELEC *EQ '6') THEN(DO)
       /* CREATE ABWP451 */
             CALL       PGM(AN#RF7F1) PARM(&RYYYY &RMMMM &RDDDD +
                                          &SYYYY +
                                          &SMMMM &SDDDD &PSIRE)
             IF         (%SWITCH(0XXXXXXX)) DO
  STP4:      SNDPGMMSG  MSG('( G ) EDI(862) ANDROID NO FRS ORDER EXIST +
                          < G-ENTER >') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&KOTAE) VALUE('G')
             GOTO       END
             ENDDO
                         GOTO STPA
             ENDDO

/* RE-CREATE FRS(NIRVANA) */
             IF         COND(&SELEC *EQ '7') THEN(DO)
             OVRPRTF    FILE(QPRINT2) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(AN#RFM) PARM(&RYYYY &RMMMM &RDDDD &SYYYY +
                          &SMMMM &SDDDD &PSIRE)
                         GOTO END
             ENDDO


   STPA:


             CPYF       FROMFILE(HWFILE1/ABWP455) +
                          TOFILE(HWFILE1/ABWP456) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

     /* DELETE PROCESS(FLAG 'D') */
             CALL       PGM(AN#RF7F2)

             CPYF       FROMFILE(HWFILE1/ABWP455) +
                          TOFILE(HWFILE1/ABWP457) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

     /* FROM ABWP451 TO AB#WP451) */
             CALL       PGM(AN#RF7F3)

             DLTF       FILE(&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE6) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FILE5))  +
                          OUTFILE(&WLIB/&FILE6) +
                          SRCFILE(FMTSRC) SRCMBR(AB#S45) +
                          OPTION(*NOPRT)

             DLTF       FILE(&FILE5)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP452) TOFILE(&FILE6)
             OVRDBF     FILE(AB#WP201) TOFILE(&FILE1)
             OVRPRTF    FILE(QPRINT) OUTQ(QDKT)
             CALL       PGM(AB#R451)
             DLTOVR     FILE(QPRINT)

/* TEST */   OVRDBF     FILE(AB#PL15) TOFILE(TFILE1/AB#PL15)
             CALL       PGM(AB#R45) PARM(&USER)


             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(FMTSRC) SRCMBR(AB#S26) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE3) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP20) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRPRTF    FILE(QPRINT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QDKT) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

             OVRDBF     FILE(AB#WP202) TOFILE(&FILE2)
             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             CALL       PGM(AB#R21) PARM(&PSIRE)

             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             CALL       PGM(AB#R22)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QDKT) FORMTYPE(K6H1)

             OVRPRTF    FILE(QPRINT2) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QDKT) FORMTYPE(K6H1)


             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
/* TEST */   OVRDBF     FILE(AU#NP11) TOFILE(TWFILE1/AU#NP11)
/* TEST */   OVRDBF     FILE(AU#PP11) TOFILE(TFILE1/AU#PP11)
             CALL       PGM(AB#R2J) PARM(&PSIRE)


             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE4) RCDLEN(300) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             OVRDBF     FILE(MITANKF) TOFILE(&FILE4)
             CALL       PGM(AB#R25) PARM(&PFLG)

             IF         (&PFLG *EQ '*') DO

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QDKT) FORMTYPE(K6H1)

             OVRDBF     FILE(MITANKF) TOFILE(&FILE4)
             CALL       PGM(AB#R26) PARM(&PSIRE)

             SNDPGMMSG  MSG('UNIT PRICES ARE NOT REGISTERED IN THE +
                          SALES UNIT PRICE MASTER FILES. UNIT PRICE +
                          MUST BE REGISTERED.') TOMSGQ(&WSID)
             ENDDO

             DLTOVR     FILE(*ALL)

 END:        ENDPGM

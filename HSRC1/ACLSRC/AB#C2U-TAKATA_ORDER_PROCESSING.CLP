             PGM        PARM(&PSIRE)
             /** AB#C2C *******************************************/
             /*  TAKATA ORDER PROCESSING                          */
             /*        2001.11.08                                 */
             /*  TCH    1/11/05 ADD TAKATA DEL RIO                */
             /*  TCHK1 01/13/06 CHG AB#R2Y TO AB#R2Y1             */
             /*  TCHK2 01/26/06 ADD CHECK PROD START DATE         */
             /*  TCHK3 02/08/06 ADD ABNORMAL LIST                 */
             /*  JW1   07/26/19 ADD MONCLOVA (TAKATA04)           */
             /*                 ADD TAKATA99 (SAVE FILE)          */
             /*****************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MBAN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE5)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE6)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CHK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER2) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

   /*JW*/    CHGVAR     VAR(&PRTG) VALUE('EPRINT1   ')

             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&SR) VALUE('T1')

             CHGVAR     VAR(&FILE1) VALUE(AB#WP201  *CAT &SR)
             CHGVAR     VAR(&FILE2) VALUE(AB#WP202  *CAT &SR)
             CHGVAR     VAR(&FILE3) VALUE(AB#WP20   *CAT &SR)
             CHGVAR     VAR(&FILE4) VALUE('MITANKF' *CAT &SR)
             CHGVAR     VAR(&FILE5) VALUE(AB#WP451  *CAT &SR)
             CHGVAR     VAR(&FILE6) VALUE(AB#WP452  *CAT &SR)

             DLTF       FILE(&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE5) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP451) TOFILE(&FILE5)
/* TAKATA01 3682 (ARIZONA) */
             CHKOBJ     OBJ(TAKATA01) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))
             OVRDBF     FILE(TAKATA01) TOFILE(TAKATA01)
             CALL       PGM(AB#R2U) PARM(&PSIRE '1')
      /*     CPYF       FROMFILE(TAKATA01) TOFILE(TAKATA99) +   */
      /*                  MBROPT(*ADD) FMTOPT(*NOCHK)           */
             DLTF       FILE(TAKATA01)

@SKP1:
/* TAKATA02 3712 (MEXICO) */
             CHKOBJ     OBJ(TAKATA02) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP2))
             OVRDBF     FILE(TAKATA01) TOFILE(TAKATA02)
             CALL       PGM(AB#R2U) PARM(&PSIRE '2')
       /*JW1 CALL       PGM(A#R2UX) PARM(&PSIRE '2') ***/
       /*    CPYF       FROMFILE(TAKATA02) TOFILE(TAKATA99) +   */
       /*                 MBROPT(*ADD) FMTOPT(*NOCHK)           */
             DLTF       FILE(TAKATA02)
@SKP2:
/* TAKATA03 3842 (DEL RIO) */
             CHKOBJ     OBJ(TAKATA03) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP3))
             OVRDBF     FILE(TAKATA01) TOFILE(TAKATA03)
             CALL       PGM(AB#R2U) PARM(&PSIRE '3')
       /*    CPYF       FROMFILE(TAKATA03) TOFILE(TAKATA99) +    */
       /*                 MBROPT(*ADD) FMTOPT(*NOCHK)            */
             DLTF       FILE(TAKATA03)
@SKP3:
/* TAKATA04 3714 (MONCLOVA) */
             CHKOBJ     OBJ(TAKATA04) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP9))
             OVRDBF     FILE(TAKATA01) TOFILE(TAKATA04)
             CALL       PGM(AB#R2U) PARM(&PSIRE '4')
        /*   CPYF       FROMFILE(TAKATA04) TOFILE(TAKATA99) +    */
        /*                MBROPT(*ADD) FMTOPT(*NOCHK)            */
             DLTF       FILE(TAKATA04)

@SKP9:
             IF         (%SWITCH(0XXXXXXX)) DO
 STP2:       SNDPGMMSG  MSG('( G )  NO TAKATA ORDER EXISTS < G-ENTER +
                          >') TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&KOTAE) VALUE('G')
             GOTO       END
             ENDDO

/* TCHK3 ORDER ABNORMAL LIST */
/* TCHK3 */  OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
/* TCHK3 */               OUTQ(&PRTG) FORMTYPE(K6H1)
/* TCHK3 */  CALL       PGM(AB#R2U1)
/* TCHK3 */
/* TCHK3 */
             DLTF       FILE(&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE6) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FILE5)) OUTFILE(&WLIB/&FILE6) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S45) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE5)

  /* CHECK */
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)
             OVRDBF     FILE(AB#WP452) TOFILE(&FILE6)

/* TCHK2 */  CALL       PGM(AB#R2Y1) PARM(&CHK)
             DLTOVR     FILE(QPRINT)

             IF         (&CHK *EQ '1') DO
             SNDPGMMSG  MSG('( G ) TAKATA ORDER HAS ERROR.+
                          NO UPDATE ANY FILES < G-ENTER +
                          >') TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&KOTAE) VALUE('G')
             GOTO       END
             ENDDO

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)


             OVRDBF     FILE(AB#WP452) TOFILE(&FILE6)
             OVRDBF     FILE(AB#WP201) TOFILE(&FILE1)
             OVRPRTF    FILE(QPRINT) OUTQ(&PRTG) /* TCHK1 */
/* TCHK1 */  CALL       PGM(AB#R451)
/* TCHK1 */  DLTOVR     FILE(QPRINT)

/*JW*/       OVRPRTF    FILE(QPRINT)  OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT2) OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT5) OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT6) OUTQ(EPRINT1) HOLD(*YES)

/* &USER2 = &USER + ID(=S) - ORDER ENTRY ID=SHEET   JW */
             CHGVAR     VAR(&USER2) VALUE(&USER)
             CHGVAR     VAR(%SST(&USER2 10 1)) VALUE('S')

             CALL       PGM(AB#R45) PARM(&USER2)

             IF         (%SWITCH(X0XXXXXX)) DO
 STP3:       SNDPGMMSG  MSG('( G ) TAKATA ORDER ORDER HAS BEEN +
                          PROCESSED  < G-ENTER >') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&KOTAE) VALUE('G')
             GOTO       END
             ENDDO

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S22) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE3) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP20) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
 /*JW*/      OVRPRTF    FILE(QPRINT2) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

             OVRDBF     FILE(AB#WP202) TOFILE(&FILE2)
             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             CALL       PGM(AB#R21) PARM(&PSIRE)

             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             CALL       PGM(AB#R22)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
      /***   CALL       PGM(AB#R23) PARM(&PSIRE)     ****/

             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE4) RCDLEN(300) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             OVRDBF     FILE(MITANKF) TOFILE(&FILE4)
             CALL       PGM(AB#R25) PARM(&PFLG)

             IF         (&PFLG *EQ '*') DO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

             OVRDBF     FILE(MITANKF) TOFILE(&FILE4)
             CALL       PGM(AB#R26) PARM(&PSIRE)

             SNDPGMMSG  MSG('UNIT PRICES ARE NOT REGISTERED IN THE +
                          SALES UNIT PRICE MASTER FILES. UNIT PRICE +
                          MUST BE REGISTERED.') TOMSGQ(&WSID)
             ENDDO

             DLTOVR     FILE(*ALL)
  END:
             ENDPGM

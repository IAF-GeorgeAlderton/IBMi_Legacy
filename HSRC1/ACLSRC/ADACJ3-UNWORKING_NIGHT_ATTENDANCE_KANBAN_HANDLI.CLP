             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5 +
                          &PARM6 &PARM7 &PARM8 &PARM9 &PARM10 &PARM11 +
                          &WSNO &USER &TENSO &RETRY &POUTQ)
             /** ADACJ3 *****************************************/
             /*   UNWORKING  NIGHT ATTENDANCE KANBAN HANDLING   */
             /*                                                 */
             /*                                                 */
             /*   N.HYOTO PRINT TO QPRINTA,NOT HOLD             */
             /*   CHANGE DATE:2001.06.21   MSK.KUNIEDA          */
             /*                                                 */
             /* 2004.03.08                                      */
             /*   SEND SPOOLFILE TO AOYAMA                      */
             /* 2004.03.23                                      */
             /*   ADD WASHER/WIRE INFORMATION                   */
             /*                                                 */
             /* TCHK1 12/30/09 ADD &POUTQ                       */
             /* TCHK2 02/18/11 ADD &POUTQ & RELEASE             */
             /* TCHK3 04/12/11 CHG ADAPR53 SAVE(*YES)           */
             /***************************************** ADACJ3 **/

             DCL        VAR(&USER)      TYPE(*CHAR)  LEN(10)
             DCL        VAR(&WSNO)      TYPE(*CHAR)  LEN(10)
             DCL        VAR(&PRT)       TYPE(*CHAR)  LEN(7)
             DCL        VAR(&TYPE)      TYPE(*CHAR)  LEN(1)
             DCL        VAR(&PRTG)      TYPE(*CHAR)  LEN(10)
             DCL        VAR(&MBAN)      TYPE(*CHAR)  LEN(4)
             DCL        VAR(&KOTE)      TYPE(*CHAR)  LEN(1)
             DCL        VAR(&CODE)      TYPE(*CHAR)  LEN(2)
             DCL        VAR(&PARM1)     TYPE(*CHAR)  LEN(1)
             DCL        VAR(&PARM2)     TYPE(*CHAR)  LEN(8)
             DCL        VAR(&PARM3)     TYPE(*CHAR)  LEN(8)
             DCL        VAR(&PARM4)     TYPE(*CHAR)  LEN(1)
             DCL        VAR(&PARM5)     TYPE(*CHAR)  LEN(1)
             DCL        VAR(&PARM6)     TYPE(*CHAR)  LEN(6)
             DCL        VAR(&PARM7)     TYPE(*CHAR)  LEN(8)
             DCL        VAR(&PARM8)     TYPE(*CHAR)  LEN(8)
             DCL        VAR(&PARM9)     TYPE(*CHAR)  LEN(1)
             DCL        VAR(&PARM10)    TYPE(*CHAR)  LEN(6)
             DCL        VAR(&PARM11)    TYPE(*CHAR)  LEN(1)
             DCL        VAR(&IN80)      TYPE(*CHAR)  LEN(1)
             DCL        VAR(&IN81)      TYPE(*CHAR)  LEN(1)
             DCL        VAR(&IN82)      TYPE(*CHAR)  LEN(1)
             DCL        VAR(&IN83)      TYPE(*CHAR)  LEN(1)
             DCL        VAR(&TENSO)     TYPE(*CHAR)  LEN(1)
             DCL        VAR(&ADADATE)   TYPE(*CHAR)  LEN(8)
             DCL        VAR(&TEHIB)     TYPE(*CHAR)  LEN(8)
             DCL        VAR(&RETRY)     TYPE(*CHAR)  LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHK1)     TYPE(*CHAR)  LEN(1)
             DCL        VAR(&CHK2)     TYPE(*CHAR)  LEN(1)
/* TCHK1 */  DCL        VAR(&POUTQ)    TYPE(*CHAR)  LEN(10)

             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)
             RTVDTAARA  DTAARA(ADADATE) RTNVAR(&ADADATE)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)

             CHGJOB     OUTQ(&PRTG)
             CHGJOB     SWS(10000000)

     /* 930517  DOESN'T USE IT */
             GOTO  PAS01
     /*                 */

    /* CANCEL DATE SETTING M/F CRT 'LAST TIME ' */
             CHKOBJ  OBJ(OBAWP53) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP01)) /* +
                          APPLICABLE FILE NO EXIST */
             GOTO STEP02
 STEP01:     CRTPF      FILE(&WLIB/OBAWP53) RCDLEN(30) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
STEP02:      CALL       PGM(ADAR35) PARM(&PARM1 &PARM2 &ADADATE)

PAS01:       DLTF       FILE(ADAWP31)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3129)

             IF         (&PARM5  *EQ 'A')  DO
             CHGJOB     SWS(01000000)
             ENDDO
             IF         (&PARM5  *EQ 'B')  DO
             CHGJOB     SWS(01000000)
             ENDDO
             IF         (&PARM5  *EQ 'E')  DO
             CHGJOB     SWS(00100000)
             ENDDO

             CRTPF      FILE(&WLIB/ADAWP31) RCDLEN(32) +
                          OPTION(*NOLIST) SIZE(200000 20000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ADAR31) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5 &PARM6 &PARM7 &PARM8 &PARM9 &PARM10 +
                          &PARM11)
             CLRPFM     FILE(ADAWP30)

             DLTF       FILE(ADAWL31)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWL31) RCDLEN(32) +
                          OPTION(*NOLIST) SIZE(200000 20000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(ADAWP32)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWP32) RCDLEN(32) +
                          OPTION(*NOLIST) SIZE(20000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

             IF  (&PARM5 *NE 'E')  DO
             FMTDTA     INFILE((&WLIB/ADAWP31)) +
                          OUTFILE(&WLIB/ADAWL31) SRCFILE(FMTSRC) +
                          SRCMBR(ADAS30) OPTION(*NOPRT)

             CALL       PGM(ADAR32) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5 &PARM6 &PARM7 &PARM8 &PARM9 +
                          &PARM10 &PARM11)
             ENDDO
             ELSE DO

             FMTDTA     INFILE((&WLIB/ADAWP31)) +
                          OUTFILE(&WLIB/ADAWL31) SRCFILE(FMTSRC) +
                          SRCMBR(ADAS32) OPTION(*NOPRT)

             CALL       PGM(ADAR36) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5 &PARM6 &PARM7 &PARM8 &PARM9 +
                          &PARM10 &PARM11)
             ENDDO

    /*       DLTF FILE(ADAWP31) */

             DLTF       FILE(ADAWL31)

             DLTF       FILE(ADAWP34)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWP34) RCDLEN(32) +
                          OPTION(*NOLIST) SIZE(20000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ADAWP32)) +
                          OUTFILE(&WLIB/ADAWP34) SRCFILE(FMTSRC) +
                          SRCMBR(ADAS30) OPTION(*NOPRT)
             DLTF       FILE(ADAWP32)

             DLTF       FILE(ADAWP40)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWP40) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(ADAWP41)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWP41) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(ADAWP42)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWP42) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(ADAWP43)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWP43) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(ADAWP44)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWP44) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)

             CHKOBJ     OBJ(ADAWP50) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(CRT01)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(ADAWP50)
             GOTO       S01
 CRT01:      CRTPF      FILE(&WLIB/ADAWP50) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(*FILE) OPTION(*NOLIST) SIZE(10000 +
                          1000) LVLCHK(*NO) AUT(*ALL)

 S01:        CHKOBJ     OBJ(ADAWP51) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(S02)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(ADAWP51)
             GOTO       STEP10
 S02:        CRTPF      FILE(&WLIB/ADAWP51) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(*FILE) OPTION(*NOLIST) SIZE(10000 +
                          1000) LVLCHK(*NO) AUT(*ALL)

 STEP10:     CHKOBJ     OBJ(ADAWP60) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(S03)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(ADAWP60)
             GOTO S04
 S03:        CRTPF      FILE(&WLIB/ADAWP60) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ADAWP60) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

 S04:        CHKOBJ     OBJ(ADAWP52) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(S05)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(ADAWP52)
             GOTO S06
 S05:        CRTPF      FILE(&WLIB/ADAWP52) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ADAWP52) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

/* MSK 2001.06.21 --*/

 S06:        CHKOBJ     OBJ(ADAWP55) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(S07)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(ADAWP55)
             GOTO S08
 S07:        CRTPF      FILE(&WLIB/ADAWP52) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ADAWP52) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

/*------------------*/

 S08:        CHGVAR     VAR(&IN80) VALUE('0')
             CHGVAR     VAR(&IN81) VALUE('0')
             CHGVAR     VAR(&IN82) VALUE('0')
             CHGVAR     VAR(&IN83) VALUE('0')

             CALL       PGM(ADAR33) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5 &PARM6 &PARM7 &PARM8 &PARM9 &PARM10 +
                          &PARM11 &IN80 &IN81 &IN82 &IN83)
    /* DLTF FILE(ADAWP34)                    */
/*- MSK 2001.06.21 SETINNG ORDER DATE -------*/

             CALL       PGM(ADAR5B) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5 &PARM6 &PARM7 &PARM8 &PARM9 &PARM10 +
                          &PARM11 &TENSO)

/*- MSK 2001.06.21 SETINNG ORDER BIN --------*/

             CALL       PGM(ADAR50) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5 &PARM6 &PARM7 &PARM8 &PARM9 &PARM10 +
                          &PARM11 &TENSO &USER)
/*-------------------------------------------*/
    /* CLRPFM FILE(ADAWP50) */

             CALL       PGM(ADAR5Z) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5 &PARM6 &PARM7 &PARM8 &PARM9 &PARM10 +
                          &PARM11 &TENSO)

             CHKOBJ     OBJ(ADAWP53) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CRT02)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(ADAWP53)
             GOTO       STEP12
 CRT02:      CRTPF      FILE(&WLIB/ADAWP53) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(*FILE) OPTION(*NOLIST) SIZE(10000 +
                          1000) LVLCHK(*NO) AUT(*ALL)

 STEP12:     CALL       PGM(ADAR5A)

             IF         (&TENSO *EQ 'Y') DO

             CALL       PGM(ADAR51) PARM(&PARM1 &PARM2 &PARM3 &USER)

             CALL       PGM(ADAR5X) PARM(&PARM1 &PARM2 &PARM3 &USER)
             CALL       PGM(ADAR5Y) PARM(&PARM1 &PARM2 &PARM3 &USER)

/* TCHK1     OVRPRTF    FILE(ADAPR53) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6S1) HOLD(*YES) */
/* TCHK3     OVRPRTF    FILE(ADAPR53) PAGESIZE(66 80) LPI(6) +
   TCHK1                  RPLUNPRT(*YES) OUTQ(&POUTQ)  +
                          FORMTYPE(K6S1) */
/* TCHK3 */  OVRPRTF    FILE(ADAPR53) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUTQ)  +
                          FORMTYPE(K6S1) SAVE(*YES)
             CALL       PGM(ADAR53) PARM(&PARM1 &PARM2)

       /* OVRPRTF FILE(ADAPR5W) LPI(6) RPLUNPRT(*YES) + */
       /*                 OUTQ(&PRTG) FORMTYPE(K6S1) HOLD(*YES) */
       /* CALL PGM(ADAR5W) PARM(&PARM1 &PARM2)                   */

             CPYF       FROMFILE(ADAWP60) TOFILE(ADAPP60) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
    /* CANCEL DATE SETTING M/F CRT 'THIS TIME ' */
             CHKOBJ     OBJ(OBAWP53) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEPA1)) /* +
                          APPLICABLE FILE NO EXIST */
             GOTO       STEPA2
 STEPA1:     CRTPF      FILE(&WLIB/OBAWP53) RCDLEN(30) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
STEPA2:      CHGJOB     SWS(01000000)
     /*930517*/
     /* CALL PGM(ADAR35) PARM(&PARM1 &PARM2 &ADADATE) */
     /* CHGDTAARA DTAARA(ADADATE) VALUE(&PARM2)                  */
     /*******/

             CLRPFM     FILE(ADAWP60)
             ENDDO

             ELSE                DO

/* TCHK1     OVRPRTF    FILE(ADAPR53) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6S1) HOLD(*YES) */
/* TCHK3     OVRPRTF    FILE(ADAPR53) PAGESIZE(66 80) LPI(6) +
   TCHK1                  RPLUNPRT(*YES) OUTQ(&POUTQ)  +
                          FORMTYPE(K6S1) */
/* TCHK3 */  OVRPRTF    FILE(ADAPR53) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUTQ)  +
                          FORMTYPE(K6S1) SAVE(*YES)
             CALL       PGM(ADAR53) PARM(&PARM1 &PARM2)

    /* OVRPRTF FILE(ADAPR5W) LPI(6) RPLUNPRT(*YES) + */
    /*                    OUTQ(&PRTG) FORMTYPE(K6S1) HOLD(*YES) */
    /* CALL PGM(ADAR5W) PARM(&PARM1 &PARM2)                      */

    /* DLTF FILE(ADAWP60) */
             ENDDO

          /*------- TUNNEL -----------------------------------------*/
             IF         (&IN82 *EQ '0') DO
             DLTF       FILE(ADAWP42)
             DLTF       FILE(ADAWL42)
             MONMSG     MSGID(CPF3261 CPF2105)
             ENDDO
             ELSE       DO

             DLTF       FILE(ADAWL42)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ADAWL42) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ADAWP42)) +
                          OUTFILE(&WLIB/ADAWL42) SRCFILE(FMTSRC) +
                          SRCMBR(ADAS42) OPTION(*NOPRT)
             DLTF       FILE(ADAWP42)

/* TCHK1     OVRPRTF    FILE(ADAPR40) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6S1) HOLD(*YES) */
/* TCHK1 */  OVRPRTF    FILE(ADAPR40) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUTQ)  +
                          FORMTYPE(K6S1)
             CALL       PGM(ADAR40) PARM(&PARM1 &PARM2)
             GOTO       HIKTO
             ENDDO

          /*-------- PICK-UP ----------------------------------------*/
 HIKTO:      IF         (&IN83 *EQ '0') DO
             DLTF       FILE(ADAWP43)
             DLTF       FILE(ADAWL43)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             ENDDO
             ELSE       DO

             DLTF       FILE(ADAWL43)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWL43) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ADAWP43)) +
                          OUTFILE(&WLIB/ADAWL43) SRCFILE(FMTSRC) +
                          SRCMBR(ADAS43) OPTION(*NOPRT)
             DLTF       FILE(ADAWP43)

/* TCHK1     OVRPRTF    FILE(ADAPR41) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6S1) HOLD(*YES) */
/* TCHK1 */  OVRPRTF    FILE(ADAPR41) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUTQ)  +
                          FORMTYPE(K6S1)
             CALL       PGM(ADAR41) PARM(&PARM1 &PARM2)

             GOTO       MEKI
             ENDDO

          /*------- PLATING -------------------------------------------*/
 MEKI:       IF         (&IN81 *EQ '0') DO
             DLTF       FILE(ADAWP41)
             DLTF       FILE(ADAWL41)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             ENDDO
             ELSE       DO

             DLTF       FILE(ADAWL41)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWL41) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ADAWP41)) +
                          OUTFILE(&WLIB/ADAWL41) SRCFILE(FMTSRC) +
                          SRCMBR(ADAS41) OPTION(*NOPRT)
             DLTF       FILE(ADAWP41)

/* TCHK1     OVRPRTF    FILE(ADAPR42) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6S1) HOLD(*YES) */
/* TCHK1 */  OVRPRTF    FILE(ADAPR42) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUTQ)  +
                          FORMTYPE(K6S1)
             CALL       PGM(ADAR42) PARM(&PARM1 &PARM2)

             GOTO       KOU
             ENDDO

          /*------ PURCHASING-----------------------------------------*/
 KOU:        IF         (&IN80 *EQ '0') DO
             DLTF       FILE(ADAWP40)
             DLTF       FILE(ADAWL40)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             ENDDO
             ELSE       DO

             DLTF       FILE(ADAWL40)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWL40) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ADAWP40)) +
                          OUTFILE(&WLIB/ADAWL40) SRCFILE(FMTSRC) +
                          SRCMBR(ADAS40) OPTION(*NOPRT)
             DLTF       FILE(ADAWP40)

/* TCHK2     OVRPRTF    FILE(ADAPR43) DEVTYPE(*SCS) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1) HOLD(*YES) */
/* TCHK2 */  OVRPRTF    FILE(ADAPR43) DEVTYPE(*SCS) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&POUTQ) +
                          FORMTYPE(K6H1) HOLD(*YES)
             CALL       PGM(ADAR43) PARM(&PARM1 &PARM2)

   /* SEND SPLF TO AOYAMA */
         /*  SNDNETSPLF FILE(ADAPR43) TOUSRID((V0033 SYSTEM1)) +      */
         /*               JOB(&NBR/&USR/&JOB) SPLNBR(*LAST)           */
         /*  SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE SYSTEM1)) + */
         /*               MBR(ADATJ3)                                 */
         /*  MONMSG     MSGID(CPF0000)                                */

/* TCHK2 */  RLSSPLF    FILE(ADAPR43) JOB(&NBR/&USER/&JOB) +
                          SPLNBR(*LAST)
/* TCHK2 */  MONMSG     MSGID(CPF0000)

             GOTO       ERRS
             ENDDO

          /*------ ERROR -------------------------------------------*/
 ERRS:       DLTF       FILE(ADAWL44)
             MONMSG     MSGID(CPF3261 CPF2105 CPF3219)
             CRTPF      FILE(&WLIB/ADAWL44) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ADAWP44)) +
                          OUTFILE(&WLIB/ADAWL44) SRCFILE(FMTSRC) +
                          SRCMBR(ADAS44) OPTION(*NOPRT)
             DLTF       FILE(ADAWP44)

             OVRPRTF    FILE(ADAPR44) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6S1) HOLD(*YES)
             CALL       PGM(ADAR44) PARM(&PARM1 &PARM2)

 /* WASHER/MATERIAL */
             CRTDUPOBJ  OBJ(ADAWP61) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ADAWP62) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM QTEMP/ADAWP61
             CLRPFM QTEMP/ADAWP62
             OVRDBF     FILE(ADAWP61) TOFILE(QTEMP/ADAWP61)
             OVRDBF     FILE(ADAWP62) TOFILE(QTEMP/ADAWP62)

/* TCHK2     OVRPRTF    FILE(ADAPR5C) DEVTYPE(*SCS) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1) HOLD(*YES) */
/* TCHK2     OVRPRTF    FILE(ADAPR5D) DEVTYPE(*SCS) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1) HOLD(*YES) */
/* TCHK2 */  OVRPRTF    FILE(ADAPR5C) DEVTYPE(*SCS) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&POUTQ) +
                          FORMTYPE(K6H1) HOLD(*YES)
/* TCHK2 */  OVRPRTF    FILE(ADAPR5D) DEVTYPE(*SCS) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&POUTQ) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(ADAR5C) PARM(&PARM2 &CHK1 &CHK2)

             IF         COND(&CHK1 *EQ '1') THEN(DO)
        /*   SNDNETSPLF FILE(ADAPR5C) TOUSRID((V0034 SYSTEM1)) +  */
        /*                JOB(&NBR/&USR/&JOB) SPLNBR(*LAST)       */

/* TCHK2 */  RLSSPLF    FILE(ADAPR5C) JOB(&NBR/&USER/&JOB) +
                          SPLNBR(*LAST)
/* TCHK2 */  MONMSG     MSGID(CPF0000)

             ENDDO

             IF         COND(&CHK2 *EQ '1') THEN(DO)
/*           SNDNETSPLF FILE(ADAPR5D) TOUSRID((V0033 SYSTEM1)) +  */
/*                        JOB(&NBR/&USR/&JOB) SPLNBR(*LAST)       */

/* TCHK2 */  RLSSPLF    FILE(ADAPR5D) JOB(&NBR/&USER/&JOB) +
                          SPLNBR(*LAST)
/* TCHK2 */  MONMSG     MSGID(CPF0000)

             ENDDO

          /*---------------------------------------------------------*/
      /* DLTF FILE(ADAWP4C)                       */
      /* MONMSG MSGID(CPF3261 CPF2105) */
 END:        DLTDTAARA  DTAARA(ADAACT)
             DLTOVR     FILE(*ALL)

             ENDPGM

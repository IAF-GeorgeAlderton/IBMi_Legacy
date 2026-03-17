             PGM
             /** ABACP5 ******************************************/
             /*PRODUCT DEMAND FORECAST (FROM GENTRAN AS/400)     */
             /* JW5    2018.05.04 ADD ERROR REPORT TO SEND EMAIL */
             /*                   DLT COMMENT LINE               */
             /******************************** ABACP5 ************/
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&ABBDS1) TYPE(*CHAR) LEN(54)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&BHIZ)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYMD)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&WYMD)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC1)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&REC3)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&AYM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&REC)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC2)   TYPE(*DEC) LEN(10 0)
             DCL        VAR(&OK)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&ER)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&ER2)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PSIGO) TYPE(*CHAR) LEN(1) VALUE('0')
/* %0001 */  DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
/* TCHK3 */  DCL        VAR(&REC4)   TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RECS)   TYPE(*DEC) LEN(10 0)

/* TCHK4 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK4 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK4 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVJOBA    JOB(&WSID) USER(&USR) NBR(&NBR)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USR  &WLIB)

             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&PYMD)

             CHGVAR     VAR(&BHIZ) VALUE(%SST(&ABADS1 1 6))

             CHGVAR     VAR(%SST(&WYMD 3 6)) VALUE(&PYMD)
             CHGVAR     VAR(%SST(&WYMD 1 2)) VALUE('19')
             IF         (%SST(&WYMD 3 2) *LT '97') DO
             CHGVAR     VAR(%SST(&WYMD 1 2)) VALUE('20')
             ENDDO

             CHGVAR     VAR(&AYM) VALUE(%SST(&WYMD 1 6))

             CALL       PGM(ABAR01) PARM(&AYM)

             IF         COND(%SST(&ABADS1 1 6) *GE &AYM) THEN(GOTO +
                          CMDLBL(SAP1))

             CHGVAR     VAR(%SST(&ABADS1 7 42)) +
                          VALUE('000000000000000000000000000000000000+
                          000000')
             CHGDTAARA  DTAARA(ABADS1) VALUE(&ABADS1)

             CHGVAR     VAR(%SST(&ABBDS1 27 1)) VALUE(' ')
             CHGDTAARA  DTAARA(ABBDS1) VALUE(&ABBDS1)

 SAP1:
             OVRPRTF    FILE(QPRINT ) OUTQ(EPRINT1) FORMTYPE(K6H1) +
                          HOLD(*YES) /*JW*/

/* TCHK1 */  CLRPFM     FILE(&WLIB/ABAWP50)
/* TCHK1 */  OVRDBF     FILE(ABAWL52) TOFILE(&WLIB/ABAWL52)
/* TCHK1 */
/*JW*/       OVRPRTF    FILE(QPRINTS) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1 ) FORMTYPE(K6H1) HOLD(*YES) +
                          SAVE(*YES)

/*JW*/      OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(EPRINT1 ) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CLRPFM     FILE(ABAEP25)
             CLRPFM     FILE(ABAWP2H)
             MONMSG     MSGID(CPF0000)

/* JW1 2016.03.25 ADDED: SAVE ABAEP10/20          */
          /* CALL       PGM(EDSR20)  */

       /*JW5 CALL       PGM(ABAR1A) PARM(&REC &ER)  */
             CALL       PGM(ABAR1A) PARM(&REC &ER &ER2)

  /* JW5 SEND ERROR REPORT (QPRINT) ----------------------- */
             IF         COND(&ER2 *EQ '1') THEN(DO)
             CPYSPLF    FILE(QPRINT ) TOFILE(&WLIB/PRT132A) +
                          JOB(&NBR/&USR/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(&WLIB/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((KAZ.WATANABE@iafi.com)) +
                          DSTD('EDI830 FORECAST SHIPPING MASTER +
                          ERROR LIST ') MSG('Please check +
                          "(FORECAST SHIPPING MASTER ERROR LIST" +
                          (ABACP5)') DOCFILE(&WLIB/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('EDI830 +
                          FORECAST SHIP MASTER ERROR')
             DLTOVR     FILE(PRT132)

             RLSSPLF    FILE(QPRINT ) JOB(&NBR/&USR/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO
  /* JW5 END ---------------------------------------------- */
             DLTF       FILE(QTEMP/ABAWP42)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP42) RCDLEN(300) +
                          OPTION(*NOLIST) SIZE(15000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABAWP42) TOFILE(QTEMP/ABAWP42)

             DLTF       FILE(QTEMP/ABAWP25)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP25) RCDLEN(300) +
                          OPTION(*NOLIST) SIZE(15000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABAWP25) TOFILE(QTEMP/ABAWP25)

             CALL       PGM(ABAR1B) PARM(&AYM)

             CALL       PGM(ABAR1C)
             DLTF       FILE(QTEMP/ABAWP25)

  /*  ABAWP72 */
             DLTF       FILE(QTEMP/ABAWP72)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP72) RCDLEN(384) +
                          OPTION(*NOLIST) SIZE(1000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(QTEMP/ABAWL72)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWL72) RCDLEN(384) +
                          OPTION(*NOLIST) SIZE(1000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

  /*  ABAWP32 */
             DLTF       FILE(QTEMP/ABAWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP32) RCDLEN(37) +
                          OPTION(*NOLIST) SIZE(20000 20000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             /* 2002.06.19  */
/* TCHK5 E */

             CALL       PGM(ABAR32) PARM(&PSIGO &AYM &BHIZ)


 @END:

             ENDPGM

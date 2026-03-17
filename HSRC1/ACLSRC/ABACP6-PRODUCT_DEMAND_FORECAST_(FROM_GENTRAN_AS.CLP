             PGM        PARM(&SIRE)
             /** ABACP5 ******************************************/
             /*PRODUCT DEMAND FORECAST (FROM GENTRAN AS/400)     */
             /*                                                  */
             /* TCHK1 02/13/14 ADD PRICE CHECK LIST              */
             /* JW1   2021.02.18 CHG AB#R0D --> AB#R0D2          */
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
             DCL        VAR(&SIRE)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&AYM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&REC1)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&PSIGO) TYPE(*CHAR) LEN(1) VALUE('0')

             RTVJOBA    JOB(&WSID) USER(&USR)
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
             IF         COND(&USR *EQ 'TEST' *OR &USR *EQ +
                          'EDITEST') THEN(DO)
             OVRPRTF    FILE(QPRINT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTD) +
                          FORMTYPE(K6H1)
                          ENDDO
                          ELSE DO
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1)
                          ENDDO

             OVRPRTF    FILE(QPRINTS) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) HOLD(*YES)

             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)


             DLTF       FILE(QTEMP/ABAWP42)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP42) RCDLEN(318) +
                          OPTION(*NOLIST) SIZE(15000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABAWP42) TOFILE(QTEMP/ABAWP42)
             DLTF       FILE(QTEMP/ABAWP25)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP25) RCDLEN(318) +
                          OPTION(*NOLIST) SIZE(15000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABAWP25) TOFILE(QTEMP/ABAWP25)
             CALL       PGM(ABAR1J) PARM(&SIRE &AYM)

             CALL       PGM(ABAR1C)
   /**JW***  DLTF       FILE(QTEMP/ABAWP25)   ***/

             IF         ((%SST(&ABADS1 1 6)) *GT &AYM) GOTO STP24
             IF         (&BHIZ *EQ &AYM) GOTO STP1

             CALL       PGM(ABAR31) PARM(&AYM)
             CALL       PGM(ABBR03) PARM(&AYM)

 STP1:
             CHGVAR     VAR(&PSIGO) VALUE('1')

 STP24:      IF         ((%SST(&ABADS1 1 6)) *LE &AYM) GOTO STP25
             CHGVAR     VAR(&PSIGO) VALUE('1')
 STP25:      CHGJOB     SWS(00000000)


             /*  A.INOUE    2002.06.19  */
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

             DLTF       FILE(QTEMP/ABAWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP32) RCDLEN(37) +
                          OPTION(*NOLIST) SIZE(20000 20000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             /* 2002.06.19  */

/* TCHK1 S */
             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/MITANKF
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
/* TCHK1 E */

             CALL       PGM(ABAR32) PARM(&PSIGO &AYM &BHIZ '6')

/* JW1 SAVE ABAWP42 */
             CPYF       FROMFILE(QTEMP/ABAWP42) +
                          TOFILE(*LIBL/ABAWP42S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)
             CALL       PGM(SAVR01) PARM('6')

     /**JW** DLTF       FILE(QTEMP/ABAWP42)    **/

/* TCHK1 S */
             CHGVAR     VAR(&REC1) VALUE('0')
             RTVMBRD    FILE(QTEMP/MITANKF) NBRCURRCD(&REC1)
             IF         COND(&REC1 *NE 0) THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT50) +
                          FORMTYPE(K6H1) HOLD(*NO) IGCDTA(&PIGCD)
/*JW1*/
       /**** CALL       PGM(AB#R0D) ****/
             CALL       PGM(AB#R0D2)

             ENDDO
/* TCHK1 E */
             /*  A.INOUE    2002.06.19  */
             RTVMBRD    FILE(QTEMP/ABAWP32) NBRCURRCD(&REC1)
             IF         COND(&REC1 *NE 0) THEN(DO)

             ENDDO
             DLTF       FILE(QTEMP/ABAWP32)
             /*              */
             RTVMBRD    FILE(QTEMP/ABAWP72) NBRCURRCD(&REC1)

             IF         COND(&REC1 *NE 0) THEN(DO)
             FMTDTA     INFILE((QTEMP/ABAWP72)) +
                          OUTFILE(QTEMP/ABAWL72) SRCFILE(FMTSRC) +
                          SRCMBR(ABAS72) OPTION(*NOPRT)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(FORECAST) FORMTYPE(K6H1) HOLD(*YES) +
                          SAVE(*YES)
             CALL       PGM(ABAR72) PARM(&AYM)
             DLTOVR     FILE(QPRINT)

     /*      OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1) HOLD(*NO) */
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) HOLD(*YES) +
                          SAVE(*YES)

             CALL       PGM(ABAR72) PARM(&AYM)
             DLTOVR     FILE(QPRINT)
             ENDDO

             DLTF       FILE(QTEMP/ABAWP72)
             DLTF       FILE(QTEMP/ABAWL72)
             /*  END A.INOUE    2002.06.19  */

             /*--------------------------------------------*/

             CHGVAR     VAR(%SST(&ABADS1 1 6)) VALUE(&AYM)
  @LOP1:
             CHGDTAARA  DTAARA(ABADS1) VALUE(&ABADS1)
             MONMSG     MSGID(CPF1063) EXEC(GOTO CMDLBL(@LOP1))

 @END:

             ENDPGM

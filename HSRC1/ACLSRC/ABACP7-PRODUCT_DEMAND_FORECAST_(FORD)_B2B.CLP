             PGM
             /** ABACP7 ******************************************/
             /*PRODUCT DEMAND FORECAST (FORD) B2B                */
             /*                                                  */
             /*       02/13/17   T.SAKAKI                        */
             /* JW1   2021.02.17 ADD SAVE ABAWP42                */
             /******************************** ABACP7 ************/
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&ABBDS1) TYPE(*CHAR) LEN(54)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&BHIZ)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYMD)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&WYMD)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC1)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&REC2)   TYPE(*DEC) LEN(10 0)
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&AYM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PSIGO) TYPE(*CHAR) LEN(1) VALUE('0')

             RTVJOBA    JOB(&WSID) USER(&USR) NBR(&NBR)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC01) PARM(&USR &PLIB &WLIB)

             OVRDBF     FILE(AGDPP11) TOFILE(&PLIB/A@DPP11)
             OVRDBF     FILE(AGDPL11) TOFILE(&PLIB/A@DPL11)
             OVRDBF     FILE(AGDPL12) TOFILE(&PLIB/A@DPL12)

             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&PYMD)

             CHGVAR     VAR(&BHIZ) VALUE(%SST(&ABADS1 1 6))

             CHGVAR     VAR(%SST(&WYMD 3 6)) VALUE(&PYMD)
             CHGVAR     VAR(%SST(&WYMD 1 2)) VALUE('19')
             IF         (%SST(&WYMD 3 2) *LT '97') DO
             CHGVAR     VAR(%SST(&WYMD 1 2)) VALUE('20')
             ENDDO

             CHGVAR     VAR(&AYM) VALUE(%SST(&WYMD 1 6))

     /* CHECK ACCUMULATION DATE */
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

 /* FORD */
       /* EBAEP10,EBAEP11 -> ABFPP10, ABFPP20, ABFPP30 */
       /*                 -> EBAEP25 */
             CALL       PGM(EBAC1E) PARM(&REC2)

             IF         COND(&REC2 *EQ 0) THEN(GOTO CMDLBL(@END))

             DLTF       FILE(QTEMP/ABAWP42)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP42) RCDLEN(318) +
                          OPTION(*NOLIST) SIZE(15000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/ABAWP25)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP25) RCDLEN(318) +
                          OPTION(*NOLIST) SIZE(15000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABAWP25) TOFILE(QTEMP/ABAWP25)
             OVRDBF     FILE(ABAWP42) TOFILE(QTEMP/ABAWP42)

     /* EBAEP25 -> ABAWP25 */
             CALL       PGM(EBAR1B) PARM(&AYM)

     /* ABAWP25 -> ABAWP42 */
             CALL       PGM(ABAR1C)
             DLTF       FILE(QTEMP/ABAWP25)

             IF         ((%SST(&ABADS1 1 6)) *GT &AYM) GOTO STP24
             IF         (&BHIZ *EQ &AYM) GOTO STP1

     /* KANBAN M/F UPDATE  */
             CALL       PGM(ABAR31) PARM(&AYM)

     /* ABAWP10 -> ABBPP01 */
             CALL       PGM(ABBR03) PARM(&AYM)

 STP1:
             CHGVAR     VAR(&PSIGO) VALUE('1')

 STP24:      IF         ((%SST(&ABADS1 1 6)) *LE &AYM) GOTO STP25
             CHGVAR     VAR(&PSIGO) VALUE('1')
 STP25:      CHGJOB     SWS(00000000)

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

             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/MITANKF
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)

     /* ABAWP42 -> MITANKF */
     /*         -> ABAWP72 */
     /*         -> ABAWP32 */
             CALL       PGM(ABAR32) PARM(&PSIGO &AYM &BHIZ '7')

/* JW1 SAVE ABAWP42 BEFORE DELTE */
             CPYF       FROMFILE(QTEMP/ABAWP42) +
                          TOFILE(*LIBL/ABAWP42S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)
             CALL       PGM(SAVR01) PARM('7')

             DLTF       FILE(QTEMP/ABAWP42)

 /* UNIT PRICE ERROR */
             CHGVAR     VAR(&REC1) VALUE('0')
             RTVMBRD    FILE(QTEMP/MITANKF) NBRCURRCD(&REC1)

             IF         COND(&REC1 *NE 0) THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(EPRINT1) +
                          FORMTYPE(K6H1) HOLD(*YES) IGCDTA(&PIGCD)
 /* JW1 **** CALL       PGM(AB#R0D) *****/
             CALL       PGM(AB#R0D2)

             CPYSPLF    FILE(QPRINT) TOFILE(&WLIB/PRT132B) +
                          JOB(&NBR/&USR/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(&WLIB/PRT132B)
             CALL       PGM(AB#RW0)
             SNDDST     TYPE(*FILE) TOINTNET((SalesGroup@iafi.com) +
                          (*NONE *CC)) DSTD('Unit Price Not +
                          Registered') MSG('** ERROR ** Unit price +
                          is not registered for Forecast Order +
                          Part. Please check the attached +
                          report.(ABACP7).') DOCFILE(&WLIB/PRT132B) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('EDI +
                          Forecast Unit Price Not Registered')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(PRT132)

             ENDDO

             DLTF       FILE(QTEMP/ABAWP32)

             CHGVAR     VAR(&REC1) VALUE('0')
             RTVMBRD    FILE(QTEMP/ABAWP72) NBRCURRCD(&REC1)

             IF         COND(&REC1 *NE 0) THEN(DO)
             FMTDTA     INFILE((QTEMP/ABAWP72)) +
                          OUTFILE(QTEMP/ABAWL72) SRCFILE(FMTSRC) +
                          SRCMBR(ABAS72) OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) SAVE(*YES)
     /* ABAWL72 -> QPRINT */
             CALL       PGM(ABAR72) PARM(&AYM)
             DLTOVR     FILE(QPRINT)

             ENDDO

             DLTF       FILE(QTEMP/ABAWP72)
             DLTF       FILE(QTEMP/ABAWL72)

             CHGVAR     VAR(%SST(&ABADS1 1 6)) VALUE(&AYM)
  @LOP1:
             CHGDTAARA  DTAARA(ABADS1) VALUE(&ABADS1)
             MONMSG     MSGID(CPF1063) EXEC(GOTO CMDLBL(@LOP1))
  @LOP2:
             CHGDTAARA  DTAARA(ABBDS1) VALUE(&ABBDS1)
             MONMSG     MSGID(CPF1063) EXEC(GOTO CMDLBL(@LOP2))

  @END:
             ENDPGM

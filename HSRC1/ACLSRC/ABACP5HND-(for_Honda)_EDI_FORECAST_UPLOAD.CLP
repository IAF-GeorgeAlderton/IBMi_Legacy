             PGM
             /** ABACP5 ******************************************/
             /*  (FOR HONDA) EDI FORECAST UPLOAD                 */
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
             DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&REC4)   TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RECS)   TYPE(*DEC) LEN(10 0)

             OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

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
                          HOLD(*YES)

             CLRPFM     FILE(&WLIB/ABAWP50)
             OVRDBF     FILE(ABAWL52) TOFILE(&WLIB/ABAWL52)

             OVRPRTF    FILE(QPRINTS) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1 ) FORMTYPE(K6H1) HOLD(*YES) +
                          SAVE(*YES)

            OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(EPRINT1 ) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CLRPFM     FILE(ABAEP25)
             CLRPFM     FILE(ABAWP2H)
             MONMSG     MSGID(CPF0000)

/* JW1 2016.03.25 ADDED: SAVE ABAEP20 HONDA      ***/
/***         CALL       PGM(EDSR20)              ***/

/* JW6 2020.08.17 ADDED: ADJUST ABAEP20 HONDA    ***/
/***         CALL       PGM(ABAR02)              ***/

             CALL       PGM(ABAR1A) PARM(&REC &ER &ER2)

/* SEND ERROR REPORT (QPRINTS) Q/C ERROR ------------ */
/***         IF         COND(&ER *EQ '3') THEN(DO)                   ***/
/***         CPYSPLF    FILE(QPRINTS) TOFILE(&WLIB/PRT132A) +        ***/
/***                      JOB(&NBR/&USR/&WSID) SPLNBR(*LAST)         ***/
/***         OVRDBF     FILE(PRT132) TOFILE(&WLIB/PRT132A)           ***/
/***         CALL       PGM(AB#RW0)                                  ***/
/***                                                                 ***/
/***         SNDDST     TYPE(*FILE) +                                ***/
/***                      TOINTNET((Production_Control@iafi.com)) +  ***/
/***                      DSTD('EDI 830 Quantity/container +         ***/
/***                      difference.') MSG('There is quantity +     ***/
/***                      difference in EDI 830(forecast) data. +    ***/
/***                      Please check the attached list.(ABACP5).') + ***/
/***                      DOCFILE(&WLIB/PRT132A) DOCTYPE(*FFT) +     ***/
/***                      SNDFMT(*NOTE) DOCD('EDI 830 Qty/cont. +    ***/
/***                      difference')                               ***/
/***         DLTOVR     FILE(PRT132)                                 ***/
/***                                                                 ***/
/***         RLSSPLF    FILE(QPRINTS) JOB(&NBR/&USR/&WSID) +         ***/
/***                      SPLNBR(*LAST)                              ***/
/***         MONMSG     MSGID(CPF0000)                               ***/
/***         ENDDO                                                   ***/

/* JW5 SEND ERROR REPORT (QPRINT) SHIP MASTER ----------- */
/***         IF         COND(&ER2 *EQ '1') THEN(DO)                  ***/
/***         CPYSPLF    FILE(QPRINT ) TOFILE(&WLIB/PRT132A) +        ***/
/***                      JOB(&NBR/&USR/&WSID) SPLNBR(*LAST)         ***/
/***         OVRDBF     FILE(PRT132) TOFILE(&WLIB/PRT132A)           ***/
/***         CALL       PGM(AB#RW0)                                  ***/
/***                                                                 ***/
/***         SNDDST     TYPE(*FILE) +                                ***/
/***                      TOINTNET((Production_Control@iafi.com)) +  ***/
/***                      DSTD('EDI830 FORECAST SHIPPING MASTER +    ***/
/***                      ERROR LIST ') MSG('** SHIPPING MASTER +    ***/
/***                      ERROR ** Please set up Shipping Master +   ***/
/***                      ASAP. (ABACP5).') DOCFILE(&WLIB/PRT132A) + ***/
/***                      DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('EDI830 + ***/
/***                      FORECAST SHIP MASTER ERROR')               ***/
/***         DLTOVR     FILE(PRT132)                                 ***/
/***                                                                 ***/
/***         RLSSPLF    FILE(QPRINT ) JOB(&NBR/&USR/&WSID) +         ***/
/***                      SPLNBR(*LAST)                              ***/
/***         MONMSG     MSGID(CPF0000)                               ***/
/***         ENDDO                                                   ***/
  /* JW5 END ---------------------------------------------- */

             DLTOVR     FILE(QPRINT2)
             DLTOVR     FILE(QPRINTS)

 /* %0001 VW DELFOR */
 /* VW */
 /***        RTVMBRD    FILE(HFILE1/ABVEP21) NBRCURRCD(&KEN)         ***/
 /***        IF         COND(&KEN *GT 0) THEN(DO)                    ***/
 /***        CALL       PGM(ABVRE5)                                  ***/
 /***                                                                ***/
 /* JW4 2017.07.06 ADDED:                   */
 /***        CALL       PGM(ABBC42)                                  ***/
 /***                                                                ***/
 /* JW2 2017.04.17 ADDED: SAVE ABVEP21/22   */
 /***        CALL       PGM(EDSR2V)                                  ***/
 /***                                                                ***/
 /***        ENDDO                                                   ***/

 /* GM TEXT MESSAGE */
 /***        RTVMBRD    FILE(ABAEP30) NBRCURRCD(&REC3)               ***/
 /***        IF         COND(&REC3 *NE 0) THEN(DO)                   ***/
 /***        OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +         ***/
 /***                     OUTQ(EPRINT1 ) FORMTYPE(K6H1) HOLD(*YES)   ***/
 /***                                                                ***/
 /***        CALL       PGM(ABAR1H)                                  ***/
 /***        CPYSPLF    FILE(QPRINT) TOFILE(&WLIB/PRT132) +          ***/
 /***                     JOB(&NBR/&USR/&WSID) SPLNBR(*LAST)         ***/
 /***        OVRDBF     FILE(PRT132) TOFILE(&WLIB/PRT132)            ***/
 /***                                                                ***/
 /***        CALL       PGM(AB#RW0)                                  ***/
 /***                                                                ***/
 /***        SNDDST     TYPE(*FILE) +                                  ***/
 /***                     TOINTNET((Production_Control@iafi.com)) +    ***/
 /***                     DSTD('EDI Forecast text message') MSG('We +  ***/
 /***                     have received text messages for Forecast +   ***/
 /***                Data. Please check the attached list.(ABACP5).') + ***/
 /***                     DOCFILE(&WLIB/PRT132) DOCTYPE(*FFT) +         ***/
 /***                     SNDFMT(*NOTE) DOCD('EDI Forecast text +       ***/
 /***                     messages')                                    ***/
 /***        DLTOVR     FILE(PRT132)                                    ***/
 /***        DLTOVR     FILE(QPRINT)                                    ***/
 /***                                                                   ***/
 /***        ENDDO                                                      ***/
 /* FORD */
 /***        DLTOVR     FILE(QPRINT)                                    ***/
 /***        MONMSG     MSGID(CPF0000)                                  ***/

/* TCHK3 */
/* TCHK3 ANDROID */
/* TCHK3 */  CALL       PGM(ANAC1E) PARM(&REC4)

/* %0004  REMOVE FROM LINE 193 **/

/* TCHK3 */  IF         COND(&REC *EQ ' ' *AND              +
/* TCHK3 */                  &REC4 *EQ 0)                   +
/* TCHK3 */               THEN(GOTO CMDLBL(@END))
/* TCHK3 */

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

             IF         ((%SST(&ABADS1 1 6)) *GT &AYM) GOTO STP24
             IF         (&BHIZ *EQ &AYM) GOTO STP1

             CALL       PGM(ABAR31) PARM(&AYM)

    /* %0003 T.SAKAKI */
             CPYF       FROMFILE(HFILE1/ABBPP01) +
                          TOFILE(HFILE1/ABBPP01@SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
             SNDMSG     MSG('TOOK BACK UP ABBPP01@SV') TOMSGQ(V#IS1)

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

/* TCHK5 S */
             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/MITANKF
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
/* TCHK5 E */

             CALL       PGM(ABAR32) PARM(&PSIGO &AYM &BHIZ '5')

/* JW3 SAVE ABAWP42 */
             CPYF       FROMFILE(QTEMP/ABAWP42) +
                          TOFILE(*LIBL/ABAWP42S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)
             CALL       PGM(SAVR01) PARM('5')

             DLTF       FILE(QTEMP/ABAWP42)
/* TCHK5 S */
             CHGVAR     VAR(&REC1) VALUE('0')
             RTVMBRD    FILE(QTEMP/MITANKF) NBRCURRCD(&REC1)

 /* UNIT PRICE ERROR */
 /***        IF         COND(&REC1 *NE 0) THEN(DO)                    ***/
 /***        OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +         ***/
 /***                     RPLUNPRT(*YES) OUTQ(EPRINT1) +              ***/
 /***                     FORMTYPE(K6H1) HOLD(*YES) IGCDTA(&PIGCD)    ***/
 /***        CALL       PGM(AB#R0D2)                                  ***/
 /***                                                                 ***/
 /***        CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +        ***/
 /***                     JOB(&NBR/&USR/&WSID) SPLNBR(*LAST)          ***/
 /***        OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)          ***/
 /***        CALL       PGM(AB#RW0)                                   ***/
 /***        SNDDST     TYPE(*FILE) TOINTNET((SalesGroup@iafi.com) +  ***/
 /***                     (*NONE *CC)) DSTD('Unit Price Not +         ***/
 /***                     Registered') MSG('** Unit Price Error ** +  ***/
 /***                     Please Register Unit Price ! Please +       ***/
 /***                     Confirm Attached EDI Forecast. +            ***/
 /***                     (ABACP5).') DOCFILE(HWFILE1/PRT132B) +      ***/
 /***                     DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('EDI +     ***/
 /***                     Forecasts Unit Price Not Registered')       ***/
 /***        MONMSG     MSGID(CPF0000)                                ***/
 /***        DLTOVR     FILE(PRT132)                                  ***/
 /***                                                                 ***/
 /***        ENDDO                                                    ***/
/* TCHK5 E */
             /*  A.INOUE    2002.06.19  */
             CHGVAR     VAR(&REC1) VALUE('0')
             RTVMBRD    FILE(QTEMP/ABAWP32) NBRCURRCD(&REC1)
             IF         COND(&REC1 *NE 0) THEN(DO)

             ENDDO
             DLTF       FILE(QTEMP/ABAWP32)
             /*              */
             CHGVAR     VAR(&REC1) VALUE('0')
             RTVMBRD    FILE(QTEMP/ABAWP72) NBRCURRCD(&REC1)

             IF         COND(&REC1 *NE 0) THEN(DO)
             FMTDTA     INFILE((QTEMP/ABAWP72)) +
                          OUTFILE(QTEMP/ABAWL72) SRCFILE(FMTSRC) +
                          SRCMBR(ABAS72) OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) SAVE(*YES)
             CALL       PGM(ABAR72) PARM(&AYM)
             DLTOVR     FILE(QPRINT)

             ENDDO

             DLTF       FILE(QTEMP/ABAWP72)
             DLTF       FILE(QTEMP/ABAWL72)
             /*  END A.INOUE    2002.06.19  */

             /*--------------------------------------------*/
             /* ..FROM USER PRODUCT DEMAND FORECAST DATA.. */
             /* ..FORECAST DATA INPUT                      */
             /*--------------------------------------------*/
             CALL       PGM(ABBC61) PARM(&AYM)

             CHGVAR     VAR(%SST(&ABADS1 1 6)) VALUE(&AYM)
  @LOP1:
             CHGDTAARA  DTAARA(ABADS1) VALUE(&ABADS1)
             MONMSG     MSGID(CPF1063) EXEC(GOTO CMDLBL(@LOP1))

  /* TMMC,TMMI,TMMK PROCESSING CHECK */
             CALL       PGM(ABAR1D) PARM(&AYM &OK)
             IF         COND(&OK *EQ '1') THEN(DO)
             CHGVAR     VAR(%SST(&ABBDS1 27 1)) VALUE('Y')
  @LOP2:
             CHGDTAARA  DTAARA(ABBDS1) VALUE(&ABBDS1)
             MONMSG     MSGID(CPF1063) EXEC(GOTO CMDLBL(@LOP2))
             ENDDO

/* if new ship to codes for Honda were found, call pgm to email list     */
   /***      RTVMBRD    FILE(HWFILE1/ABAWP2H) NBRCURRCD(&RECS)         ***/
   /***      IF         COND(&RECS *GT 0) THEN(DO)                     ***/
   /***      CALL       PGM(ABAC0M)                                    ***/
   /***      ENDDO                                                     ***/

 @END:

             ENDPGM

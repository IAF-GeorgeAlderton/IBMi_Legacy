 PGM
/** AB#C0A ************************************************/
/*    EDI ORDER PROCESSING (GENTRAN)                      */
/*                                                        */
/* TCHK1 11/11/05 CHG E-MAIL DST GROUPE                   */
/* TCHK2 01/26/06 ADD CHECK PROD START DATE               */
/* TCHK3 08/29/06 ADD ANDROID PROCESS                     */
/* TCHK4 11/22/06 ADD PISTON ROUTINE                      */
/* TCHK5 05/23/17 ADD TOWER ROUTINE                       */
/* TCHK6 06/12/09 ADD TEMPORARY CHANGE CALENDAR M/F       */
/* TCHK7 02/01/11 ADD TMS ORDER CHECK PGM                 */
/* TCHK8 06/21/12 ADD PISTON NEW ROUTINE                  */
/* TCHK9 11/05/13 ADD VW                                  */
/* JW1   02/18/16 ADD SAVE AB#EP40 TO AB#EP40S            */
/* %0001 08/04/16 CHANGE LIST TO E-MAIL    BY TUCKER      */
/* JW2   11/02/16 CHECK 0 RECORD OF QPRINT                */
/* %0002 06/23/17 MIGRATE FORD 862 TO B2B                 */
/* JW3   07/24/19 ADD CHECK ORDER REPORT                  */
/* JW3   03/17/20 SAVE AB#WP451                           */
/* JW4   01/05/21 CHG  OVRDBF TOFILE(HWFILE1/PRT132A)     */
/* JW5   04/07/21 CHG  AB#R0B'S PARAMETER                 */
/* LEC   09/02/21 ADD CREATE TOYOTA EDI WORKFILE-->SQL01  */
/* JW6   10/15/21 SAV  AB#WP452 TO AB#WP452SV             */
/* JW6   10/31/24 ADD SAVR07 (SAVE AB#WP451 TO AB#PP2T)   */
/* JW7   12/08/25 ADD AB#RED (ADJUST HOLLINGSWORTH 5211)  */
/**********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&KEN)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PSPO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ID)   TYPE(*CHAR) LEN(1)
/* TCHK7 */  DCL        VAR(&PRUN) TYPE(*CHAR) LEN(1)
/* JW2   */  DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)
/* JW4   */  DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

/* TCHK6 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK6 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK6 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)

             DLTF       FILE(QTEMP/AB#WP451)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP451) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP452)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP452) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP2A) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(QTEMP/AB#EP4T)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#EP4T) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#EP4T

   /*  CREATE TOYOTA EDI WORKFILE    */
             DLTF       FILE(QTEMP/AB#WP15)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(AB#WP15) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(AB#WP15) TOFILE(QTEMP/AB#WP15)

        /* JW1 2016.02.18 ADDED: SAVE AB#EP40 TO AB#EP40S */
             CALL       PGM(EDSR40)

        /* JW7 2025.12.08 ADDED: ADJUST QTY FOR 5211      */
             CALL       PGM(AB#RED)

        /* JW  2024.10.23 ADDED: AB#EP40 REPORT           */
             CALL       PGM(EDSC40P)

             OVRDBF     FILE(AB#EP4T) TOFILE(QTEMP/AB#EP4T)

             OVRDBF     FILE(AB#WP451) TOFILE(QTEMP/AB#WP451)
             OVRDBF     FILE(AB#WP2A) TOFILE(QTEMP/AB#WP2A)
             CALL       PGM(AB#R0A)

  /* JW6 SAVE AB#WP451 */
             CALL       PGM(SAVR07)

  /* JW3 SAVE AB#WP451 */
             CPYF       FROMFILE(QTEMP/AB#WP451) +
                          TOFILE(HWFILE1/AB#WP451SV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

  /* RDB  -->  SQL01 */
             RTVMBRD    FILE(QTEMP/AB#WP15)  NBRCURRCD(&REC)
             IF         COND(&REC *GT 0) THEN(DO)
                                          ADDLIBLE RDB50
                                          MONMSG MSGID(CPF0000)
                                          CALL  PGM(RDBR15)
                                          CALL  PGM(EDSR15)
                                          RMVLIBLE RDB50
                                          MONMSG MSGID(CPF0000)
                                         ENDDO
  /* GM */
             RTVMBRD    FILE(AB#EP20) NBRCURRCD(&KEN)
             IF         COND(&KEN *GT 0) THEN(DO)
             CALL       PGM(AB#R0Q)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) SAVE(*YES)

             CALL       PGM(AB#RE3) PARM(&PSPO)
             IF         COND(&PSPO *EQ '1') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)


             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)

             IF         COND(&USER *NE 'TEST') THEN(DO)
/* TCHK1 S */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI862SpecialOrderGM@iafi.com)) +
                          DSTD('GM-SPO order information') MSG('We +
                          received the order information from +
                          GM-SPO. Please check the attached +
                          list.(AB#C0A).') DOCFILE(HWFILE1/PRT132) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('GM-SPO +
                          order information')
             ENDDO
/* TCHK1 E */
             ENDDO
             DLTOVR     FILE(QPRINT)
             ENDDO

  /* VW */
             RTVMBRD    FILE(HFILE1/ABVEP20) NBRCURRCD(&KEN)
             IF         COND(&KEN *GT 0) THEN(DO)
             CALL       PGM(ABVRE3)
             ENDDO

             IF         COND(%SWITCH(0XXXXXXX)) THEN(GOTO CMDLBL(END))

/* TCHK4 */  DLTF       FILE(QTEMP/AB#WP453)
/* TCHK4 */  MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP453) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL) /* TCHK4 */
/* TCHK4 */
/* TCHK4 */  DLTF       FILE(QTEMP/AB#WP454)
/* TCHK4 */  MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP454) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL) /* TCHK4 */
/* TCHK4 */
/* TCHK5 */  DLTF       FILE(QTEMP/AB#WP455)
/* TCHK5 */  MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP455) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL) /* TCHK5 */
/* TCHK5 */
/* TCHK8 */  DLTF       FILE(QTEMP/AB#WP456)
/* TCHK8 */  MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP456) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL) /* TCHK8 */
/* TCHK8 */
/* TCHK4 */  FMTDTA     INFILE((QTEMP/AB#WP451)) +
/* TCHK4 */               OUTFILE(QTEMP/AB#WP453) +
/* TCHK4 */               SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S45) +
/* TCHK4 */               OPTION(*NOPRT)
             DLTF       FILE(QTEMP/AB#WP451)
/* TCHK4 */
/* TCHK4 */  OVRDBF     FILE(AB#WP453) TOFILE(QTEMP/AB#WP453)
/* TCHK4 */  OVRDBF     FILE(AB#WP454) TOFILE(QTEMP/AB#WP454)
/* TCHK5 */  OVRDBF     FILE(AB#WP455) TOFILE(QTEMP/AB#WP455)
/* TCHK8 */  OVRDBF     FILE(AB#WP456) TOFILE(QTEMP/AB#WP456)
/* TCHK4 */
/* TCHK4 */  CALL       PGM(AB#R452)
/* TCHK5 */  CALL       PGM(AB#R453)
/* TCHK8 */  CALL       PGM(AB#R455)
/* TCHK4 */
/* TCHK5 */ /* TCHK4 FMTDTA     INFILE((QTEMP/AB#WP454)) + */
/* TCHK8 */ /* TCHK5 FMTDTA     INFILE((QTEMP/AB#WP455)) + */
/* TCHK8 */  FMTDTA     INFILE((QTEMP/AB#WP456)) +
/* TCHK4 */               OUTFILE(QTEMP/AB#WP452) +
/* TCHK4 */               SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S45) +
/* TCHK4 */               OPTION(*NOPRT)

             DLTF       FILE(QTEMP/AB#WP201)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP201) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

/* TCHK2 */  OVRDBF     FILE(AB#WP452) TOFILE(QTEMP/AB#WP452)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT50) HOLD(*YES) +
                          SAVE(*YES) /* TCHK2 */
/* TCHK2 */  CALL       PGM(AB#R451)
/* TCHK2 */  DLTOVR     FILE(QPRINT)
/* TCHK2 */
        /*   OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ)   */
        /*   OVRPRTF    FILE(QPRINT2) OUTQ(SAVEOUTQ)  */
        /*   OVRPRTF    FILE(QPRINT6) OUTQ(SAVEOUTQ)  */

/*JW*/       OVRPRTF    FILE(QPRINT)  OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT2) OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT5) OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT6) OUTQ(EPRINT1) HOLD(*YES)

             OVRDBF     FILE(AB#WP452) TOFILE(QTEMP/AB#WP452)
             OVRDBF     FILE(AB#WP201) TOFILE(QTEMP/AB#WP201)
             CALL       PGM(AB#R45) PARM(&USER)

/*JW6 SAVE AB#WP452  */
             CPYF       FROMFILE(QTEMP/AB#WP452) +
                          TOFILE(HWFILE1/AB#WP452SV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

    /* QTY DIFFERENT  */
             IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)
             CPYSPLF    FILE(QPRINT2) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

      /****  OVRDBF     FILE(PRT132) TOFILE(PRT132A)   ***/
/*JW4*/      OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)

             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)

             IF         COND(&USER *NE 'TEST') THEN(DO)
/* TCHK1 */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDIOrderQuantityDifference@iafi.c+
                          om)) DSTD('EDI Order quantity +
                          difference') MSG('** Qty Changed ** EDI +
                          Order contains different QUANTITY or SHIP +
                          DATE from the previous order. Please +
                          check the attached list and change the +
                          order data manually if needed.(AB#C0A).') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('EDI Order quantity +
                          difference')
/* TCHK1 */
             CHGSPLFA   FILE(QPRINT2) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST) FORMTYPE(K6H1) +
                          OUTQ(LANPRT50) SAVE(*NO)
             MONMSG     MSGID(CPF0000)
             ENDDO
             ENDDO

    /* DATE ERROR     */
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
             CPYSPLF    FILE(QPRINT6) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

      /***   OVRDBF     FILE(PRT132) TOFILE(PRT132B)   ***/
/*JW4*/      OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)

             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)

             IF         COND(&USER *NE 'TEST') THEN(DO)
/* TCHK1 S */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDIDeliveryDateError@iafi.com)) +
                          DSTD('EDI SHIP DATE ERROR') MSG('** Past +
                          Due Ship Date ** EDI Order data contains +
                          PAST SHIP DATE. Please check the attached +
                          list and contact the customer if +
                          necessary.(AB#C0A).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI Ship Date Error')
/* TCHK1 E */

             CHGSPLFA   FILE(QPRINT6) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST) FORMTYPE(K6H1) +
                          OUTQ(LANPRT50) SAVE(*NO)
             MONMSG     MSGID(CPF0000)
             ENDDO
             ENDDO

    /* JW3:  CHECK ORDER REPORT                   */
             CALL       PGM(CHKC71) PARM('E')
             CALL       PGM(CHKC74)

             DLTF       FILE(QTEMP/AB#WP202)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP202) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((QTEMP/AB#WP201)) +
                          OUTFILE(QTEMP/AB#WP202) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S23) +
                          OPTION(*NOPRT)
             DLTF       FILE(QTEMP/AB#WP201)

             DLTF       FILE(QTEMP/AB#WP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP20) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP20) OPTION(*NOLIST *NOSRC) +
                          SIZE(30000) LVLCHK(*NO) AUT(*ALL)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1) HOLD(*YES) IGCDTA(&PIGCD) +
                          /*JW*/

             OVRDBF     FILE(AB#WP202) TOFILE(QTEMP/AB#WP202)
             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
             CALL       PGM(AB#R0C)

             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
             CALL       PGM(AB#R22)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1) FORMTYPE(K6H1) HOLD(*YES) +
                          IGCDTA(&PIGCD) /*JW*/

             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
             CALL       PGM(AB#R23) PARM(&PSIRE)

             DLTF       FILE(QTEMP/MITANKF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/MITANKF) RCDLEN(300) +
                          OPTION(*NOLIST *NOSRC) SIZE(30000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             CALL       PGM(AB#R25) PARM(&PFLG)

 /* UNIT PRICE ERROR */
             IF         (&PFLG *EQ '*') DO
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1) FORMTYPE(K6H1) HOLD(*YES) +
                          IGCDTA(&PIGCD) /*JW*/
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             CALL       PGM(AB#R0D)

 /* %0001 */
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             SNDDST     TYPE(*FILE) TOINTNET((SalesGroup@iafi.com) +
                          (*NONE *CC)) DSTD('Unit price not +
                          registered') MSG('** Unit Price Not Exist +
                          ** UNIT PRICE of some parts is not +
                          registered when receiving an order. +
                          Please check the attached +
                          report.(AB#C0A).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI order  unit price +
                          not registered')
             MONMSG     MSGID(CPF0000)
             ENDDO

             DLTOVR     FILE(PRT132)

             ENDDO

  /* ERROR LIST */
             RTVMBRD    FILE(QTEMP/AB#WP2A) NBRCURRCD(&KEN)
             IF         (&KEN *GT 0) THEN(DO)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) HOLD(*YES) +
                          SAVE(*YES)

     /**JW5  CALL       PGM(AB#R0B)             **/
 /*JW5*/     CALL       PGM(AB#R0B) PARM(&RTN)

             IF         COND(&RTN *EQ '*') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
  /* JW2 CHECK 0 RECORD */
             MONMSG     MSGID(CPF3303 CPF3309) EXEC(GOTO CMDLBL(@SKP1))

             RTVMBRD    FILE(HWFILE1/PRT132)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@SKP1))

 /*JW4*/     OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132)
             CALL       PGM(AB#RW0)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDIORDERDATAERROR@iafi.com)) +
                          DSTD('EDI ORDER DATA CHECK LIST') MSG('** +
                          Incorrect Part# ** EDI Order data +
                          contains INCORRECT PART NUMBER or +
                          QTY/BOX. (AB#C0A).') +
                          DOCFILE(HWFILE1/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI ORDER DATA ERROR')
/* TCHK1 */

             RLSSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             ENDDO

             DLTF       FILE(QTEMP/AB#WP2A)
/*JW5*/      ENDDO
             ENDDO

/*JW2*/
 @SKP1:
             DLTOVR     FILE(*ALL)

 END:
   /* FORD */
   /** #STOP MIGRATE TO B2B **/
      /** JW SAVE AB#EP50 BEFORE GENTRAN PROCESS     **/
             CPYF       FROMFILE(HFILE1/AB#EP50) +
                          TOFILE(HFILE1/AB#EP50T) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)

      /**    CALL       PGM(AB#C0B)  **/

/* TCHK2 */
   /* ANDROID */
             CALL       PGM(AN#C0B)

/* TCHK7 S */
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT50) HOLD(*YES)
             OVRDBF     FILE(AB#WP452) TOFILE(QTEMP/AB#WP452)
             CALL       PGM(AB#R454) PARM(&PRUN)
             IF         COND(&PRUN *EQ '1') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132)
             CALL       PGM(AB#RW0)

             IF         COND(&USER *NE 'TEST') THEN(DO)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((TMSEDIORDERCHECK@iafi.com) +
                          (tanebek@iafi.com *CC)) DSTD('TMS EDI +
                          ORDER DATA CHECK LIST') MSG('** High +
                          Volume Qty ** EDI Order data contains +
                          HIGH VOLUME QTY.(AB#C0A).') +
                          DOCFILE(HWFILE1/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('TMS EDI ORDER DATA +
                          CHECK LIST')
             ENDDO

             DLTOVR     FILE(PRT132)
             ENDDO
             DLTOVR     FILE(QPRINT)
/* JW */
       /**  UNIVERSAL EDI            **/
             CALL PGM(AB#C12T)

             ENDPGM

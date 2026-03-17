             PGM        PARM(&PSIRE)
             /** AB#C2B *******************************************/
             /*       ..EDI HMA  FRS ORDER PROCESSING..           */
             /*                                                   */
             /* TCHK1 01/26/06 ADD CHECK PROD START DATE          */
             /* T.SAKAKI 05/06/15 AB#R21 OUTQ CHANGE  %0001       */
             /* JW2      09/01/16 SAVE AB#WP451 TO AB#PP2M        */
             /*          10/27/16 ADD  AB#R1H   TO SPLIT ORDER    */
             /* JW3      01/06/17 ADD QPRINT2 (DCL CHANGE REPORT) */
             /* JW5      07/25/18 CHG SNDMSG                      */
             /* JW6      10/01/18 ADD QPRINT6 SNDDST              */
             /* JW7      12/10/18 ADD SNDDST ERROR REPORT         */
             /* JW8      04/07/21 CHG  AB#R0B'S PARAMETER         */
             /* JW9    2021.08.18 CHG  AB#R2B TO AB#R2BN          */
             /* JWA    2022.10.21 ADD  SAVR04 TO SAVE PP2M        */
             /*****************************************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE5) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILES) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&KEN)   TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RTN)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&FILE1) VALUE(AB#WP201)
             CHGVAR     VAR(&FILE2) VALUE(AB#WP202)
             CHGVAR     VAR(&FILE3) VALUE(AB#WP20)
             CHGVAR     VAR(&FILE4) VALUE('MITANKF')
             CHGVAR     VAR(&FILE5) VALUE(AB#WP451)
             CHGVAR     VAR(&FILE6) VALUE(AB#WP452)

             CHGVAR     VAR(&SR) VALUE('HM')
             CHGVAR     VAR(&FILES) VALUE(AB#WP202 *CAT &SR)

             DLTF       FILE(QTEMP/&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE5) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP2A) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP451) TOFILE(QTEMP/&FILE5)
 /*JW*/      OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1 ) FORMTYPE(K6H1)

             CRTDUPOBJ  OBJ(AB#WP2B) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

 /*JW3*/     OVRPRTF    FILE(QPRINT2) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(WATAOUTQ) FORMTYPE(K6H1)

 /* AB#R2B: PROCESS HONDA ORDER */

             CLRPFM QTEMP/AB#WP2B
             OVRDBF     FILE(AB#WP2B) TOFILE(QTEMP/AB#WP2B)

             CALL       PGM(AB#R2BN)

/*JW2 SAVE AB#WP451 TO AB#PP2M       */
             CALL       PGM(SAVR04) PARM('AB#C2B')

             DLTOVR     FILE(QPRINT)
/*JW3        DLTOVR     FILE(QPRINT2)     */

             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       END
             ENDDO

  /* ERROR LIST */
             RTVMBRD    FILE(QTEMP/AB#WP2A) NBRCURRCD(&KEN)
             IF         (&KEN *GT 0) THEN(DO)
/*JW*/       OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1 ) FORMTYPE(K6H1) HOLD(*YES)

/*JW8*/      CALL       PGM(AB#R0B) PARM($RTN)
             DLTOVR     FILE(QPRINT)

             ENDDO

             DLTF       FILE(QTEMP/&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE6) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((QTEMP/&FILE5)) OUTFILE(QTEMP/&FILE6) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S45) +
                          OPTION(*NOPRT)

/*JW2      &FILE1 = QTEMP/AB#WP201   */
/*JW2      &FILE5 = QTEMP/AB#WP451   */
/*JW2      &FILE6 = QTEMP/AB#WP452   */

             DLTF       FILE(QTEMP/&FILE5)

             DLTF       FILE(QTEMP/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE1) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

/* AB#R451: PRINT "RECEIVED ORDER PRODUCTION START DATE ERROR REPORT" */

             OVRDBF     FILE(AB#WP452) TOFILE(QTEMP/&FILE6)
             OVRDBF     FILE(AB#WP201) TOFILE(QTEMP/&FILE1)
/*JW*/       OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1 )
/*TCHK1*/    CALL       PGM(AB#R451)
/*TCHK1*/    DLTOVR     FILE(QPRINT)

/* AB#R45: UPLOAD HONDA ORDER DATA TO AB#PP10 */

/*JW*/       OVRPRTF    FILE(QPRINT)  OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT2) OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT5) OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT6) OUTQ(EPRINT1) HOLD(*YES)
             CALL       PGM(AB#R45) PARM(&USER)

/* JW6 SEND ERROR MSG (QPRINT6) */
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
             CPYSPLF    FILE(QPRINT6) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(PRT132B)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDIDeliveryDateError@iafi.com)) +
                          DSTD('EDI Ship Date Error') MSG('** HONDA +
                          EDI Order contains past ship date. Please +
                          check the attached list and contact the +
                          customer if necessary.(AB#C2B-1).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI SHIP DATE ERROR')
             ENDDO
             ENDDO


/*JW2 SPLIT ORDERS */
             CALL       PGM(AB#R1H) PARM(&RTN)

/*JW7 MAIL SPLIT ERROR REPORT */
             IF         COND((&USER *NE 'TEST') *AND (&RTN *EQ '*')) +
                        THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(PRT132B)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDIOrderDataError@iafi.com)) +
                          DSTD('HONDA EDI SPLIT ORDER ERROR') +
                          MSG('** HONDA EDI Order contains invalid +
                          conditions to split by pallet. Please +
                          contact our IT members if +
                          necessary.(AB#C2B-2).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('HONDA EDI SPLIT ORDER +
                          ERROR')
             ENDDO

             IF         (%SWITCH(X0XXXXXX)) DO
             CALL       PGM(QUILNGTX) PARM('EDI862 HMA ALL FRS ORDER +
                          HAS BEEN PROCESSED. (AB#C2B)' X'00000046' +
                          ' ' ' ' X'00000000')
             GOTO       END
             ENDDO

             DLTF       FILE(QTEMP/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE2) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((QTEMP/&FILE1)) OUTFILE(QTEMP/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S23) +
                          OPTION(*NOPRT)
             DLTF       FILE(QTEMP/&FILE1)

             DLTF       FILE(QTEMP/&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE3) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP20) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

 /* AB#R22: PRINT "EDI FRS ORDER LIST" */

 /*JW*/      OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT  ) FORMTYPE(K6H1) HOLD(*YES)

 /*JW*/      OVRPRTF    FILE(QPRINT2) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT  ) FORMTYPE(K6H1) HOLD(*YES)

             OVRDBF     FILE(AB#WP202) TOFILE(QTEMP/&FILE2)
             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/&FILE3)
             CALL       PGM(AB#R21) PARM(&PSIRE)

             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/&FILE3)
             CALL       PGM(AB#R22)

 /* AB#R23: UPDATE AU#NP11 / AU#PP11   */

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(EPRINT1) +
                          FORMTYPE(K6H1) HOLD(*YES) /*JW*/
             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/&FILE3)
             CALL       PGM(AB#R23) PARM(&PSIRE)

             DLTF       FILE(QTEMP/&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE4) RCDLEN(300) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

 /* AB#R25: DETECT PRICE ERROR (MITANKF) */

             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/&FILE3)
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/&FILE4)
             CALL       PGM(AB#R25) PARM(&PFLG)

 /* AB#R26: PRINT "UNDECIDED UNIT PRICE LIST" */

             IF         (&PFLG *EQ '*') DO

 /*JW*/      OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(EPRINT1) +
                          FORMTYPE(K6H1) HOLD(*YES)

             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/&FILE4)
             CALL       PGM(AB#R26) PARM(&PSIRE)

             SNDPGMMSG  MSG('UNIT PRICES ARE NOT REGISTERED IN THE +
                          SALES UNIT PRICE MASTER FILES. UNIT PRICE +
                          MUST BE REGISTERED. (AB#C2B)') TOMSGQ(&WSID)
             ENDDO

             DLTOVR     FILE(*ALL)

             CPYF       FROMFILE(QTEMP/&FILE2) TOFILE(&WLIB/&FILES) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

 END:        ENDPGM

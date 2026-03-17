             PGM
             /** AC#C2B *******************************************/
             /*  HONDA EDI AUTO ORDER PROCESSING (BATCH)          */
             /*  J.WATANABE 2018.11.26                            */
             /*****************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&TODAY) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN1 ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN2 ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&KEN)   TYPE(*DEC)  LEN(10 0)

       /* TEMP */
       /*    GOTO ENDP */

             RTVJOBA    JOB(&WSID)  USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PSIRE) VALUE('0390')
             CHGVAR     VAR(&TODAY) VALUE('        ')

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 /* CHECK DUPLICATE ORDER */
       /*    CALL       PGM(HOBJ1/AC#C2C)  */

 /* SET WORK FILE */

             CLRPFM     FILE(*LIBL/AB#WP55)
             MONMSG     MSGID(CPF3261 CPF2105)

             CLRPFM     FILE(*LIBL/AB#WP2B )
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(QTEMP/AB#WP45)
             MONMSG     MSGID(CPF3261 CPF2105)
           CRTDUPOBJ  OBJ(AB#WP45) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)

             DLTF       FILE(QTEMP/AB#WP451)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP451) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP2A) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CRTDUPOBJ  OBJ(AB#WP2B) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/AB#WP2B

             OVRPRTF    FILE(QPRINT)  OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT2) OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT5) OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT6) OUTQ(EPRINT1) HOLD(*YES)

/* ========== PROCESS ORDER ================================ */
             OVRDBF     FILE(AB#WP45 ) TOFILE(QTEMP/AB#WP451)
             OVRDBF     FILE(AB#WP451) TOFILE(QTEMP/AB#WP451)
             OVRDBF     FILE(AB#WP2B)  TOFILE(QTEMP/AB#WP2B)

             CALL       PGM(AC#R2B@) PARM(&TODAY &RTN1)

/*** TEST END ***/
             GOTO ENDP
/****************/




             RTVMBRD    FILE(*LIBL/AB#WP55)  NBRCURRCD(&KEN)
             IF         (&KEN = 0) THEN(GOTO ENDP)
/* ========== PROCESS ORDER END ============================ */

             GOTO ENDP

/* SAVE AB#WP55 TO AB#WP451      */
             CPYF       FROMFILE(*LIBL/AB#WP55) TOFILE(QTEMP/AB#WP451) +
                        MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPC2957 CPF2973)

/* SAVE AB#WP451 TO AB#PP2M       */
             CPYF       FROMFILE(QTEMP/AB#WP451) TOFILE(*LIBL/AB#PP2M) +
                        MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPC2957 CPF2973)

       /*    IF         (%SWITCH(0XXXXXXX)) DO  */
       /*    GOTO       END                     */
       /*    ENDDO                              */

  /* ** EDI(ORDER DATA) PARTS/SHIPMENT INFORMATION MASTER ERROR **/
             RTVMBRD    FILE(QTEMP/AB#WP2A) NBRCURRCD(&KEN)
             IF         (&KEN *GT 0) THEN(DO)
             CALL       PGM(AB#R0B) PARM(&RTN1)
             ENDDO

             DLTF       FILE(QTEMP/AB#WP452)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP452) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE(QTEMP/AB#WP451) OUTFILE(QTEMP/AB#WP452) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S45) +
                          OPTION(*NOPRT)

             DLTF       FILE(QTEMP/AB#WP451)

/* AB#R451: PRINT "RECEIVED ORDER PRODUCTION START DATE ERROR REPORT" */

             OVRDBF     FILE(AB#WP452) TOFILE(QTEMP/AB#WP452)
             CALL       PGM(AB#R451)

/* AB#R45: UPLOAD HONDA ORDER DATA TO AB#PP10 */
             DLTF       FILE(QTEMP/AB#WP201)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP201)  RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP201) TOFILE(QTEMP/AB#WP201)
             CALL       PGM(AB#R45) PARM(&USER)

/* SEND AUTO ORDER PROCESS REPORT */
             CALL       PGM(UMLC01)

/* SEND ERROR MSG (QPRINT6) */
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
             CPYSPLF    FILE(QPRINT6) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(PRT132B)
             CALL       PGM(AB#RW0)

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

/* SPLIT ORDERS */
             CALL       PGM(AB#R1H) PARM(&RTN2)

/* MAIL SPLIT ERROR REPORT */
             IF         COND((&USER *NE 'TEST') *AND (&RTN2 *EQ '*')) +
                        THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(PRT132B)
             CALL       PGM(AB#RW0)
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
             GOTO       ENDP
             ENDDO

             DLTF       FILE(QTEMP/AB#WP202)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP202) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((QTEMP/AB#WP201)) OUTFILE(QTEMP/AB#WP202) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S23) +
                          OPTION(*NOPRT)
             DLTF       FILE(QTEMP/AB#WP201)

             DLTF       FILE(QTEMP/AB#WP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP20) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP20) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

 /* AB#R22: PRINT "EDI FRS ORDER LIST" */

             OVRDBF     FILE(AB#WP202) TOFILE(QTEMP/AB#WP202)
             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
             CALL       PGM(AB#R21) PARM(&PSIRE)

             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
             CALL       PGM(AB#R22)

 /* AB#R23: UPDATE AU#NP11 / AU#PP11   */

             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
             CALL       PGM(AB#R23) PARM(&PSIRE)

             DLTF       FILE(QTEMP/MITANKF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/MITANKF) RCDLEN(300) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

 /* AB#R25: DETECT PRICE ERROR (MITANKF) */

             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             CALL       PGM(AB#R25) PARM(&PFLG)

 /* AB#R26: PRINT "UNDECIDED UNIT PRICE LIST" */

             IF         (&PFLG *EQ '*') DO
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             CALL       PGM(AB#R26) PARM(&PSIRE)

             SNDPGMMSG  MSG('UNIT PRICES ARE NOT REGISTERED IN THE +
                          SALES UNIT PRICE MASTER FILES. UNIT PRICE +
                          MUST BE REGISTERED. (AB#C2B)') TOMSGQ(&WSID)
             ENDDO

             CPYF       FROMFILE(QTEMP/AB#WP202) TOFILE(&WLIB/AB#WP202HM) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
 ENDP:
             DLTOVR     FILE(*ALL)
             ENDPGM

             PGM
/** ABBC57 ************************************************/
/*  FORD SHIPMENT & FORECAST AVERAGE                      */
/*                                                        */
/* TCHK1 03/16/11 CHG QPRINTC --> QPRINTB                 */
/* TUCKER05/18/15 CHG QPRINTB --> QPRINT --> LANPRT50     */
/* LEC 2017/03/06 ADD CSV OPTION                          */
/* JW1 2019/07/19 ADD ABBWP59 (WORK)                      */
/************************************************ ABBC57 **/
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(150)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(150)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(40) VALUE('FORD +
                          SHIPMENT & FORECAST AVERAGE')

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/SALES/+
                          DOWNLOAD/' *CAT &USER)
             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE +
                          *TCAT '.CSV')

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)


/* CREATE COPY OF WORKFILE IN QTEMP AND CLEAR IT.             */
             CRTDUPOBJ  OBJ(ABBWP57) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABBWP57)

             CRTDUPOBJ  OBJ(ABBWP57V) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABBWP57V)

/*JW1*/      CRTDUPOBJ  OBJ(ABBWP59) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABBWP59)

             OVRDBF     FILE(ABBWP57) TOFILE(QTEMP/ABBWP57)
             OVRDBF     FILE(ABBWP59) TOFILE(QTEMP/ABBWP59)


/* TCHK1 */  OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(LANPRT50)

/*JW*/       IF         COND(&USER *EQ 'I0777') THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(EPRINT1)
             ENDDO

             CALL       PGM(ABBR57) PARM(&RTN)

             RTVMBRD    FILE(QTEMP/ABBWP57) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(#END))

/***   if csv output file was requested  -- F8  -->  U8     *****/
       /**JW IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)  */
             IF         COND(&RTN = 'Y') THEN(DO)

/* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

/* COPY 0 RECORD */
             CPYTOIMPF  FROMFILE(QTEMP/ABBWP57) TOSTMF(&DIR2) +
                        MBROPT(*REPLACE) RCDDLM(*CRLF) +
                        RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                        TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

      /* CREATE ABBWP57V  */
             CPYF       FROMFILE(QTEMP/ABBWP57) +
                          TOFILE(QTEMP/ABBWP57V) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(#END))

      /* TRANSFER.....*/
             CPYTOIMPF  FROMFILE(QTEMP/ABBWP57V) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA) ADDCOLNAM(*SYS)

             SNDPGMMSG  MSG('CSV HAS BEEN CREATED IN YOUR USER +
                          DIRECTORY (L:) +
                          SALES\DOWNLOAD\USER-ID\FORD SHIPMENT & +
                          FORECAST AVERAGE.CSV') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO)

             ENDDO

 #END:       DLTOVR     FILE(*ALL)


             ENDPGM

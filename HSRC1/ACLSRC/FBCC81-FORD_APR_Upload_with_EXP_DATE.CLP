             PGM
             /*** FBCC81  **************************************/
             /* FORD APR UPLOAD (FORD-APR.CSV --> FBCWP80A)    */
             /* (UPLOAD APR WITH EXP_DATE)                     */
             /* JW (SRA)    2023.06.22                         */
             /**************************************************/
             DCLF       FILE(FBCPW81 )
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&ANS )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(8)

             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERR)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG1)   TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSG2)   TYPE(*CHAR) LEN(80)
             DCL        VAR(&RTN1)   TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING & LOCK PROGRAM =================== */
             CALL CHKC45 ('FBCC81' 'FBCC81' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @EXIT0)
/* ================================================================ */

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&SYSTEM)
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1  ')


             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) OUTQ(LANPRT03) +
                          HOLD(*YES)  USRDTA('FORD-APR')

             OVRDBF     FILE(FAAPL02) TOFILE(HFILE1/FAAPL02)
             OVRDBF     FILE(FAAPL06) TOFILE(HFILE1/FAAPL06)
             OVRDBF     FILE(FAAPL09) TOFILE(HFILE1/FAAPL09)
             OVRDBF     FILE(FCEPL01) TOFILE(HFILE1/FCEPL01)

             OVRDBF     FILE(FAAPL05) TOFILE(HFILE1/FAAPL05)
@DSP00:
       /* clear Work File                                      */
             CLRPFM     FILE(&WLIB/FBCWP80A)
             CLRPFM     FILE(&WLIB/FBCWP81A)
             CLRPFM     FILE(&WLIB/FBCWP82A)

             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

 /* F1: Exit                                                              */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@CANCEL))

 /* F5: UPDATE                                                            */
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP00))

STP1:   /*********************************************************/
        /* upload FORD-APR2.csv --> AS400 HWFILE1/FBCWP80A       */
        /*********************************************************/
             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          Sales/Upload/FORD-APR2.csv') +
                          TOFILE(&WLIB/FBCWP80A) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)
             MONMSG     MSGID(CPF2817)

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&WLIB/FBCWP80A) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('APR Data Is Empty! Please +
                          Check FORD-APR2.csv.')
             CHGVAR VAR(&IN99) VALUE('1')
             GOTO CMDLBL(@DSP00)
             ENDDO

STP3:
/* Program1: Check Price Data Fields                                     */
             OVRDBF     FILE(FBCWP80A) TOFILE(&WLIB/FBCWP80A)
             OVRDBF     FILE(FBCWP81A) TOFILE(&WLIB/FBCWP81A)
             CALL       PGM(FBCR80A)  PARM(&ERR &MSG1 &MSG2)

STP4:
/* If Error, send MSG2 and Exit Program                                  */
             IF         COND(&ERR *EQ '1') THEN(DO)
                SNDPGMMSG  MSG(&MSG2) TOMSGQ(&WSID) MSGTYPE(*INQ)
                RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) MSG(&ANS)
                IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +
                           THEN(GOTO CMDLBL(@CANCEL))
                IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +
                          THEN(GOTO CMDLBL(STP6))
             GOTO CMDLBL(STP4)
             ENDDO

STP5:
/* If No Error, send MSG G or C                                          */
             IF         COND(&ERR *EQ '0') THEN(DO)
             SNDPGMMSG  MSG(&MSG1) TOMSGQ(&WSID) MSGTYPE(*INQ)
             RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) MSG(&ANS)
             IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +
                          THEN(GOTO CMDLBL(@CANCEL))
             IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +
                          THEN(GOTO CMDLBL(STP6))
             GOTO CMDLBL(STP5)
             ENDDO

STP6:
/* BACKUP PRICE FILE                                                     */
             CPYF       FROMFILE(HFILE1/FBCPP01) +
                          TOFILE(HFILE1/FBCPP01BK) MBROPT(*REPLACE) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)

/*    set Printer HOLD                                                   */
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) +
                          OUTQ(QGPL/APR_REPORT) HOLD(*YES) +
                          USRDTA('FORD-APR')

STP6B:
/* Program2: Update Price                                                */
/* TEMP                                                                  */
             OVRDBF     FILE(FAAPL07) TOFILE(TFILE1/FAAPL07)
             OVRDBF     FILE(FAAPL08) TOFILE(TFILE1/FAAPL08)

             CALL       PGM(FBCR81A)

STP7:   /*********************************************************/
        /* BACKUP                                                */
        /* AS400 HWFILE1/FBCWP80A --> HWFILE1/FBCWP80ABK         */
        /*********************************************************/
             CLRPFM     FILE(&WLIB/FBCWP80AB )
             CPYF       FROMFILE(&WLIB/FBCWP80A) +
                          TOFILE(&WLIB/FBCWP80AB ) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             CLRPFM     FILE(&WLIB/FBCWP81ABK)
             CPYF       FROMFILE(&WLIB/FBCWP81A) +
                          TOFILE(&WLIB/FBCWP81AB ) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             CLRPFM     FILE(&WLIB/FBCWP82AB )
             CPYF       FROMFILE(&WLIB/FBCWP82A) +
                          TOFILE(&WLIB/FBCWP82AB ) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             SNDPGMMSG  MSG('Price data has been uploaded +
                          successfully. Confirm with Report output.')
             GOTO       CMDLBL(@EXIT1)
@CANCEL:
             SNDPGMMSG  MSG('Job has been canceled without updating..')

@EXIT1:
/* JW1 CHECK UNLOCK PROGRAM ======================================= */
                CALL CHKC45 ('FBCC81' 'FBCC81' 'N'  '' '')
/* ================================================================ */

@EXIT0:
             DLTOVR     FILE(*ALL)
             ENDPGM

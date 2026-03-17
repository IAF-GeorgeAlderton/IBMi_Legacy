             PGM
             /*** FBCC80 ***************************************/
             /* FORD APR UPLOAD (FORD-APR.CSV --> FBCWP80)     */
             /* JW (SRA)    2015.11.12                         */
             /* ------------------------                       */
             /* JW1         2022.11.11 ADD EXCLUCIVE CHECK     */
             /* JW2         2025.03.11 ADD FBCC81B             */
             /**************************************************/
             DCLF       FILE(FBCPW80)
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
             CALL CHKC45 ('FBCC80' 'FBCC80' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @EXIT0)
/* ================================================================ */

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&SYSTEM)
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1  ')

       /*    set Printer to LANPRT50                           */
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
       /*    set Printer to LANPRT03                           */
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) OUTQ(LANPRT03) +
                          HOLD(*NO)  USRDTA('FORD-APR')

       /* TEMP                                                 */
             OVRDBF     FILE(FAAPL02) TOFILE(HFILE1/FAAPL02)
             OVRDBF     FILE(FAAPL06) TOFILE(HFILE1/FAAPL06)
             OVRDBF     FILE(FAAPL05) TOFILE(HFILE1/FAAPL05)
             OVRDBF     FILE(FAAPL09) TOFILE(HFILE1/FAAPL09)
             OVRDBF     FILE(FCEPL01) TOFILE(HFILE1/FCEPL01)
@DSP00:
       /* clear Work File                                      */
             CLRPFM     FILE(&WLIB/FBCWP80)
             CLRPFM     FILE(&WLIB/FBCWP81)
             CLRPFM     FILE(&WLIB/FBCWP82)

             SNDRCVF    DEV(&WSID) RCDFMT(FBCPW801)

       /* CMD1: Exit  */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@CANCEL))

       /* CMD5: Start */
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP00))

STP1:   /*********************************************************/
        /* upload FORD-APR.csv --> AS400 HWFILE1/FBCWP80         */
        /*********************************************************/
             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          Sales/Upload/FORD-APR.csv') +
                          TOFILE(&WLIB/FBCWP80) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)

             MONMSG     MSGID(CPF2817)

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&WLIB/FBCWP80) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('APR Data Is Empty! Please +
                          Check FORD-APR.csv.')
             CHGVAR VAR(&IN99) VALUE('1')
             GOTO CMDLBL(@DSP00)
             ENDDO

STP3:   /* Program1: Check Price Data Fields */
             OVRDBF     FILE(FBCWP80) TOFILE(&WLIB/FBCWP80)
             OVRDBF     FILE(FBCWP81) TOFILE(&WLIB/FBCWP81)
             CALL       PGM(FBCR80)  PARM(&ERR &MSG1 &MSG2)

STP4:   /* If Error, send MSG2 and Exit Program */
             IF         COND(&ERR *EQ '1') THEN(DO)
                SNDPGMMSG  MSG(&MSG2) TOMSGQ(&WSID) MSGTYPE(*INQ)
                RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) MSG(&ANS)
                IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +
                           THEN(GOTO CMDLBL(@CANCEL))
                IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +
                          THEN(GOTO CMDLBL(STP6))
             GOTO CMDLBL(STP4)
             ENDDO

STP5:   /* If No Error, send MSG G or C */
             IF         COND(&ERR *EQ '0') THEN(DO)
             SNDPGMMSG  MSG(&MSG1) TOMSGQ(&WSID) MSGTYPE(*INQ)
             RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) MSG(&ANS)
             IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +
                          THEN(GOTO CMDLBL(@CANCEL))
             IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +
                          THEN(GOTO CMDLBL(STP6))
             GOTO CMDLBL(STP5)
             ENDDO

STP6:   /* BACKUP PRICE FILE */
             CPYF       FROMFILE(HFILE1/FBCPP01) +
                          TOFILE(HFILE1/FBCPP01BK) MBROPT(*REPLACE) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)

       /*    set Printer HOLD                                  */
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) +
                          OUTQ(QGPL/APR_REPORT) HOLD(*YES) +
                          USRDTA('FORD-APR')

STP6B:  /* Program2: Update Price */
             CALL       PGM(FBCR81)

STP7:   /*********************************************************/
        /* BACKUP                                                */
        /* AS400 HWFILE1/FBCWP80 --> HWFILE1/FBCWP80BK           */
        /*********************************************************/
             CLRPFM     FILE(&WLIB/FBCWP80BK)
             CPYF       FROMFILE(&WLIB/FBCWP80) +
                          TOFILE(&WLIB/FBCWP80BK) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             CLRPFM     FILE(&WLIB/FBCWP81BK)
             CPYF       FROMFILE(&WLIB/FBCWP81) +
                          TOFILE(&WLIB/FBCWP81BK) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             CLRPFM     FILE(&WLIB/FBCWP82BK)
             CPYF       FROMFILE(&WLIB/FBCWP82) +
                          TOFILE(&WLIB/FBCWP82BK) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             SNDPGMMSG  MSG('Price data has been uploaded +
                          successfully. Confirm with Report output.')

/* JW2  OTPUT REPORT TO CSV  **/
             CALL       PGM(FBCC81B)

             GOTO       CMDLBL(@EXIT1)
@CANCEL:
             SNDPGMMSG  MSG('Job has been canceled without updating..')

@EXIT1:
/* JW1 CHECK UNLOCK PROGRAM ======================================= */
                CALL CHKC45 ('FBCC80' 'FBCC80' 'N'  '' '')
/* ================================================================ */

@EXIT0:
             DLTOVR     FILE(*ALL)
             ENDPGM

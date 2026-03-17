             PGM
             /*** FBCC83 ****************************************/
             /* SALES U/PRICE UPLOAD (SALES-UP.CSV --> FBCWP83) */
             /* JW (SRA)    2016.03.30                          */
             /* ------------------------                        */
             /* JW1         2022.11.11 ADD EXCLUCIVE CHECK      */
             /*********************************************++++**/
             DCLF       FILE(FBCPW83)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&ANS )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(8)

             DCL        VAR(&FLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERR)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG1)   TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSG2)   TYPE(*CHAR) LEN(80)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN1)   TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING & LOCK PROGRAM =================== */
             CALL CHKC45 ('FBCC83' 'FBCC83' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @EXIT0)
/* ================================================================ */

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&SYSTEM)

             CHGVAR     VAR(&FLIB) VALUE('HWFILE1  ')
       /*    CHGVAR     VAR(&FLIB) VALUE('TWFILE1  ')   */

       /*    set Printer to LANPRT50                           */
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
       /*    set Printer to LANPRT03                           */
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) OUTQ(LANPRT03) +
                          HOLD(*NO) USRDTA('SLS-UP1')

       /* TEMP                                                 */
             OVRDBF     FILE(FAAPL02) TOFILE(*LIBL/FAAPL02)
             OVRDBF     FILE(FAAPL06) TOFILE(*LIBL/FAAPL06)
             OVRDBF     FILE(FAAPL05) TOFILE(*LIBL/FAAPL05)
             OVRDBF     FILE(FAAPL09) TOFILE(*LIBL/FAAPL09)
             OVRDBF     FILE(FCEPL01) TOFILE(*LIBL/FCEPL01)
@DSP00:
       /* clear Work File                                      */
             CLRPFM     FILE(&FLIB/FBCWP83)
             CLRPFM     FILE(&FLIB/FBCWP84)
             CLRPFM     FILE(&FLIB/FBCWP85)

             SNDRCVF    DEV(&WSID) RCDFMT(FBCPW831)

       /* CMD1: Exit  */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@CANCEL))

       /* CMD5: Start */
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP00))

STP1:   /*********************************************************/
        /* upload SALES-UP.csv --> AS400 HWFILE1/FBCWP83         */
        /*********************************************************/
             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          Sales/Upload/SALES-UP.csv') +
                          TOFILE(&FLIB/FBCWP83) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)

             MONMSG     MSGID(CPF2817)

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&FLIB/FBCWP83) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('CSV Data Is Empty! Please +
                          Check SALES-UP.csv.')
             CHGVAR VAR(&IN99) VALUE('1')
             GOTO CMDLBL(@DSP00)
             ENDDO

STP3:   /* Program1: Check Price Data Fields */
        /* SAVE FBCWP83 */
             CALL       PGM(FBCR83S)

             OVRDBF     FILE(FBCWP83) TOFILE(&FLIB/FBCWP83)
             OVRDBF     FILE(FBCWP84) TOFILE(&FLIB/FBCWP84)
             CALL       PGM(FBCR83)  PARM(&ERR &MSG1 &MSG2)

STP4:   /* If Error, send MSG2 and Exit Program */
             IF         COND(&ERR *EQ '1') THEN(DO)
             SNDPGMMSG  MSG(&MSG2) TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) WAIT(120) KEYVAR(&MBAN) MSG(&ANS)
                IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +
                           THEN(GOTO CMDLBL(@CANCEL))
                IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +
                          THEN(GOTO CMDLBL(STP6))
             GOTO CMDLBL(@CANCEL)
             ENDDO

STP5:   /* If No Error, send MSG G or C */
             IF         COND(&ERR *EQ '0') THEN(DO)
             SNDPGMMSG  MSG(&MSG1) TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) WAIT(120) MSG(&ANS) KEYVAR(&MBAN)
             IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +
                          THEN(GOTO CMDLBL(@CANCEL))
             IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +
                          THEN(GOTO CMDLBL(STP6))
             GOTO CMDLBL(STP5)
             ENDDO

STP6:   /* BACKUP PRICE FILE */
             CPYF       FROMFILE(*LIBL/FBCPP01) +
                          TOFILE(*LIBL/FBCPP01BK) MBROPT(*REPLACE) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)

STP6B:  /* Program2: Update Price */
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) +
                          OUTQ(QGPL/APR_REPORT) HOLD(*NO) +
                          USRDTA('SLS-UP2')

             CALL       PGM(FBCR84)

STP7:   /*********************************************************/
        /* BACKUP                                                */
        /* AS400 HWFILE1/FBCWP83 --> HWFILE1/FBCWP83BK           */
        /*********************************************************/
             CLRPFM     FILE(&FLIB/FBCWP83BK)
             CPYF       FROMFILE(&FLIB/FBCWP83) +
                          TOFILE(&FLIB/FBCWP83BK) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

        /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&FLIB/FBCWP85) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             SNDPGMMSG  MSG('No Data has been uploaded because Price +
                          data is empty!')
             GOTO CMDLBL(@EXIT1)
             ENDDO

             SNDPGMMSG  MSG('Price data has been uploaded +
                          successfully. Report (SLS-UP2).')
             GOTO       CMDLBL(@EXIT1)
@CANCEL:
             SNDPGMMSG  MSG('Job has been canceled without updating..')

@EXIT1:
/* JW1 CHECK UNLOCK PROGRAM ======================================= */
                CALL CHKC45 ('FBCC83' 'FBCC83' 'N'  '' '')
/* ================================================================ */

@EXIT0:
             DLTOVR     FILE(*ALL)
             ENDPGM

             PGM
             /*** AFFC01 ************************************/
             /* TAC ORDER UPLOADING (ORDER.CSV --> AFFWP01) */
             /* JW (SRA)    2015.11.25                      */
             /***********************************************/
             DCLF       FILE(AFFPW01)
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
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)

             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGVAR     VAR(&PYM) VALUE(%SST(&ABADS1 1 6))
             CHGJOB     SWS(00000000)

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&SYSTEM)
             CHGVAR     VAR(&FLIB) VALUE('HWFILE1  ')

       /*    set Printer to LANPRT50                           */
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
       /*    set Printer to LANPRT03                           */
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) OUTQ(LANPRT03)

@DSP00:
       /* clear Work File                                      */
             CLRPFM     FILE(&FLIB/AFFWP01)
             CLRPFM     FILE(&FLIB/AFFWP02)

             SNDRCVF    DEV(&WSID) RCDFMT(AFFPW011)

       /* CMD1: Exit  */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@CANCEL))

       /* CMD5: Start */
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP00))

STP1:   /*********************************************************/
        /* upload TAC-ORDER.csv --> AS400 HWFILE1/AFFWP01        */
        /*********************************************************/
             CPYFRMIMPF +
                          FROMSTMF('QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          Sales/Upload/TAC-ORDER.csv') +
                          TOFILE(HWFILE1/AFFWP01) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(HWFILE1/AFFWP01) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('APR Data Is Empty! Please +
                          Check FORD-APR.csv.')
             CHGVAR VAR(&IN99) VALUE('1')
             GOTO CMDLBL(@DSP00)
             ENDDO

STP3:   /* Program1: Check Price Data Fields */
             OVRDBF     FILE(AFFWP01) TOFILE(&FLIB/AFFWP01)
             OVRDBF     FILE(AFFWP02) TOFILE(&FLIB/AFFWP02)
             CALL       PGM(AFFR01)  PARM(&ERR &MSG1 &MSG2)

STP4:   /* If Error, send MSG2 and Exit Program */
             IF         COND(&ERR *EQ '1') THEN(DO)
                SNDPGMMSG  MSG(&MSG2) TOMSGQ(&WSID) MSGTYPE(*INQ)
             RCVMSG     MSGTYPE(*RPY) WAIT(180) MSG(&ANS)
                IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +
                           THEN(GOTO CMDLBL(@CANCEL))
                IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +
                          THEN(GOTO CMDLBL(STP6))
             GOTO CMDLBL(STP4)
             ENDDO

STP5:   /* If No Error, send MSG G or C */
             IF         COND(&ERR *EQ '0') THEN(DO)
             SNDPGMMSG  MSG(&MSG1) TOMSGQ(&WSID) MSGTYPE(*INQ)
             RCVMSG     MSGTYPE(*RPY) WAIT(180) MSG(&ANS)
             IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +
                          THEN(GOTO CMDLBL(@CANCEL))
             IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +
                          THEN(GOTO CMDLBL(STP6))
             GOTO CMDLBL(STP5)
             ENDDO

STP6:   /* Program2: Update ORDER */
             CLRPFM     FILE(&FLIB/AFFWP03)
             OVRDBF     FILE(AFFWP03) TOFILE(&FLIB/AFFWP03)
             CALL       PGM(AFFR02)

             IF         (%SWITCH(1XXXXXXX)) DO
             CALL       PGM(ABBC61) PARM(&PYM)
             ENDDO
STP7:   /*********************************************************/
        /* BACKUP                                                */
        /* AS400 HWFILE1/AFFWP01 --> HWFILE1/AFFWP01BK           */
        /*********************************************************/
             CLRPFM     FILE(HWFILE1/AFFWP01BK)
             CPYF       FROMFILE(HWFILE1/AFFWP01) +
                          TOFILE(HWFILE1/AFFWP01BK) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             SNDPGMMSG  MSG('Order data has been uploaded +
                          successfully. Confirm with Report output.')
             GOTO       CMDLBL(@EXIT)
@CANCEL:
             SNDPGMMSG  MSG('Job has been canceled without updating..')

@EXIT:
             DLTOVR     FILE(*ALL)
             ENDPGM

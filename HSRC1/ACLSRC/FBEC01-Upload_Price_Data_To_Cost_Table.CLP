/*= FBEC01 ===============================================*/
/*  PROGRAM    : UPLOAD PRICE DATA TO COST TABLE          */
/*  WRITTEN    : 2015/10/07                               */
/*  WRITTEN BY : JW(SRA)                                  */
/*  ----------------------------                          */
/*  JW1    2021.08.24 ADD FBEWP03                         */
/*========================================================*/
             PGM
             DCLF       FILE(FBEPW01)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR )   TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&ANS )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(8)

             DCL        VAR(&FLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRUE)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&ERR)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG1)   TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSG2)   TYPE(*CHAR) LEN(80)
             DCL        VAR(&DATE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN1)   TYPE(*CHAR) LEN(1 )

 /* CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('FBEC01 ' 'FBEC01 ' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @ENDP)
 /*==============================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             RTVNETA    SYSNAME(&SYSTEM)
             CHGVAR     VAR(&FLIB) VALUE('HWFILE1  ')

       /*    set Printer to LANPRT50                           */
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
       /*    set Printer to LANPRT03                           */
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) OUTQ(QPRINT) +
                          HOLD(*NO) USRDTA('COST_PRC1')
@DSP00:
             CLRPFM     FILE(&FLIB/FBEWP01)
             CLRPFM     FILE(&FLIB/FBEWP02)
             CLRPFM     FILE(&FLIB/FBEWP03)
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

       /* initial setting                                      */
             CHGVAR     VAR(&IN99) VALUE('0')

       /* CMD1: Exit  */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@CANCEL1))
       /* CMD5: Start */
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP00))

STP1:  /* Check Date */
             IF   COND(&XVLDATE *EQ ' ') THEN(DO)
             CHGVAR VAR(&XMSG) VALUE('ENTER VALID DATE FROM!')
             CHGVAR VAR(&IN99) VALUE('1')
             GOTO CMDLBL(@DSP00)
             ENDDO

             CHGVAR VAR(&DATE) VALUE(&XVLDATE)
             CALL UTLR01  (&DATE &TRUE &RTN)

             IF   COND(&RTN *NE ' ') THEN(DO)
             CHGVAR VAR(&XMSG) VALUE('DATE IS NOT IN CALENDAR MASTER!')
             CHGVAR VAR(&IN99) VALUE('1')
             GOTO CMDLBL(@DSP00)
             ENDDO

STP2:   /************************************************/
        /* upload PRICE.csv --> AS400 HWFILE1/FBEWP01   */
        /************************************************/
             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          Accounting/Upload/PRICE.csv') +
                          TOFILE(&FLIB/FBEWP01) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)

STP3:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&FLIB/FBEWP01) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('Price Data Is Empty! +
                          Please Check Price.csv.')
             CHGVAR VAR(&IN99) VALUE('1')
             GOTO CMDLBL(@DSP00)
             ENDDO

STP4:   /* Check Price Data Fields */
             OVRDBF     FILE(FBEWP01) TOFILE(&FLIB/FBEWP01)
             OVRDBF     FILE(FBEWP02) TOFILE(&FLIB/FBEWP02)
             OVRDBF     FILE(FBEWP03) TOFILE(&FLIB/FBEWP03)
             CALL       PGM(FBER01)  PARM(&TRUE &ERR &MSG1 &MSG2)

STP5:   /* If Error, send MSG2 and Exit Program */
             IF         COND(&ERR *EQ '1') THEN(DO)
             SNDPGMMSG  MSG(&MSG2) TOMSGQ(&WSID) MSGTYPE(*INQ)
                RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) MSG(&ANS)
             IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +
                          THEN(GOTO CMDLBL(STP7))
             IF         COND((&ANS *EQ 'd') *OR (&ANS *EQ 'D')) +
                          THEN(GOTO CMDLBL(STP9))
             IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +
                          THEN(GOTO CMDLBL(@CANCEL2))
             GOTO CMDLBL(@EXIT1)
             ENDDO


STP6:   /* If No Error, send MSG1 G or C */
             IF         COND(&ERR *EQ '0') THEN(DO)
                SNDPGMMSG  MSG(&MSG1) TOMSGQ(&WSID) MSGTYPE(*INQ)
                RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) MSG(&ANS)
                IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +
                           THEN(GOTO CMDLBL(STP7))
             GOTO CMDLBL(@CANCEL1)
             ENDDO


STP7:   /* Update Price */
        /* Set Printer to LANPRT03 -HOLD                     */
             DLTOVR     FILE(QPRINT)
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) OUTQ(LANPRT03) +
                          HOLD(*YES) USRDTA('COST_PRC2')

             OVRDBF     FILE(FBEWP02) TOFILE(&FLIB/FBEWP02)
             CALL       PGM(FBER02)

STP8:   /*********************************************************/
        /* BACKUP                                                */
        /* AS400 HWFILE1/FBEWP01 --> HWFILE1/FBEWP01BK           */
        /*********************************************************/
             CLRPFM     FILE(&FLIB/FBEWP01BK)
             CPYF       FROMFILE(&FLIB/FBEWP01) +
                          TOFILE(&FLIB/FBEWP01BK) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             SNDPGMMSG  MSG('Price data has been uploaded +
                          successfully. Confirm with Report output.')
             GOTO       CMDLBL(@EXIT1)

STP9:   /*********************************************************/
        /* DISPLAY ERROR MSG                                     */
        /*********************************************************/
             CALL       PGM(FBER03)
             GOTO       CMDLBL(STP5)

@CANCEL1:
             SNDPGMMSG  MSG('Job has been canceled without updating..')
             GOTO       CMDLBL(@EXIT1)

@CANCEL2:
             CHGSPLFA   FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST) OUTQ(LANPRT03)
             SNDPGMMSG  MSG('Job has been canceled without updating..')
             GOTO       CMDLBL(@EXIT1)

@EXIT1:
             CALL CHKC45 ('FBEC01 ' 'FBEC01 ' 'N'  '' '')
@ENDP:
             DLTOVR     FILE(*ALL)
             ENDPGM

             PGM
             /** KFAC22 ********************************************/
             /* PRINT LOCATION TAG BY CSV                          */
             /*                                                    */
             /* JW     05/18/2016 CODING (COPIED FROM KFAC20)      */
             /******************************************************/
             DCLF       FILE(KFAPW22)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10)
             DCL        VAR(&FLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERR)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG1)   TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSG2)   TYPE(*CHAR) LEN(80)
             DCL        VAR(&ANS )   TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&FLIB) VALUE('HWFILE1  ')
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 YTP0:
             CHKOBJ     OBJ(HFILE1/KFAC22) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(YTP1))

 YTP2:       SNDPGMMSG  MSG('( G ) PRINT LOCATION TAG +
                          IS ACTIVE, WAIT FOR A WHILE. < G= +
                          EXECUTION >') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'X') *OR (&KOTAE *EQ 'x')) +
                          THEN(GOTO CMDLBL(XEND))
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(YTP2))
             GOTO       SEND

 YTP1:       CRTDTAARA  DTAARA(HFILE1/KFAC22) TYPE(*CHAR) LEN(10) +
                          TEXT('PRINT LOCATION TAG') AUT(*ALL)
             MONMSG     MSGID(CPF1023)

             /*** DISPLAY INITIAL SCREEN ***/
 DSP01:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(XEND))
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(DSP01))

             /*** TRANSFER FROM J: ***/
             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          PC/Upload/LOCATION TEST.csv') +
                          TOFILE(&FLIB/KFAWP22) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)

        /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&FLIB/KFAWP22) NBRCURRCD(&REC)
        /*   IF         COND(&REC *EQ 0) THEN(DO)                      */
        /*   CHGVAR     VAR(&XMSG) VALUE('CSV Data Is Empty! Please +  */
        /*                Check LOCATION TAG.csv')                     */
        /*   CHGVAR VAR(&IN99) VALUE('1')                              */
        /*   GOTO CMDLBL(@DSP00)                                       */
        /*   ENDDO                                                     */
             /********** END *********/

             CLRPFM     FILE(KFAWP23)
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) OUTQ(LANPRT03) +
                          HOLD(*YES) USRDTA('LOC-TAG')
             OVRDBF     FILE(KFAWP22) TOFILE(&FLIB/KFAWP22)
             CALL       PGM(KFAR22) PARM(&ERR &MSG1 &MSG2)

RTN1:   /* If Error, send MSG2 and Exit Program */
             IF         COND(&ERR *EQ '1') THEN(DO)
                SNDPGMMSG  MSG(&MSG2) TOMSGQ(&WSID) MSGTYPE(*INQ)
             RCVMSG     MSGTYPE(*RPY) WAIT(120) MSG(&ANS)
                IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +
                           THEN(GOTO CMDLBL(XEND))
                IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +
                          THEN(GOTO CMDLBL(RTN2))
             GOTO CMDLBL(RTN1)
             ENDDO

RTN2:
        /*   CPYF       FROMFILE(KFAWP23) TOFILE(KFAWP20) +    */
        /*                MBROPT(*REPLACE) FMTOPT(*MAP *DROP)  */

 XEND:
             DLTDTAARA  DTAARA(HFILE1/KFAC22)
             MONMSG     MSGID(CPF2105)
 SEND:
             DLTOVR     FILE(*ALL)
             ENDPGM

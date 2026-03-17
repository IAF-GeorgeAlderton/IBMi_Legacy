             PGM
             /*** FBCC70A **************************************/
             /* TOYOTA APR UPLOAD (APR.CSV --> FBCWP70A        */
             /* JW (SRA)    2015.10.16                         */
             /* ------------------------                       */
             /* JW1         2022.11.11 ADD EXCLUCIVE CHECK     */
             /**************************************************/
             DCLF       FILE(FBCPW70A)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&ANS )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(8)

             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERR)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG1)   TYPE(*CHAR) LEN(60)
             DCL        VAR(&MSG2)   TYPE(*CHAR) LEN(60)
             DCL        VAR(&RTN1)   TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING & LOCK PROGRAM =================== */
             CALL CHKC45 ('FBCC70A' 'FBCC70A' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @EXIT0)
/* ================================================================ */

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&SYSTEM)
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1  ')
             CHGVAR     VAR(&LIBL) VALUE('HFILE1  ')

       /*    set Printer to LANPRT50                           */
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
       /*    set Printer to LANPRT03                           */
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) OUTQ(LANPRT03) +
                          HOLD(*NO)  USRDTA('TOYOTA-APR')
@DSP00:
       /* clear Work File                                      */
             CLRPFM     FILE(&WLIB/FBCWP70A)
             CLRPFM     FILE(&WLIB/FBCWP71A)
             CLRPFM     FILE(&WLIB/FBCWP72A)

             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

       /* CMD1: Exit  */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@CANCEL))

       /* CMD5: Start */
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP00))

STP1:   /*********************************************************/
        /* upload APR.csv --> AS400 &LIBL/FBCWP70A               */
        /*********************************************************/
             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          Sales/Upload/test/TOYOTA-APR.csv') +
                          TOFILE(&WLIB/FBCWP70A) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)

             MONMSG     MSGID(CPF2817) EXEC(DO)
             CHGVAR     VAR(&XMSG) VALUE('THE TARGET FILE IS EMPTY +
                          (L:..TOYOTA-APR.CSV) CANNOT USE...')
             CHGVAR VAR(&IN99) VALUE('1')
             GOTO CMDLBL(@DSP00)
             ENDDO

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&WLIB/FBCWP70A) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('TOYOTA APR Data Is Empty! +
                          Please Check APR.csv.')
             CHGVAR VAR(&IN99) VALUE('1')
             GOTO CMDLBL(@DSP00)
             ENDDO

STP3:   /* Program1: Check Price Data Fields */
             OVRDBF     FILE(FCEPL01) TOFILE(&LIBL/FCEPL01)
          /**OVRDBF     FILE(FBCWP70A) TOFILE(&WLIB/FBCWP70)**/
          /**OVRDBF     FILE(FBCWP71A) TOFILE(&WLIB/FBCWP71)**/
             CALL       PGM(FBCR70A)  PARM(&ERR &MSG1 &MSG2)


STP4:   /* If Error, send MSG2                  */
             IF         COND(&ERR *EQ '1') THEN(DO)
             CALL       PGM(UTLC97C) PARM(&MSG1 &MSG2)
             GOTO CMDLBL(@CANCEL)
             ENDDO

STP4X:  /* If Error, send MSG2 and Exit Program */
        /**  IF         COND(&ERR *EQ '1') THEN(DO)                   **/
        /**     SNDPGMMSG  MSG(&MSG2) TOMSGQ(&WSID) MSGTYPE(*INQ)     **/
        /**     RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) MSG(&ANS)         **/
        /**     IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +  **/
        /**                THEN(GOTO CMDLBL(@CANCEL))                 **/
        /**     IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +  **/
        /**               THEN(GOTO CMDLBL(STP6))                     **/
        /**  GOTO CMDLBL(STP4)                                        **/
        /**  ENDDO                                                    **/

STP5:   /* If No Error, send MSG G or C                               **/
        /**  IF         COND(&ERR *EQ '0') THEN(DO)                   **/
        /**  CALL       PGM(UTLC97) PARM(&MSG1 &MSG2 &ANS)            **/
        /**  IF         COND(&ANS *EQ 'C') THEN(GOTO CMDLBL(@CANCEL)) **/
        /**  IF         COND(&ANS *EQ 'G') THEN(GOTO CMDLBL(STP6))    **/
        /**  ENDDO                                                    **/

STP5X:  /* If No Error, send MSG G or C */
        /**  IF         COND(&ERR *EQ '0') THEN(DO)                 **/
        /**  SNDPGMMSG  MSG(&MSG1) TOMSGQ(&WSID) MSGTYPE(*INQ)      **/
        /**  RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) MSG(&ANS)          **/
        /**  IF         COND((&ANS *EQ 'c') *OR (&ANS *EQ 'C')) +   **/
        /**               THEN(GOTO CMDLBL(@CANCEL))                **/
        /**  IF         COND((&ANS *EQ 'g') *OR (&ANS *EQ 'G')) +   **/
        /**               THEN(GOTO CMDLBL(STP6))                   **/
        /**  GOTO CMDLBL(STP5)                                      **/
        /**  ENDDO                                                  **/


       /*    set Printer to LANPRT03 (HOLD)                    */
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) +
                          OUTQ(QGPL/APR_REPORT) HOLD(*YES) +
                          USRDTA('TOYOTA-APR')

STP6:   /* Program2: Update Price */

/*************************************/
/**** TEMP                           */
             GOTO       CMDLBL(@EXIT0)
/*************************************/

             CALL       PGM(FBCR71)

STP7:   /*********************************************************/
        /* BACKUP                                                */
        /* AS400 &LIBL/FBCWP70A --> &LIBL/FBCWP70BK              */
        /*********************************************************/
             CLRPFM     FILE(&WLIB/FBCWP70BK)
             CPYF       FROMFILE(&WLIB/FBCWP70A) +
                          TOFILE(&WLIB/FBCWP70BK ) MBROPT(*REPLACE) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             SNDPGMMSG  MSG('Price data has been uploaded +
                          successfully. Confirm with Report output.')
             GOTO       CMDLBL(@EXIT1)

@CANCEL:
             SNDPGMMSG  MSG('Job has been canceled without updating..')

@EXIT1:
/* JW1 CHECK UNLOCK PROGRAM ======================================= */
                CALL CHKC45 ('FBCC70A' 'FBCC70A' 'N'  '' '')
/* ================================================================ */

@EXIT0:
             DLTOVR     FILE(*ALL)
             ENDPGM

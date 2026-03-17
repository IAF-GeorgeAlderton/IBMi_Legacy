             PGM
             /** AB#C0J **********************************************/
             /*  REPORT EDI824 (ACKNOWLEDGEMENT)                     */
             /*         FOR HONDA/TOYOTA/GM                          */
             /*    H.AMANO       APR/17/02                           */
             /*  --------------------------------------------------  */
             /*    ADD TMS       MAY/10/04                           */
             /*    TCHK1 12/16/05 CHG E-MAIL RECEIVER                */
             /*    JW1   11/07/18 CHG ERROR MSG                      */
             /*    JW2   04/11/19 ADD DENSO FLAG                     */
             /*    JW3   05/17/19 STOP DENSO 824                     */
             /*    JW4   06/19/19 ADD CALL EDSR6M                    */
             /*    JW5   09/23/25 ADD CALL AB#CG6 (FORD 997)         */
             /********************************************************/
             DCL        VAR(&CNT)   TYPE(*DEC) LEN(10 0)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&HND)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&GEN)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&TMS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DENSO) TYPE(*CHAR) LEN(1)

 /*JW1*/     DCL        VAR(&ERR)  TYPE(*CHAR) LEN(21) VALUE(' ')
 /*JW1*/     DCL        VAR(&RTNH) TYPE(*CHAR) LEN(1)  VALUE(' ')
 /*JW1*/     DCL        VAR(&RTND) TYPE(*CHAR) LEN(1)  VALUE(' ')
 /*JW1*/     DCL        VAR(&RTNT) TYPE(*CHAR) LEN(1)  VALUE(' ')
 /*JW1*/     DCL        VAR(&RTNG) TYPE(*CHAR) LEN(1)  VALUE(' ')
 /*JW1*/     DCL        VAR(&MSG)  TYPE(*CHAR) LEN(120)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT)  OUTQ(SAVEOUTQ) HOLD(*YES)
             OVRPRTF    FILE(QPRINT2) OUTQ(SAVEOUTQ) HOLD(*YES)
             OVRPRTF    FILE(QPRINT5) OUTQ(SAVEOUTQ) HOLD(*YES)
             OVRPRTF    FILE(QPRINT6) OUTQ(SAVEOUTQ) HOLD(*YES)

     /*JW1   CALL       PGM(AB#R0J) PARM(&HND &GEN &TMS)                */
     /*JW2   CALL       PGM(AB#R0J) PARM(&HND &GEN &TMS &RTN)           */
     /*JW2   CALL       PGM(AB#R0J) PARM(&HND &GEN &TMS &DENSO &RTNH +  */
     /*                   &RTND &RTNT)                                  */
             CALL       PGM(AB#R0J) PARM(&GEN &RTNG &HND &RTNH &TMS +
                          &RTNT &DENSO &RTND)
 /* SAVE AB#PP6M */
             CALL       PGM(EDSR6M)

             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(QPRINT2)
             DLTOVR     FILE(QPRINT5)
             DLTOVR     FILE(QPRINT6)

             RTVMBRD    FILE(AB#PP6M) NBRCURRCD(&CNT)
             IF         COND(&CNT *EQ 0) THEN(GOTO CMDLBL(ENDP))

        /* JW4 ADD EDSR6M                                      */
        /*   CPYF       FROMFILE(AB#PP6M) TOFILE(AB#PPE1) +    */
        /*                MBROPT(*ADD)                         */
        /*   MONMSG     MSGID(CPF0000)                         */

/* (QPRINT: GENERAL)=======================================================*/

             IF         (&GEN *EQ '1') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)
/* JW1 */
             CHGVAR     VAR(&ERR) VALUE(' ')
             IF         COND(&RTNG *EQ '*') THEN(CHGVAR VAR(&ERR) +
                          VALUE('** REJECT CONTAINS **'))
             CHGVAR     VAR(&MSG) VALUE(&ERR *BCAT 'EDI 824 text +
                          message has been processed. Please check +
                          the attached list. (AB#C0J).')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI824Messagecommon@iafi.com)) +
                          DSTD('EDI 824 text message') MSG(&MSG) +
                          DOCFILE(HWFILE1/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('EDI824 +
                          text message')
             DLTOVR     FILE(PRT132)
             ENDDO

/* (QPRINT2: HONDA )=======================================================*/
             IF         (&HND *EQ '1') THEN(DO)
             CPYSPLF    FILE(QPRINT2) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)
/* JW1 */
             CHGVAR     VAR(&ERR) VALUE(' ')
             IF         COND(&RTNH *EQ '*') THEN(CHGVAR VAR(&ERR) +
                          VALUE('** REJECT CONTAINS **'))
             CHGVAR     VAR(&MSG) VALUE(&ERR *BCAT 'EDI 824 text +
                          message from HONDA has been processed. +
                          Please check the attached list. (AB#C0J).')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI824MessageHonda@iafi.com)) +
                          DSTD('HONDA EDI824 text message') +
                          MSG(&MSG) DOCFILE(HWFILE1/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('HONDA +
                          EDI824 text message')
             DLTOVR     FILE(PRT132)
             ENDDO

/* (QPRINT5: TMS ) ========================================================*/
             IF         (&TMS *EQ '1') THEN(DO)
             CPYSPLF    FILE(QPRINT5) TOFILE(HWFILE1/PRT132) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132)
             CALL       PGM(AB#RW0)
/* JW1 */
             CHGVAR     VAR(&ERR) VALUE(' ')
             IF         COND(&RTNT *EQ '*') THEN(CHGVAR VAR(&ERR) +
                          VALUE('** REJECT CONTAINS **'))
             CHGVAR     VAR(&MSG) VALUE(&ERR *BCAT 'EDI824 text +
                          message from TMS has been processed. +
                          Please check the attached list. (AB#C0J).')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI824MessageTMS@iafi.com)) +
                          DSTD('TMS EDI824 text message') MSG(&MSG) +
                          DOCFILE(HWFILE1/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('TMS EDI824 text message')
             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPRINT5) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO

/* (QPRINT6: DENSO )=======================================================*/
             GOTO SKIP1
/* JW3       **********                                                    */

     /* JW3  IF         (&DENSO *EQ '1') THEN(DO)                    */
     /*      CPYSPLF    FILE(QPRINT6) TOFILE(HWFILE1/PRT132) +       */
     /*                   JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)        */
     /*      OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132)          */
     /*      CALL       PGM(AB#RW0)                                  */
     /*                                                              */
     /*      CHGVAR     VAR(&ERR) VALUE('                     ')     */
     /*      IF         COND(&RTND *EQ '*') THEN(CHGVAR VAR(&ERR) +  */
     /*                   VALUE('** REJECT CONTAINS **'))            */
     /*                                                              */
     /*      CHGVAR     VAR(&MSG) VALUE(&ERR *BCAT 'EDI 824 text +   */
     /*                   message from DENSO has been processed. +   */
     /*                   Please check the attached list. (AB#C0J).')*/
     /*                                                              */
     /*      SNDDST     TYPE(*FILE) +                                */
     /*                   TOINTNET((EDI824MessageTMS@iafi.com)) +    */
     /*                   DSTD('DENSO EDI 824 text message') +       */
     /*                   MSG(&MSG) DOCFILE(HWFILE1/PRT132A) +       */
     /*                   DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('DENSO EDI824 +*/
     /*                   text message')                  */
     /*                                                              */
     /*      DLTOVR     FILE(PRT132)                                 */
     /*      DLTSPLF    FILE(QPRINT6) JOB(&NBR/&USER/&WSID) +        */
     /*                   SPLNBR(*LAST)                              */
     /*      MONMSG     MSGID(CPF0000)                               */
     /*      ENDDO                                                   */
SKIP1:

  /* GM */
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(AB#RE1)

             RTVMBRD    FILE(AB#PP6O) NBRCURRCD(&CNT)
             IF         (&CNT *GT 0) THEN(DO)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

/* TCHK1 S */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI824MessageGM@iafi.com)) +
                          DSTD('APERAK EDI824 message') MSG('EDI +
                          text message (APERAK) has been +
                          processed.  Please check the attached +
                          list. (AB#C0J).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('APERAK EDI824 text +
                          message')
/* TCHK1 E */
             ENDDO

             DLTOVR     FILE(*ALL)

/** FOR DENSO EDI824 **/
             CALL       PGM(AB#C1R)

ENDP:

/** JW5 FORD 997 REPORT  **/
             CALL       PGM(AB#CG6)

             ENDPGM

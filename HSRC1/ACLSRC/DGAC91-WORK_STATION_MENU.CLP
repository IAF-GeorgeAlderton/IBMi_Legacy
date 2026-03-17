             PGM
             /** DGAC90 *************************************/
             /*  ..WORK STATION MENU                        */
             /*  ..THIS PROGRAM CHECK EXCLUSIVE 1 MACHINE   */
             /*  .. DGAC91->NO CHECK                        */
             /*     I-HASADA                   94.02.15     */
             /*  JW1   2019.10.11 ADD LOG (UTLR07C)         */
             /************************************* DGAC90 **/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DV1) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DV2) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PROF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PRID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HIZK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCL) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MNNO) TYPE(*CHAR) LEN(2)

             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSNO) USER(&PROF) NBR(&JOBN) DATE(&HIZK)

             /*-----------------*/
             /*   ..CHGMSGQ..   */
             /*-----------------*/
             IF         (&WSNO *EQ 'DSP01     ') DO
             CHGMSGQ    MSGQ(QSYSOPR) DLVRY(*BREAK)
             MONMSG     MSGID(CPF2451)
             ENDDO
             IF         (&PROF *EQ 'I0010 ') DO
             CHGLIBL    LIBL(QGPL QTEMP QMGU QPCFSU TOBJ1 TFILE1 +
                          TWFILE1 TJRN1 HSRC1)
             MONMSG     MSGID(CPF2451)
             ENDDO

             CHGMSGQ    MSGQ(&WSNO) DLVRY(*BREAK)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             IF         COND(&PRT *EQ 'QPRINT') THEN(CHGVAR +
                          VAR(&DV1) VALUE('P1'))
             IF         COND(&PRT *EQ 'QPRINTA') THEN(CHGVAR +
                          VAR(&DV1) VALUE('PA'))
             IF         COND(&PRT *EQ 'QPRINTB') THEN(CHGVAR +
                          VAR(&DV1) VALUE('PB'))
             IF         COND(&PRT *EQ 'QPRINTC') THEN(CHGVAR +
                          VAR(&DV1) VALUE('PC'))
             IF         COND(&PRT *EQ 'QPRINTD') THEN(CHGVAR +
                          VAR(&DV1) VALUE('PD'))

             IF         COND(&PRTG *EQ 'QPRINT') THEN(CHGVAR +
                          VAR(&DV2) VALUE('P1'))
             IF         COND(&PRTG *EQ 'QPRINTA') THEN(CHGVAR +
                          VAR(&DV2) VALUE('PA'))
             IF         COND(&PRTG *EQ 'QPRINTB') THEN(CHGVAR +
                          VAR(&DV2) VALUE('PB'))
             IF         COND(&PRTG *EQ 'QPRINTC') THEN(CHGVAR +
                          VAR(&DV2) VALUE('PC'))
             IF         COND(&PRTG *EQ 'QPRINTD') THEN(CHGVAR +
                          VAR(&DV2) VALUE('PD'))

             /*-------------------------*/
             /*   ..SERIAL PRINTER START ..*/
             /*-------------------------*/
             CALL       PGM(RGAC00)

             CHGVAR     VAR(&WSID) VALUE(%SUBSTRING(&WSNO 1 5))
             CALL       PGM(DGAR01) PARM(&WSNO &PRT &PROF &NAME &TIME +
                          &PRID)

             CHGVAR     VAR(&PGM) VALUE('DGAC91    ')
             CALL       PGM(UTLR07C) PARM('MENU' &PGM 'START MENU' ' ')

 STEP0:
             IF         (&PROF *EQ 'I0023 ') DO
                        CHGVAR VAR(&PRTG) VALUE('QPRINTD')
             ENDDO
             CHGJOB     OUTQ(&PRTG)

             /*------------------------------------*/
             /*   ..RPG3 MENU SCREEN DISPLAY..     */
             /*------------------------------------*/
             CHGVAR     VAR(&PSYS) VALUE(' ')

             CALL       PGM(EGBR02) PARM(&PROF &HIZK &TIME &WSID +
                          &PRID &NAME &JOBN &PSYS &PCL &MNNO)

             /*-------------------------------------*/
             /*   ..OPERATION ASSISTANCE COMMAND EXECTION */
             /*-------------------------------------*/
             IF         (&PSYS *EQ 'S') GOTO STEP1
             IF         (&PSYS *EQ 'P') GOTO STEP2
             IF         (&PSYS *EQ 'G') GOTO STEP2G
             IF         (&PSYS *EQ 'M') GOTO STEP3
             IF         (&PSYS *EQ 'D') GOTO STEP5
             GOTO       STEP6

             /*---------------------------------*/
             /*   ..RETURN TO COMMAND INPUT SCREEN */
             /*---------------------------------*/
 STEP1:      RETURN
             GOTO       ENDP

             /*-----------------------------------*/
             /*   ..OUTQ DISPLAY FOR KANA PRINTER */
             /*-----------------------------------*/
/* STEP2:      WRKOUTQ    OUTQ(&PRT)    */
 STEP2:      WRKSPLF    SELECT(*CURRENT &DV1)
             MONMSG     MSGID(CPF0001)
             GOTO       STEP0

             /*------------------------------------*/
             /*   ..OUTQ DISPLAY FOR KANJI PRINTER */
             /*------------------------------------*/

 /* STEP2G:     WRKOUTQ    OUTQ(&PRTG)     */
 STEP2G:     WRKSPLF    SELECT(*CURRENT &DV2)
             MONMSG     MSGID(CPF0001)
             GOTO       STEP0

             /*----------------------------------*/
             /*   ..WORK STATION MSGQ DISPLAY       */
             /*----------------------------------*/
 STEP3:      DSPMSG
             GOTO       STEP0

             /*-----------------------------*/
             /*   ..RETURN TO A SCREEN OF SIGN-OFF */
             /*-----------------------------*/
 STEP5:      RMVMSG     MSGQ(&WSNO) CLEAR(*ALL)

             IF         COND(%SST(&WSNO 1 1) *EQ 'X') THEN(DO)
                 ENDPASTHR  LOG(*LIST)
                 MONMSG     MSGID(CPF8914 CPF8915)
             ENDDO

             IF         COND(%SST(&WSNO 1 1) *EQ 'F') THEN(DO)
                 ENDPASTHR  LOG(*LIST)
                 MONMSG     MSGID(CPF8914 CPF8915)
             ENDDO

    /*JW     SIGNOFF    LOG(*LIST)   */

             GOTO       ENDP

             /*----------------------------------------*/
             /*   ..EXECUTE PGM APPOINTED BY A MENU  */
             /*----------------------------------------*/
 /*JW1*/
 STEP6:      CHGVAR     VAR(&PGM) VALUE(&PCL)
             CALL       PGM(UTLR07B) PARM(&PGM '')
             CALL       PGM(UTLR07C) PARM('PGM ' &PGM 'START PGM ' ' ')

             CALL       PGM(&PCL)
             MONMSG     MSGID(CPD0170 CPF0001) EXEC(DO)

             CALL       PGM(UTLR07C) PARM('PGM ' &PGM 'ERROR     ' ' ')

 STEP11:     SNDUSRMSG  MSG('THERE IS NOT SELECTED PGM IN MENU +
                          CONFIRM MENU INPUT THAT IS NOT WRONG TO +
                          BOSS') VALUES('G') MSGTYPE(*INQ) +
                          TOMSGQ(&WSNO) MSGRPY(&RPY)
             IF         COND((&RPY *NE 'G') *AND (&RPY *NE 'g')) +
                          THEN(GOTO CMDLBL(STEP11))
             GOTO       STEP0
             ENDDO

             CALL       PGM(UTLR07C) PARM('PGM ' &PGM 'END   PGM ' ' ')

             GOTO       STEP0

 ENDP:
             CHGVAR     VAR(&PGM) VALUE('DGAC91    ')
             CALL       PGM(UTLR07C) PARM('MENU' &PGM 'END   MENU' ' ')

             SIGNOFF    LOG(*LIST)

             ENDPGM

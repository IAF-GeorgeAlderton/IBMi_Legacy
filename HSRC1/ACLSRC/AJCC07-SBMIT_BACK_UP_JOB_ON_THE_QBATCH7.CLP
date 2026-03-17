             PGM
             /** AJCC07 ******************************************************/
             /* SBMIT BACK-UP JOB ON THE QBATCH7                             */
             /*   TCH 00.06.19                                               */
             /****************************************************** AJCC02 **/
             DCLF       FILE(AJCPW07)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RQS) TYPE(*CHAR) LEN(80)
             DCL        VAR(&DG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JIKN) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID)

    /* JW CHG 2:30:00 TO 2:20:00)  */
             CHGVAR     VAR(&JIKN) VALUE('022000')
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AJCPW071)

             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

             IF         COND(&JIKN *EQ '      ') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             IF         COND(&JIKN *LT '000001') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             IF         COND(&JIKN *GT '240000') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&DG) VALUE(%SUBSTRING(&JIKN 1 1))
             IF         COND(&DG *LT '0' *OR &DG *GT '9') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&DG) VALUE(%SUBSTRING(&JIKN 2 1))
             IF         COND(&DG *LT '0' *OR &DG *GT '9') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&DG) VALUE(%SUBSTRING(&JIKN 3 1))
             IF         COND(&DG *LT '0' *OR &DG *GT '9') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&DG) VALUE(%SUBSTRING(&JIKN 4 1))
             IF         COND(&DG *LT '0' *OR &DG *GT '9') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&DG) VALUE(%SUBSTRING(&JIKN 5 1))
             IF         COND(&DG *LT '0' *OR &DG *GT '9') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&DG) VALUE(%SUBSTRING(&JIKN 6 1))
             IF         COND(&DG *LT '0' *OR &DG *GT '9') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

 /*          IF         COND(&EDAT *EQ '      ') THEN(DO)  */
 /*          CHGVAR     VAR(&IN99) VALUE('1')              */
 /*          GOTO       CMDLBL(STP1)                       */
 /*          ENDDO                                         */

             IF         COND((&IN01 *NE '1') *AND (&IN05 *NE '1')) +
                          THEN(GOTO CMDLBL(STP1))


             CHGVAR     VAR(&RQS) VALUE('CALL AJCC08 (''' *CAT +
                           &JIKN *CAT ''')')

             IF         COND(&IN05 *EQ '1') THEN(SBMJOB JOB(BACKUP) +
                          JOBD(QBATCH7) JOBQ(JOBQ7) RQSDTA(&RQS) +
                          CURLIB(HOBJ1) INLLIBL(HOBJ1 HFILE1 QGPL))

 END:        ENDPGM

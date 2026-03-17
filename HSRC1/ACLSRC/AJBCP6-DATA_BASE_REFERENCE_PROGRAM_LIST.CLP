             PGM
             /** AJBCP6 **************************/
             /* DATA BASE REFERENCE PROGRAM LIST */
             /*   I-HASADA            87.05.21   */
             /************************** AJBCP6 **/
             DCLF       FILE(AJBPWP5)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JDATA) TYPE(*CHAR) LEN(80)
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&JOBQ) VALUE('2')

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    RCDFMT(AJBPWP51)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&JOBQ *EQ '0') GOTO STP2
             IF         (&JOBQ *EQ '1') GOTO STP2
             IF         (&JOBQ *EQ '2') GOTO STP2
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('JOBQ --> ( 0 =SRT . 1 = +
                          JOBQ1 . 2 = JOBQ2 )')
             GOTO       STP1

 STP2:       IF         (&IN05 *EQ '0') GOTO STP1

             IF         (&JOBQ *EQ '0') DO
             CALL       PGM(AJBCJ6) PARM(&PRTG)
             GOTO       END
             ENDDO

             CHGVAR     VAR(&JDATA) VALUE('CALL PGM(AJBCJ6) +
                          PARM(''' *CAT &PRTG *CAT ''')')

             IF         (&JOBQ *EQ '1') DO
             SBMJOB     JOB(JOBQ1) JOBD(QBATCH1) JOBQ(JOBQ1) +
                          RTGDTA(*JOBD) RQSDTA(&JDATA) INLLIBL(*JOBD)
             GOTO       END
             ENDDO

             IF         (&JOBQ *EQ '2') DO
             SBMJOB     JOB(JOBQ2) JOBD(QBATCH2) JOBQ(JOBQ2) +
                          RTGDTA(*JOBD) RQSDTA(&JDATA) INLLIBL(*JOBD)
             ENDDO

 END:        ENDPGM

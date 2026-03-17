             PGM
             /***MBECP1********************************************/
             /*        SALES TENTATIVE REPORT MONTHLY HANDLING MAIN OP-EDP */
             /*            M-OKUDA        1981.10.10              */
             /*****************************************************/
             DCLF       FILE(MBEPW11) RCDFMT(MBEPW111)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&HZ)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&YM)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&YN)    TYPE(*DEC) LEN(2 0)
             DCL        VAR(&YY)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&MM)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IN99)  TYPE(*LGL) LEN(1)
             DCL        VAR(&JDATA) TYPE(*CHAR) LEN(80)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7) VALUE(QPRINT)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&HZ)
             CHGJOB     RUNPTY(40)

             CHGVAR     VAR(&YM) VALUE(%SUBSTRING(&HZ 1 4))
             CHGVAR     VAR(&YY) VALUE(%SUBSTRING(&HZ 1 2))
             CHGVAR     VAR(&MM) VALUE(%SUBSTRING(&HZ 3 2))

             IF         (&MM *NE '01') GOTO STEP00
             CHGVAR     VAR(&YN) VALUE(&YY)
             CHGVAR     VAR(&YN) VALUE(&YN - 1)
             CHGVAR     VAR(&YY) VALUE(&YN)
             CHGVAR     VAR(&MM) VALUE('12')
             CHGVAR     VAR(%SUBSTRING(&YM 1 2)) VALUE(&YY)
             CHGVAR     VAR(%SUBSTRING(&YM 3 2)) VALUE(&MM)
             GOTO       STEPAA

STEP00:      CHGVAR     VAR(%SUBSTRING(&YM 1 2)) VALUE(&YY)
             CHGVAR     VAR(&YN) VALUE(&MM)
             CHGVAR     VAR(&YN) VALUE(&YN - 1)
             CHGVAR     VAR(&MM) VALUE(&YN)
             CHGVAR     VAR(%SUBSTRING(&YM 3 2)) VALUE(&MM)

STEPAA:      RTVJOBA    JOB(&WSID) USER(&US)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&JOBQ) VALUE('0')

 STEP1:      SNDRCVF    DEV(&WSID) RCDFMT(MBEPW111)
             IF         (&IN01 = '1') GOTO END

             CHGVAR     VAR(&IN99) VALUE('0')
/* GBC IF               (%SUBSTRING(&HIZK 1 2) *NE &YY) GOTO STEP7 */
/* GBC IF               (%SUBSTRING(&HIZK 1 4) > &YM) GOTO STEP8 */
             IF         (%SUBSTRING(&HIZK 5 2) < '01') GOTO STEP9
             GOTO       STEP13

 STEP7:      CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE YEAR OF INPUT DATE IS WRONG')
             GOTO       STEP1

 STEP8:      CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATA OF INPUT DATE CAN NOT BE +
                                         MADE YET')
             GOTO       STEP1

 STEP9:      CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE MONTH OF INPUT DATE IS +
                                         SMALLER THAN 01. CHANGE IT ')
             GOTO       STEP1

 STEP13:     IF         (&JOBQ *EQ '2') GOTO STEP2
             IF         (&JOBQ *EQ '1') GOTO STEP2
             IF         (&JOBQ *EQ '0') GOTO STEP2
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SELECTION OF JOBQ IS WRONG +
                          INPUT 1-SRT.2-JOBQ1.2-JOBQ2')
             GOTO       STEP1

 STEP2:      DLTF     FILE(MBEWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF     FILE(MBEWP12)
             MONMSG     MSGID(CPF3261 CPF2105)

             CHGVAR     VAR(&JDATA) VALUE('CALL PGM(MBECJ1) +
                          PARM(''' *CAT &HIZK *CAT ''' ''' *CAT &PRT +
                          *CAT ''' ''' *CAT &US *CAT ''')')
             IF         (&JOBQ *EQ '2') GOTO STEP3
             IF         (&JOBQ *EQ '1') GOTO STEP4
             GOTO       STEP5

 STEP3:      SBMJOB     JOB(JOBQ2) JOBD(QBATCH2) JOBQ(JOBQ2) +
                          RTGDTA(*JOBD) RQSDTA(&JDATA) INLLIBL(*JOBD)
             GOTO END

 STEP4:      SBMJOB     JOB(JOBQ1) JOBD(QBATCH1) JOBQ(JOBQ1) +
                          RTGDTA(*JOBD) RQSDTA(&JDATA) INLLIBL(*JOBD)
             GOTO END

 STEP5:      CALL       PGM(MBECJ1) PARM(&HIZK &PRT &US)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM

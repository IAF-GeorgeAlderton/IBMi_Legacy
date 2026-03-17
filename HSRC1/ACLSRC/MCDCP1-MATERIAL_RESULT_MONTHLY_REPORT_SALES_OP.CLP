             PGM
             /*** MCDCP1 ******************************************/
             /* MATERIAL RESULT MONTHLY REPORT   SALES OP-EDP */
             /*            M-OKUDA        1981.09.03              */
             /*            N-HYOTO        2001.03.06              */
             /* JW1     --> SET DEFAULT DATE (LAST MONTHEND)      */
             /*****************************************************/
             DCLF       FILE(MCDPW11) RCDFMT(MCDPW111)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG)   TYPE(*CHAR) LEN(60)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&IN99)  TYPE(*LGL)  LEN(1)
             DCL        VAR(&IN91)  TYPE(*LGL)  LEN(1)
             DCL        VAR(&IN92)  TYPE(*LGL)  LEN(1)
             DCL        VAR(&JDATA) TYPE(*CHAR) LEN(80)
             DCL        VAR(&SHIZ6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SHIZK) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)

             DCL        VAR(&DATE1)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DATE2)  TYPE(*CHAR) LEN(8)

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SHIZ6)
         /*  CALL       PGM(CNVRDT)   PARM(&SHIZK) */
             CVTDAT     DATE(&SHIZ6) TOVAR(&SHIZK) FROMFMT(*SYSVAL) +
                          TOFMT(*YYMD) TOSEP(*NONE)
             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGVAR     VAR(&PRTG) VALUE('MONTHLY   ')

             CHKOBJ     OBJ(MCDACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@001))

 @002:       SNDPGMMSG  MSG('( G ) MATERIAL USED RESULT DATA INQUIRY +
                        BECAUSE PGM IS RUNNUNG,PLEASE CONTACT YOU TO ITO!!') +
                          TOMSGQ(&WS) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(@002))
             GOTO @END

 @001:       CRTDTAARA  DTAARA(HFILE1/MCDACT) TYPE(*CHAR) LEN(1) +
                          TEXT('MATERIAL USED RESULT DATA CREATING')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN91) VALUE('0')
             CHGVAR     VAR(&IN92) VALUE('0')
             CHGVAR     VAR(&JOBQ) VALUE('1')

/**JW1 SET LAST MONTH END DATE */
             CALL       PGM(UTLR24B) PARM(&DATE1 &DATE2)
             CHGVAR     VAR(&HIZU) VALUE(&DATE2)

 STEP1:      SNDRCVF    DEV(&WS) RCDFMT(MCDPW111)
             IF         (&IN01 = '1') GOTO END

             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN91) VALUE('0')
             CHGVAR     VAR(&IN92) VALUE('0')

             IF         (&HIZU > '198109') GOTO STEP3
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT MAKING DATE IS NOT +
                          YYMM,INPUT')
             GOTO       STEP1

 STEP3: /*GBCIF         (%SUBSTRING(&SHIZK 1 6) < &HIZU) GOTO STEP5 */
             IF         (%SUBSTRING(&HIZU 5 2) > '12') GOTO STEP4
             IF         (%SUBSTRING(&HIZU 5 2) < '01') GOTO STEP4
             IF       (&JOBQ *EQ '2') GOTO STEP2
             IF       (&JOBQ *EQ '1') GOTO STEP2
             IF       (&JOBQ *EQ '0') GOTO STEP2
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SELECTION OF JOBQ IS WRONG +
                          INPUT 1-SRT.2-JOBQ1.2-JOBQ2')
             GOTO STEP1

 STEP4:      CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT MAKING DATE <MM>IS +
                          01 NOT RANGE OF FROM 12.CHANGE IT')
             GOTO       STEP1

 STEP5:      CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT DATE IS FUTURE DATE.+
                          IT IS IMPOSSIBLE TO HANDLING')
             GOTO       STEP1

 STEP2:      DLTF       FILE(MCDWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(MCDWP12)
             MONMSG     MSGID(CPF3261 CPF2105)

             CHGVAR     VAR(&JDATA) VALUE('CALL PGM(MCDCJ1) PARM(''' +
                          *CAT &HIZU *CAT ''' ''' *CAT &PRTG *CAT +
                          ''' ''' *CAT &PDEVT *CAT ''' ''' *CAT +
                          &PIGCD *CAT ''')')
             IF       (&JOBQ *EQ '2') GOTO STEP6
             IF       (&JOBQ *EQ '1') GOTO STEP7
             GOTO STEP8

 STEP6:
             IF         (&US   *EQ 'TEST      ') DO
             SBMJOB     JOB(JOBQ2) JOBD(QBATCH2) JOBQ(JOBQ2) +
                          RTGDTA(*JOBD) RQSDTA(&JDATA) INLLIBL(QGPL +
                          QTEMP QMGU QPCFSU TOBJ1 TFILE1 TWFILE1 +
                          HJRN1 HSRC1)
             GOTO END

 STEP61:
             SBMJOB     JOB(JOBQ2) JOBD(QBATCH2) JOBQ(JOBQ2) +
                          RTGDTA(*JOBD) RQSDTA(&JDATA) INLLIBL(*JOBD)
             GOTO END
             ENDDO

 STEP7:
             IF         (&US   *EQ 'TEST      ') DO
             SBMJOB     JOB(JOBQ1) JOBD(QBATCH1) JOBQ(JOBQ1) +
                          RTGDTA(*JOBD) RQSDTA(&JDATA) INLLIBL(QGPL +
                          QTEMP QMGU QPCFSU TOBJ1 TFILE1 TWFILE1 +
                          HJRN1 HSRC1)
             GOTO END

 STEP71:
             SBMJOB     JOB(JOBQ1) JOBD(QBATCH1) JOBQ(JOBQ1) +
                          RTGDTA(*JOBD) RQSDTA(&JDATA) INLLIBL(*JOBD)
             GOTO END
             ENDDO

 STEP8:      CALL       PGM(MCDCJ1) PARM(&HIZU &PRTG &PDEVT &PIGCD)

 END:        DLTDTAARA  DTAARA(MCDACT)

 @END:       ENDPGM

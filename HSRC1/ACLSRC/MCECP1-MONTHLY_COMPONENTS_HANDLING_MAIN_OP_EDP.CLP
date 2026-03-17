             PGM
             /***MCECP1********************************************/
             /* MONTHLY COMPONENTS HANDLING     MAIN OP-EDP */
             /*            M-OKUDA        1981.10.10              */
             /*            N-HYOTO        2001.04.05              */
             /* JW1     --> SET DEFAULT DATE (LAST MONTHEND)      */
             /*****************************************************/
             DCLF       FILE(MCEPW11) RCDFMT(MCEPW111)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(60)
             DCL        VAR(&IN99) TYPE(*LGL) LEN(1)
             DCL        VAR(&JDATA) TYPE(*CHAR) LEN(80)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&DATE1)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DATE2)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US   &WLIB)

             CHGVAR     VAR(&JOBQ) VALUE('1')

/**JW1 SET LAST MONTH END DATE */
             CALL       PGM(UTLR24B) PARM(&DATE1 &DATE2)
             CHGVAR     VAR(&HIZU) VALUE(&DATE2)

STEP1:       SNDRCVF  DEV(&WSID) RCDFMT(MCEPW111)
             IF         (&IN01 = '1') GOTO END
             CHGVAR     VAR(&IN99) VALUE('0')
             IF     COND((&HIZU < '198109')) THEN(CHGVAR VAR(&IN99) +
                     VALUE('1'))
             IF     (&HIZU < '198109') CHGVAR VAR(&MSG) +
                          VALUE('INPUT MAKING DATE IS NOT YYMM +
                                 INPUT IT ')
             IF         (&HIZU < '198109') GOTO STEP1

             IF       (&JOBQ *EQ 2) GOTO STEP2
             IF       (&JOBQ *EQ 1) GOTO STEP2
             IF       (&JOBQ *EQ 0) GOTO STEP2
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SELECTION OF JOBQ IS WRONG.+
                          INPUT 1-SRT.2-JOBQ1.2-JOBQ2')
             GOTO STEP1

 STEP2:      DLTF       FILE(MCEWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(MCEWP12)
             MONMSG     MSGID(CPF3261 CPF2105)

             CHGVAR     VAR(&JDATA) VALUE('CALL PGM(MCECJ1) PARM(''' +
                          *CAT &HIZU *CAT ''' ''' *CAT &PRTG *CAT +
                          ''' ''' *CAT &PDEVT *CAT ''' ''' *CAT +
                          &PIGCD *CAT ''')')
             CHGDTAARA  DTAARA(MCEDS1) VALUE(%SST(&HIZU 1 6))

             IF       (&JOBQ *EQ 2) GOTO STEP6
             IF       (&JOBQ *EQ 1) GOTO STEP7
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

 STEP8:      CALL       PGM(MCECJ1) PARM(&HIZU &PRTG &PDEVT &PIGCD)

 END:        ENDPGM

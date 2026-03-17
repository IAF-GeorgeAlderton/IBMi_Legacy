             PGM
             /** BCECP2 *******************************************/
             /* DELIVERY MONTHLY REPORT CREATE MAIN OP-EDP        */
             /*            M-OKUDA        1981.10.10              */
             /*                                                   */
             /* JANUARY --> NEW TAPE   11/19/2004 (TCH)           */
             /* JW1     --> SET DEFAULT DATE (LAST MONTHEND)      */
             /******************************************* BCECP2 **/
             DCLF       FILE(MCEPW21) RCDFMT(MCEPW211)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&IN91) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN92) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN93) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN94) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN99) TYPE(*LGL) LEN(1)
             DCL        VAR(&JDATA) TYPE(*CHAR) LEN(80)
             DCL        VAR(&YEAR)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&MSG1)   TYPE(*CHAR) LEN(34)

             DCL        VAR(&DATE1)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DATE2)  TYPE(*CHAR) LEN(8)

             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&PAT) VALUE('1')
             CHGVAR     VAR(&RERUN) VALUE('0')
             CHGVAR     VAR(&JOBQ) VALUE('1')

/**JW1 SET LAST MONTH END DATE */
             CALL       PGM(UTLR24B) PARM(&DATE1 &DATE2)
             CHGVAR     VAR(&SIME) VALUE(&DATE2)

STEP1:       SNDRCVF  DEV(&WSID) RCDFMT(MCEPW211)

             IF       (&IN01 *EQ '1') RETURN
             CHGVAR   VAR(&IN91) VALUE('0')
             CHGVAR   VAR(&IN92) VALUE('0')
             CHGVAR   VAR(&IN93) VALUE('0')
             CHGVAR   VAR(&IN94) VALUE('0')
             CHGVAR   VAR(&IN99) VALUE('0')

             IF         COND(%SUBSTRING(&SIME 1 4) < '1981') +
                          THEN(GOTO CMDLBL(STEP7))
             IF         (%SUBSTRING(&SIME 5 2) < '01') GOTO STEP9
             IF         (%SUBSTRING(&SIME 5 2) > '12') GOTO STEP10
             IF         COND(%SUBSTRING(&SIME 7 2) < '01') THEN(GOTO +
                          CMDLBL(STEP11))
             IF         (%SUBSTRING(&SIME 7 2) > '31') GOTO STEP12

             IF         (&RERUN *EQ '1') GOTO STEP13
             IF         (&RERUN *EQ '0') GOTO STEP13
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT OF RE-RUN APPOINTED +
                          MUST BE 0 OR 1.')
             GOTO       STEP1

 STEP7:      CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT YEAR OF DATE WITH +
                          SMALLER THAN 81.')
             GOTO STEP1

 STEP9:      CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT MONTH OF DATE IS +
                          SMALLER THAN 01. CHANGE IT.')
             GOTO       STEP1

 STEP10:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT MONTH OF DATE IS +
                          BIGGER THAN 12. CHANGE IT.')
             GOTO       STEP1

 STEP11:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT DAY OF DATE IS +
                          SMALLER THAN 01. CHANGE IT.')
             GOTO       STEP1

 STEP12:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT DAY OF DATE IS +
                          BIGGER THAN 31. CHANGE IT.')
             GOTO       STEP1

 STEP13:     IF         (&PAT *EQ '1') GOTO STEP23
             IF         (&PAT *EQ '2') GOTO STEP23
             IF         (&PAT *EQ '3') GOTO STEP23
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN93) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT LIST NUMBER OF +
                          COPIES IS ERROR. < FROM 1 TO 3 >')
             GOTO       STEP1

 STEP23:     IF         (&RERUN *EQ '0') DO
             IF         COND(%SST(&MCEDP01 1 6) *EQ (%SST(&SIME 1 +
                          6))) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE TRANSACTION ON THIS DAY +
                          HAS BEEN DONE, EXECUT RE-RUN')
             GOTO       STEP1
             ENDDO
             ENDDO

             IF         COND(%SUBSTRING(&SIME 5 2) *EQ '01' *AND +
                          &RERUN *EQ '0') THEN(DO)
             CHGVAR     VAR(&CMT) VALUE('MAKE SURE THE TAPE IS NEW. +
                          IT WILL BE INITIALISED.')
             ENDDO
             IF         COND(%SUBSTRING(&SIME 5 2) *GT '01' *AND +
                          &RERUN *EQ '0') THEN(DO)
             CHGVAR     VAR(&YEAR) VALUE(%SUBSTRING(&SIME 1 4))
             CHGVAR     VAR(&MSG1) VALUE('MAKE SURE THE TAPE IS THE +
                          YEAR OF ')
             CHGVAR     VAR(&CMT) VALUE(&MSG1 *CAT &YEAR)
             ENDDO

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(STEP1))


             CHGVAR     VAR(&JDATA) VALUE('CALL PGM(BCECJ2) PARM(''' +
                          *CAT &SIME *CAT ''' ''' *CAT &RERUN *CAT +
                          ''' ''' *CAT &PRTG *CAT ''' ''' *CAT &PAT +
                          *CAT ''')')

             IF         (&JOBQ = '0') GOTO STEP14
             IF         (&JOBQ = '1') GOTO STEP15
             IF         (&JOBQ = '2') GOTO STEP16

             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN94) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT SELECTION OF JOBQ +
                          IS WRONG. CHANGE IT.')
             GOTO       STEP1

 STEP14:     CALL       PGM(BCECJ2) PARM(&SIME &RERUN &PRTG &PAT)
             GOTO       STEP17

 STEP15:     SBMJOB     JOB(JOBQ1) JOBD(QBATCH1) JOBQ(JOBQ1) +
                          RTGDTA(*JOBD) RQSDTA(&JDATA) INLLIBL(*JOBD)
             GOTO       STEP17

 STEP16:     SBMJOB     JOB(JOBQ2) JOBD(QBATCH2) JOBQ(JOBQ2) +
                          RTGDTA(*JOBD) RQSDTA(&JDATA) INLLIBL(*JOBD)

 STEP17:     ENDPGM

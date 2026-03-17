             /** EJKC50 ********************************/
             /*     B2B_S   SENDING PROCESS            */
             /*    **ORIGINAL IS JK500C FROM ASJ**     */
             /*  T.SAKAKI            2016.10.12        */
             /************************ EJKC01 **********/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&OBJL)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&QDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&QTIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&EDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ETIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&EDTM) TYPE(*CHAR) LEN(20)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&WNBR)
             CHGJOB     RUNPTY(20)

        /*--------------------------------------------*/
        /*  CHANGE ENVIRONMENT IF TEST USER USES      */
        /*--------------------------------------------*/
             CALL       PGM(ALBC02) PARM(&USER &OBJL)

       /*---------------*/
       /* JOB CRTDTAARA */
       /*---------------*/
             CRTDTAARA  DTAARA(&OBJL/EJKC50ACT) TYPE(*CHAR) LEN(10) +
                          TEXT('B2B_R  PROCESSING')
        /* DUPLICATED SUBMIT */
             MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(@END))


@STP1:       DLYJOB     DLY(10)

       /*-------------------*/
       /* PROCESS CRTDTAARA */
       /*-------------------*/
             CRTDTAARA  DTAARA(&OBJL/EJKC50RUN) TYPE(*CHAR) LEN(10) +
                          TEXT('B2B_S  PROCESSING')

       /********************************/
       /* OBSERVATION FOR ABNORMAL END */
       /********************************/
             CALL       PGM(EJKC55) PARM('B2B_S     ')

       /*******************/
       /* SENDING PROCESS */
       /*******************/
             CALL       PGM(EJKC51)

       /*-------------------*/
       /* PROCESS DLTDTAARA */
       /*-------------------*/
             DLTDTAARA  DTAARA(&OBJL/EJKC50RUN)
             MONMSG     MSGID(CPF2105)

       /*---------*/
       /* END JOB */
       /*---------*/
             CHKOBJ     OBJ(AJCC10D1) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@STP1))

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RTVDTAARA  DTAARA(AJCC10D1) RTNVAR(&EDTM)
             CHGVAR     VAR(&EDATE) VALUE(%SST(&EDTM 3 6))
             CHGVAR     VAR(&ETIME) VALUE(%SST(&EDTM 10 6))

             IF         COND(&QDATE *EQ &EDATE *AND &QTIME *GT +
                          &ETIME) THEN(DO)
             GOTO       CMDLBL(@STP2)
             ENDDO

       /*------*/
       /* LOOP */
       /*------*/
             GOTO       CMDLBL(@STP1)

       /*---------------*/
       /* JOB DLTDTAARA */
       /*---------------*/
@STP2:       DLTDTAARA  DTAARA(&OBJL/EJKC50ACT)
             MONMSG     MSGID(CPF2105)

@END:
             ENDPGM

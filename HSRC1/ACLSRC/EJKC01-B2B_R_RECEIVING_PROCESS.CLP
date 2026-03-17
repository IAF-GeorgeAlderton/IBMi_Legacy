             PGM
             /** EJKC01 ********************************/
             /* JOB B2B_R   RECEIVING PROCESS          */
             /*    **ORIGINAL IS JK100C FROM ASJ**     */
             /*  T.SAKAKI            2016.10.11        */
             /************************ EJKC01 **********/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJL)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNBR)   TYPE(*CHAR) LEN(6)
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
             CRTDTAARA  DTAARA(&OBJL/EJKC01ACT) TYPE(*CHAR) LEN(10) +
                          TEXT('B2B_R  PROCESSING')
        /* DUPLICATED SUBMIT    */
             MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(@END))


@STP1:       DLYJOB     DLY(30)

       /*-------------------*/
       /* PROCESS CRTDTAARA */
       /*-------------------*/
             CRTDTAARA  DTAARA(&OBJL/EJKC01RUN) TYPE(*CHAR) LEN(10) +
                          TEXT('B2B_R  PROCESSING')

       /**************************/
       /* EACH RECEIVING PROCESS */
       /**************************/
             CALL       PGM(EJKC02)

       /*-------------------*/
       /* PROCESS DLTDTAARA */
       /*-------------------*/
             DLTDTAARA  DTAARA(&OBJL/EJKC01RUN)
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
@STP2:       DLTDTAARA  DTAARA(&OBJL/EJKC01ACT)
             MONMSG     MSGID(CPF2105)

@END:
             ENDPGM

             /** EJKC40 *******************************************/
             /*     B2B_FORD  SENDING PROCESS                     */
             /*  T.SAKAKI            2016.11.30                   */
             /* -------------------------------------             */
             /*  JW1   2026.01.05 SHORTEN THE TITLE LESS THAN 44  */
             /*****************************************************/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&OBJL)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&DLY)    TYPE(*DEC)  LEN(3)
             DCL        VAR(&PTTL)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&WNBR)
             CHGJOB     RUNPTY(20)

        /*--------------------------------------------*/
        /*  CHANGE ENVIRONMENT IF TEST USER USES      */
        /*--------------------------------------------*/
             CALL       PGM(ALBC02) PARM(&USER &OBJL)

@STP1:
             CRTDTAARA  DTAARA(&OBJL/EJKC40RUN) TYPE(*CHAR) LEN(10) +
                          TEXT('B2B_FORD PROCESSING')
             MONMSG     MSGID(CPF1023) EXEC(DO)
             CHGVAR     VAR(&DLY)   VALUE(&DLY + 1)
             DLYJOB     DLY(5)

   /* over 5 minutes */
             IF         COND(&DLY *GT 30) THEN(DO)
        /* NOTIFICATION BY E-MAIL */
 /** JW1     CHGVAR     VAR(&PTTL) VALUE(&USER *TCAT '** B2B_FORD + **/
 /**                      cannot send EDI over 10 min.')            **/
             CHGVAR     VAR(&PTTL) VALUE(&USER *TCAT '** B2B_FORD +
                          cannot send EDI over')
             CHGVAR     VAR(&PMSG) VALUE('Please check B2B_FORD in +
                          QBATCH6 and check ' *CAT &OBJL *TCAT +
                          '/EJKC40RUN')
        /* NOTIFICATION BY E-MAIL */
             CALL       PGM(MSGC10) PARM(&PTTL &PMSG)
             ENDDO

             GOTO       CMDLBL(@STP1)
             ENDDO

       /********************************/
       /* OBSERVATION FOR ABNORMAL END */
       /********************************/
             CALL       PGM(EJKC55) PARM('B2B_FORD  ')

       /*******************/
       /* SENDING PROCESS */
       /*******************/
             CALL       PGM(EJKC41)

             DLTDTAARA  DTAARA(&OBJL/EJKC40RUN)
             MONMSG     MSGID(CPF2105)

@END:
             ENDPGM

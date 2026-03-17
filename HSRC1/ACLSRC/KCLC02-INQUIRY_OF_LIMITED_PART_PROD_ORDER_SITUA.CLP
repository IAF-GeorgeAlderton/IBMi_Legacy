             PGM
             /** KCLC02 **************************************/
             /*   INQUIRY  OF  LIMITED PART PROD.    ORDER SITUATION  */
             /* A-IDOTA                 1987.07.03           */
             /************************************** KCLC02 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP1:       CHGJOB     OUTQ(&PRTG)
             CALL       PGM(KCLR02)
 END:        ENDPGM

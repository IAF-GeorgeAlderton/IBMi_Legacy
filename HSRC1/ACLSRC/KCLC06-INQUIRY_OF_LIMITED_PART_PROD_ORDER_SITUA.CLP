             PGM
             /** KCLC06 **************************************/
             /*   INQUIRY  OF  LIMITED PART PROD.    ORDER SITUATION  */
             /* A-IDOTA                 1987.09.29           */
             /************************************** KCLC06 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERRM) TYPE(*CHAR) LEN(60)
             DCL        VAR(&KUB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IN90) TYPE(*LGL) VALUE('0')
             DCL        VAR(&IN01) TYPE(*LGL) VALUE('0')
             DCLF       FILE(KCLPW06)
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP21:      CHGVAR     VAR(&KUB) VALUE(' ')
 STP2:       CHGVAR     VAR(&IN01) VALUE('0')
             SNDRCVF    RCDFMT(KCLPW061)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN90) VALUE('0')
             IF         (&KUB *EQ '1') GOTO STP1
             IF         (&KUB *EQ '2') GOTO STP1
             CHGVAR     VAR(&IN90) VALUE('1')
             CHGVAR     VAR(&ERRM) VALUE('INQUIRY INSTRUCTION IS 1 OR 2.')
             GOTO       STP2
 STP1:       CHGJOB     OUTQ(&PRTG)
             IF         (&KUB *EQ '1') DO
             CALL       PGM(KCLR07)
             GOTO       STP21
             ENDDO
             IF         (&KUB *EQ '2') DO
             CALL       PGM(KCLR02)
             GOTO       STP21
             ENDDO
 END:        ENDPGM

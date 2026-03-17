             PGM
             /** AJSCM1 ************************************/
             /* PLATING RESULTS DATA INQUIRY               */
             /*               CREATE DATE : 1997/MAR/13.   */
             /*               AUTHOR      : S.OHTAKE.      */
             /**********************************************/
             DCLF       FILE(AJSPWM1)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&IN02) VALUE('0')

 STEP0:      SNDRCVF    RCDFMT(AJSPWM11)
             CHGVAR     VAR(&IN02) VALUE('0')
             IF         (&IN01 = '1') RETURN

             IF         (&NO   *NE ' ') GOTO STEP1

             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO')
             GOTO STEP0

 STEP1:      IF         (&NO   *EQ '1') GOTO STEP2
             IF         (&NO   *EQ '2') GOTO STEP3
             IF         (&NO   *EQ '3') GOTO STEP4
             IF         (&NO   *EQ '4') GOTO STEP5
             IF         (&NO   *EQ '5') GOTO STEP6
             IF         (&NO   *EQ '6') GOTO STEP7
             IF         (&NO   *EQ '7') GOTO STEP8
             IF         (&NO   *EQ '8') GOTO STEP9
             IF         (&NO   *EQ '9') GOTO STEPA

             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('NO IN NOT CORRECT')
             GOTO STEP0

 STEP2:      CALL AJSC30
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP3:      CALL AJSC31
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP4:      CALL AJSC32
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP5:      CALL AJSC33
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP6:      CALL AJHC16
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP7:      CALL AJHC26
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP8:      CALL AJSC35
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP9:      CALL AJSC36
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEPA:      CALL AJSC3A
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

             ENDPGM

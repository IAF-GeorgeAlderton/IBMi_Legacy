             PGM
             /** AJSCM1 ************************************/
             /* PLATING RESULTS DATA INQUIRY               */
             /*               CREATE DATE : 1997/MAR/13.   */
             /*               AUTHOR      : S.OHTAKE.      */
             /**********************************************/
             DCLF       FILE(AJSPWM3)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&IN02) VALUE('0')

 STEP0:      SNDRCVF    RCDFMT(AJSPWM31)
             CHGVAR     VAR(&IN02) VALUE('0')
             IF         (&IN01 = '1') RETURN

             IF         (&NO   *NE ' ') GOTO NEXT

             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ENTER NO. ')
             GOTO STEP0

 NEXT:       IF         (&NO   *EQ '1') GOTO STEP1
             IF         (&NO   *EQ '2') GOTO STEP2
             IF         (&NO   *EQ '3') GOTO STEP3
             IF         (&NO   *EQ '4') GOTO STEP4
             IF         (&NO   *EQ '5') GOTO STEP5
             IF         (&NO   *EQ '6') GOTO STEP6
             IF         (&NO   *EQ '7') GOTO STEP7

             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ENTER NO. 1 TO 7 ')
             GOTO STEP0

 STEP1:      CALL AJSC50
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP2:      CALL AJSC51
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP3:      CALL AJHC17
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP4:      CALL AJSC53
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP5:      CALL AJSC52
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0
 /*UNLOAD*/
 STEP6:      CALL AJHC27
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

 STEP7:      CALL AJSC5A
             CHGVAR     VAR(&NO) VALUE(' ')
             GOTO STEP0

             ENDPGM

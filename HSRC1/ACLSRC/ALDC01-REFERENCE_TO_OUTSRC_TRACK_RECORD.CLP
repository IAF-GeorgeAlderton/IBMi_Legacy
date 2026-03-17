PGM
/** ALDC01 ************************************/
/* REFERENCE TO OUT-GOING TRACK RECORD        */
/*       CREATE DATE : JUN/26/1997.           */
/*       AUTHOR      : S.OHTAKE.              */
/*                                            */
/* ADD OOPTION 4: NOV/15/01                   */
/* ADD OOPTION 8: SEP/13/02                   */
/*                                            */
/* TCHK1 10/20/09 ADD OPTION A ALCC30         */
/* TCHK2 04/23/10 ADD OPTION D ALER20         */
/* TCHK3 09/17/10 ADD OPTION B ALCR40         */
/* TCHK4 10/27/10 ADD OPTION C ALFR30         */
/* TCHK5 02/04/11 ADD OPTION Z AFDR85         */
/* TCHK6 11/21/12 ADD OPTION X GDMR820        */
/* TCHK7 11/27/12 ADD OPTION Y GTEC30         */
/* TCHK8 01/31/14 ADD OPTION E AFBR86         */
/* TCHK9 02/03/14 ADD OPTION F ALJR05         */
/*                ADD OPTION G ALJR15         */
/**********************************************/
             DCLF       FILE(ALDPW01)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&IN02) VALUE('0')

 STEP0:      SNDRCVF    RCDFMT(ALDPW011)
             CHGVAR     VAR(&IN02) VALUE('0')
             IF         (&IN01 = '1') RETURN

             IF         (&NO   *NE ' ') GOTO STEP1

             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO')
             GOTO STEP0

 STEP1:      IF         (&NO   *EQ '1') GOTO STEP2
             IF         (&NO   *EQ '2') GOTO STEP3
             IF         (&NO   *EQ '3') GOTO STEP33
             IF         (&NO   *EQ '4') GOTO STEP4
             IF         (&NO   *EQ '5') GOTO STEP5
             IF         (&NO   *EQ '6') GOTO STEP6
             IF         (&NO   *EQ '7') GOTO STEP7
             IF         (&NO   *EQ '8') GOTO STEP8
             IF         (&NO   *EQ '9') GOTO STEP9
/* TCHK1 */  IF         (&NO   *EQ 'A') GOTO STEPA
/* TCHK2 */  IF         (&NO   *EQ 'D') GOTO STEPD
/* TCHK3 */  IF         (&NO   *EQ 'B') GOTO STEPB
/* TCHK4 */  IF         (&NO   *EQ 'C') GOTO STEPC
/* TCHK5 */  IF         (&NO   *EQ 'Z') GOTO STEPZ
/* TCHK6 */  IF         (&NO   *EQ 'X') GOTO STEPX
/* TCHK7 */  IF         (&NO   *EQ 'Y') GOTO STEPY
/* TCHK8 */  IF         (&NO   *EQ 'E') GOTO STEPE
/* TCHK9 */  IF         (&NO   *EQ 'F') GOTO STEPF
/* TCHK9 */  IF         (&NO   *EQ 'G') GOTO STEPG

             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SELECTED OPTION IS NOT CORRECT')
             GOTO STEP0

 STEP2:      CALL ALDR25
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

 STEP3:      CALL ALDR35
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

 STEP33:
             CRTDUPOBJ  OBJ(ALDWP33) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(ALDWP33) TOFILE(QTEMP/ALDWP33)
             CALL ALDR36
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             DLTOVR     FILE(ALDWP33)
             GOTO STEP0

 STEP4:      CALL ALDR45
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

 STEP5:      CALL ALDR55
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

 STEP6:      CALL AB#C09
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

 STEP7:      CALL AB#C08
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

 STEP8:
             CRTDUPOBJ  OBJ(ALDWP37) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(ALDWP37) TOFILE(QTEMP/ALDWP37)
             CALL ALDR37
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             DLTOVR     FILE(ALDWP37)
             GOTO STEP0

 STEP9:      CALL ALDR46
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

 STEPA:      CALL ALCC30
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

 STEPB:      CALL ALCR40
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

 STEPC:      CALL ALFR30
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

 STEPD:      CRTDUPOBJ  OBJ(ALEWP20) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(ALEWP20) TOFILE(QTEMP/ALEWP20)
             CALL ALER20
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0
/* TCHK8 */
 STEPE:      CALL AFBR86
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0
/* TCHK9 */
 STEPF:      CALL ALJR05
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

 STEPG:      CALL ALJR15
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0
/* TCHK6 */
 STEPX:      CALL GDMR820
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0
/* TCHK7 */
 STEPY:      CALL GTEC30
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0
/* TCHK5 */
 STEPZ:      CALL AFDR85
             CHGVAR     VAR(&NO) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO STEP0

             ENDPGM

             PGM
             /** EJKC32 **************************************/
             /* INQUIRY & UPDATE B2B MANAGEMENT FILE         */
             /*    **ORIGINAL IS JK599C FROM ASJ**           */
             /*   T.SAKAKI                 2016.12.13        */
             /*********************************** EJKC32 *****/
             DCLF       FILE(EJKPW32)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

          /*******************************************/
          /*  INPUT SCREEN                         */
          /*******************************************/
 @STP0:
             CHGVAR     VAR(&D1SEL) VALUE(' ')
 @STP1:
             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&IN31)  VALUE('0')
             CHGVAR     VAR(&IN99)  VALUE('0')
             CHGVAR     VAR(&D1ERR) VALUE(' ')

 /* F1 */    IF         (&IN01 *EQ '1') GOTO @END

             IF         (&D1SEL *EQ ' ') DO
                 CHGVAR     VAR(&IN99) VALUE('1')
                 CHGVAR     VAR(&IN31) VALUE('1')
             CHGVAR     VAR(&D1ERR) +
                          VALUE('INPUT REQUIRED.           ')
                 GOTO       @STP1
             ENDDO

             IF         COND(&D1SEL *EQ '1') THEN(GOTO CMDLBL(@STP10))
             IF         COND(&D1SEL *EQ '2') THEN(GOTO CMDLBL(@STP20))
             IF         COND(&D1SEL *EQ '3') THEN(GOTO CMDLBL(@STP30))
             IF         COND(&D1SEL *EQ '4') THEN(GOTO CMDLBL(@STP40))

             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN31) VALUE('1')
             CHGVAR     VAR(&D1ERR) +
                          VALUE('INCORRECT.          ')
             GOTO       @STP1

          /*******************************************/
          /*  MAIN PROGRAM                           */
          /*******************************************/
 @STP10:  /* INQUIRY & UPDATE B2B_R MANAGEMENT FILE   */
             CALL       PGM(EJKC33)
             GOTO       @STP0

 @STP20:  /* INQUIRY & UPDATE B2B_S MANAGEMENT FILE   */
             CALL       PGM(EJKC34)
             GOTO       @STP0

 @STP30:  /* INQUIRY & UPDATE B2B_FORD MANAGEMENT FILE   */
             CALL       PGM(EJKC35)
             GOTO       @STP0

 @STP40:  /* INQUIRY & UPDATE B2B_S ERROR MANAGEMENT FILE   */
             CALL       PGM(EJKC3A)
             GOTO       @STP0

 @END:
             ENDPGM

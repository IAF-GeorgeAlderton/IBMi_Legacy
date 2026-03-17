             PGM
             /** DLTC01 *************************************/
             /* PROGRAM NAME. : DELETE SPOOL FILE         */
             /* PROGRAM ID.   : DLTC01      <CLP>           */
             /* CREATE DATE.  : 2001.04.25                  */
             /* AUTHOR.       : A.MAMIYA                    */
             /***********************************************/
             DCLF       FILE(DLTPW01)
             DCL        VAR(&IUSER) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&ISPL) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&IDATE) TYPE(*CHAR)  LEN(8)
             DCL        VAR(&IDATA) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&IJOB) TYPE(*CHAR)  LEN(10)
             DCL        (&IN11) TYPE(*LGL) LEN(1)
             DCL        (&IN12) TYPE(*LGL) LEN(1)
             DCL        (&IN13) TYPE(*LGL) LEN(1)
             DCL        (&IN14) TYPE(*LGL) LEN(1)
             DCL        (&IN15) TYPE(*LGL) LEN(1)

 @STEP1:     SNDRCVF    RCDFMT(DLTPW011)
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             CHGVAR     VAR(&IN13) VALUE('0')
             CHGVAR     VAR(&IN14) VALUE('0')
             CHGVAR     VAR(&IN15) VALUE('0')

             IF         COND(&IUSER *EQ '           ') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             GOTO       CMDLBL(@STEP1)
             ENDDO
             IF         COND(&ISPL *EQ '           ') THEN(DO)
             CHGVAR     VAR(&IN12) VALUE('1')
             GOTO       CMDLBL(@STEP1)
             ENDDO
             IF         COND(&IDATE *EQ '         ') THEN(DO)
             CHGVAR     VAR(&IN13) VALUE('1')
             GOTO       CMDLBL(@STEP1)
             ENDDO
             IF         COND(&IDATA *EQ '           ') THEN(DO)
             CHGVAR     VAR(&IN14) VALUE('1')
             GOTO       CMDLBL(@STEP1)
             ENDDO
             IF         COND(&IJOB *EQ '           ') THEN(DO)
             CHGVAR     VAR(&IN15) VALUE('1')
             GOTO       CMDLBL(@STEP1)
             ENDDO

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@STEP1))

             CALL       PGM(DLTR01) PARM(&IUSER &ISPL &IDATE &IDATA +
                          &IJOB)

  @END:      ENDPGM

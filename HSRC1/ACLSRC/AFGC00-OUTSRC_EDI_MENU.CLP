             PGM
             /** AFGC00 **************************************/
             /*  OUTSOURCING EDI MENU                        */
             /*     T.SAKAKI                2016.10.25       */
             /************************************** AFGC00 **/
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&OPTN)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&SUPP)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&PCMD)    TYPE(*CHAR) LEN(2)

             RTVJOBA      USER(&USER)

   STRT:
    /*--------------*/
    /* INPUT SCREEN */
    /*--------------*/
             CALL       PGM(AFGR00) PARM(&OPTN &SUPP &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO

   /* CREATE NEW EDI ORDER (UNPROCESSED) */
             IF         COND(&OPTN *EQ '1') THEN(CALL PGM(AFGC01) +
                          PARM(&SUPP))

   /* RE-CREATE EDI ORDER DATA */
             IF         COND(&OPTN *EQ '2') THEN(CALL PGM(AFGC10) +
                          PARM(&SUPP))

   /* CREATE EDI FORECAST  */
             IF         COND(&OPTN *EQ '3') THEN(CALL PGM(AFHC01) +
                          PARM(&SUPP))

   /* EDI MAINTENANCE MENU */
         /*JW IF        COND(&OPTN *EQ '4') THEN(CALL PGM(EDIC55) +   */
         /*               PARM(&SUPP))                                */
             IF         COND(&OPTN *EQ '4') THEN(CALL PGM(EDIC57) +
                          PARM(&SUPP))

   /* CREATE EDI FORECAST  */
             IF         COND(&OPTN *EQ '5') THEN(CALL PGM(AFDC40))

             CHGVAR     VAR(&OPTN) VALUE(' ')
             CHGVAR     VAR(&SUPP) VALUE('    ')
             CHGVAR     VAR(&PCMD) VALUE('  ')
             GOTO       CMDLBL(STRT)
 END:
             ENDPGM

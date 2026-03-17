             PGM
             /** AB#C0H ****************************************************/
             /*  EDI(856/810) GENTRAN                                      */
             /*     11/01/02                                               */
             /*                                                            */
             /*                                                            */
             /************************************************** AB#C0H ****/
             DCLF       FILE(AB#PW0H)

  @STRT:
             CHGVAR     VAR(&IN61) VALUE('0')
             SNDRCVF    DEV(*FILE) RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))

             IF         COND(&D@OPT *NE ' ' *AND &D@OPT *NE '1') +
                          THEN(DO)
             CHGVAR     VAR(&IN61) VALUE('1')

             GOTO       CMDLBL(@STRT)
             ENDDO

  /* NOT HONDA */
             IF         COND(&D@OPT *EQ ' ') THEN(DO)
             CALL       PGM(AB#C0F)
             GOTO       CMDLBL(@END)
             ENDDO
  /* HONDA */
             IF         COND(&D@OPT *EQ '1') THEN(DO)
             CALL       PGM(AB#C0P)
             GOTO       CMDLBL(@END)
             ENDDO
 @END:

             ENDPGM

             PGM
             /** AKAC60 ********************************/
             /*  OUTSOURCING PARTS                   */
             /*                                        */
             /******************************** AKAC60 **/
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCLF       FILE(AKAPW60)

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
   @START:
             SNDRCVF    RCDFMT(DSP01)
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))

             IF         COND(&IN05 *EQ '1') THEN(DO)
             CLRPFM     FILE(&WLIB/AKAWP60)
             CALL       PGM(AKAR60)
             GOTO       CMDLBL(@END)
             ENDDO

             GOTO       CMDLBL(@START)

   @END:
             ENDPGM

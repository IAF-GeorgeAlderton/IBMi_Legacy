             PGM
             /*** AAFC91 ***********************************/
             /* PART LIST                                  */
             /*           TCH                              */
             /*********************************** AAFC90 ***/
             DCLF       FILE(AAFPW91)
             CHGVAR     VAR(&COPY) VALUE(1)
  STRT:
             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&IN61) VALUE('0')
             CHGVAR     VAR(&IN62) VALUE('0')

             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(@END))

             IF         COND(&COPY *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN61) VALUE('1')
             GOTO       CMDLBL(STRT)
             ENDDO
             IF         COND(&SORT *NE '1' *AND &SORT *NE '2') THEN(DO)
             CHGVAR     VAR(&IN62) VALUE('1')
             GOTO       CMDLBL(STRT)
             ENDDO

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(STRT))

             OVRPRTF    FILE(QPRINT) FORMTYPE(K6H1) COPIES(&COPY)

             CRTDUPOBJ  OBJ(AAFWP91) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AAFWL91) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AAFWL92) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AAFWP91)
             OVRDBF     FILE(AAFWP91) TOFILE(QTEMP/AAFWP91)
             OVRDBF     FILE(AAFWL91) TOFILE(QTEMP/AAFWL91)
             OVRDBF     FILE(AAFWL92) TOFILE(QTEMP/AAFWL92)

             CALL       PGM(AAFR91) PARM(&SORT)
             DLTOVR     FILE(*ALL)
  @END:
             ENDPGM

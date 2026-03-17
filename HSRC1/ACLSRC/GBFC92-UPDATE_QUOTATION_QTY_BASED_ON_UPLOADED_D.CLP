             PGM
             /** GBFC92 ************************************/
             /*  UPDATE QUOTATION QTY                           */
             /*       TCH           2002.09.05             */
             /*                                            */
             /************************************ GBFC92 **/
             DCLF       FILE(GBFPW92)
             CHKOBJ     OBJ(NEWVOL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&IN99) +
                          VALUE('1'))
  @STRT:
             SNDRCVF    RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1' *OR &IN99 *EQ '1') +
                          THEN(GOTO CMDLBL(@END))

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@STRT))

             CLRPFM     FILE(GBFWP90)
             CALL       PGM(GBFR92)
             CALL       PGM(GBFR93)
             DLTF       FILE(NEWVOL)
  @END:
             ENDPGM

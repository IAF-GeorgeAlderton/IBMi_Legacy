             PGM
             /** ALDC58 ************************************/
             /*     SCANNED PARTS LIST                     */
             /*                                            */
             /*                                            */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAT) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CRTDUPOBJ  OBJ(ALDWP56) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ALDWP56

             OVRDBF     FILE(ALDWP56) TOFILE(QTEMP/ALDWP56)
             CALL       PGM(ALDR58) PARM(&END &DAT)

             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))

             CLRPFM ALDWP2X
             CALL       PGM(ALDR59)
             DLTOVR     FILE(*ALL)
   @END:
             ENDPGM

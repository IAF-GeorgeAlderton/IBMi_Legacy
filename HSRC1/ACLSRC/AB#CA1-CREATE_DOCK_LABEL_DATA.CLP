             PGM
             /** AB#CA1 ************************/
             /* ..CREATE DOCK LABEL DATE       */
             /*                                */
             /**********************************/
             DCL        VAR(&ID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CRTDUPOBJ  OBJ(ABWPP1A) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABWPP1A
             OVRDBF     FILE(ABWPP1A) TOFILE(QTEMP/ABWPP1A)

             CALL       PGM(AB#RA1) PARM(&ID)
             IF         COND(&ID *EQ ' ') THEN(SNDBRKMSG MSG('LABEL +
                          DATA IS SUCCESSFULLY CREATED. PLEASE +
                          DOWNLOAD TO PC AND PRINT DOCK LABELS.') +
                          TOMSGQ(&WSID))

             ENDPGM

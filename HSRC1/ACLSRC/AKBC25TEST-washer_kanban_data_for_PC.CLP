             PGM
             /** AKBC25 ************************************/
             /* WASHER KANBAN DATA TO PC                   */
             /*              TCH  11/16/2004               */
             /*                                            */
             /**********************************************/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&JOB)
/* TEST */   CLRPFM     FILE(TWFILE1/AKBWP25)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDBRKMSG  MSG('Someone is issuing the washer kanbans +
                          now. Please come back later and try it +
                          again.') TOMSGQ(&JOB)
             GOTO       CMDLBL(@END)
             ENDDO

/* TEST */   OVRDBF     FILE(AKBWP25) TOFILE(TWFILE1/AKBWP25)
/* TEST */
/* TEST */   CALL       PGM(TOBJ1/AKBR25)
 @END:
             ENDPGM

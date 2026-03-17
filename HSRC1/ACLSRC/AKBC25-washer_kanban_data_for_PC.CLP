             PGM
             /** AKBC25 ************************************/
             /* WASHER KANBAN DATA TO PC                   */
             /*              TCH  11/16/2004               */
             /*                                            */
             /**********************************************/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&JOB)
             CLRPFM     FILE(AKBWP25)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDBRKMSG  MSG('Someone is issuing the washer kanbans +
                          now. Please come back later and try it +
                          again.') TOMSGQ(&JOB)
             GOTO       CMDLBL(@END)
             ENDDO

             CALL       PGM(AKBR25)
 @END:
             ENDPGM

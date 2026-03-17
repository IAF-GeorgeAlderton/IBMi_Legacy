/** GDLC4D ************************************************/
/*  POSCO MATERIAL ORDER RECEIVE                          */
/*  JW       2020.11.18                                   */
/**********************************************************/
PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(POSCO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             SNDPGMMSG  MSG('THERE IS NO TARGET DATA(POSCO). PLEASE +
                          SETUP THE DATA AND RUN THIS JOB AGAIN.') +
                          TOMSGQ(&WSID) MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             CLRPFM     FILE(GDLWP4D)

             CALL       PGM(GDLR4D)

          /* JW ADDED */
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03)

             CALL       PGM(GDLR4F)

             SNDPGMMSG  MSG('REPORT HAS BEEN PRINTED. PLEASE CONFIRM.')

             CALL       PGM(GDLR4E)

 /* JW SAVE POSCO  */
             CALL       PGM(EDSC90) PARM('4550')

             DLTF       FILE(POSCO)

             DLTOVR     FILE(QPRINT)

 END:

             ENDPGM

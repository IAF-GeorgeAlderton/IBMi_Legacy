/** GDLC5D ************************************************/
/*  TSUSHO MATERIAL ORDER RECEIVE                         */
/*  JW       2020.12.03                                   */
/**********************************************************/
PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(TSUSHO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             SNDPGMMSG  MSG('THERE IS NO TARGET DATA(TSUSHO). PLEASE +
                          SETUP THE DATA AND RUN THIS JOB AGAIN.') +
                          TOMSGQ(&WSID) MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             CLRPFM     FILE(GDLWP5D)

             CALL       PGM(GDLR5D)

          /* JW ADDED */
     /*JW    OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03)   **/
             OVRPRTF    FILE(QPRINT) OUTQ(QDKT)
             CALL       PGM(GDLR5F)
             SNDPGMMSG  MSG('REPORT HAS BEEN PRINTED. PLEASE CONFIRM.')

             CALL       PGM(GDLR5E)

 /* JW SAVE TSUSHO */
             CALL       PGM(EDSC90) PARM('4560')

             DLTF       FILE(TSUSHO)

             DLTOVR     FILE(QPRINT)

 END:

             ENDPGM

/** GDLC1D ************************************************/
/*  O&K MATERIAL ORDER RECEIVE                            */
/*                                                        */
/*  TCHK  05/31/12 CREATE                                 */
/*  JW1   05/05/2016 ADD PRINTING REPORT                  */
/**********************************************************/
PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(NSCI) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             SNDPGMMSG  MSG('THERE IS NO TARGET DATA(NSCI). PLEASE +
                          SETUP THE DATA AND RUN THIS JOB AGAIN.') +
                          TOMSGQ(&WSID) MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             CLRPFM     FILE(GDLWP2D)

             CALL       PGM(GDLR2D)

          /* JW ADDED */
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03)

             CALL       PGM(GDLR2F)

             SNDPGMMSG  MSG('REPORT HAS BEEN PRINTED. PLEASE CONFIRM.')

             CALL       PGM(GDLR2E)

 /* JW SAVE NSCI    */
             CALL       PGM(EDSC90) PARM('4530')

             DLTF       FILE(NSCI)

             DLTOVR     FILE(QPRINT)

 END:

             ENDPGM

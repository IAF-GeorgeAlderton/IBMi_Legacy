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

             CHKOBJ     OBJ(OANDK) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             SNDPGMMSG  MSG('THERE IS NO TARGET DATA(OANDK). PLEASE +
                          SETUP THE DATA AND RUN THIS JOB AGAIN.') +
                          TOMSGQ(&WSID) MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             OVRDBF     FILE(OANDK)   TOFILE(HWFILE1/OANDK)
             OVRDBF     FILE(GDLWP1D) TOFILE(HWFILE1/GDLWP1D)
             CLRPFM     FILE(HWFILE1/GDLWP1D)

             CALL       PGM(HOBJ1/GDLR1D)

         /* JW ADDED */
         /** OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03)  **/
             OVRPRTF    FILE(QPRINT) OUTQ(QDKT)
             OVRDBF     FILE(GDLWP1D) TOFILE(HWFILE1/GDLWP1D)
             CALL       PGM(HOBJ1/GDLR1F)
             SNDPGMMSG  MSG('REPORT HAS BEEN PRINTED. PLEASE CONFIRM.')

             OVRDBF     FILE(GDLQP01) TOFILE(HFILE1/GDLQP01)
             OVRDBF     FILE(GDLPL14) TOFILE(HFILE1/GDLPL14)

             CALL       PGM(HOBJ1/GDLR1E)

 /* JW SAVE OANDK   */
             CALL       PGM(EDSC90) PARM('4511')

             DLTF       FILE(OANDK)

             DLTOVR     FILE(QPRINT)

 END:

             ENDPGM

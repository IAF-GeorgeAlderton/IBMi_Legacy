             PGM
             /** EDIC40 ************************************/
             /* ADDRESS MASTER FILE UPDATE                 */
             /*                                            */
             /*       CREATE DATE : 1998.10.05             */
             /*       CODING      : K.OKACHI.              */
             /*  TCHK1  2005.11.09 CHG MULTI TASK          */
             /**********************************************/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

/* TCHK1 START */
/* STP1:     CHKOBJ     OBJ(&WLIB/EDIC40ACT) OBJTYPE(*DTAARA)         */
/*           MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP3))        */
/*                                                                    */
/* STP2:     SNDPGMMSG  MSG('( G ) THE PROCESSING IS BEING EXECUTED + */
/*                        WITH OTHER TV.') TOMSGQ(&WSID) +            */
/*                        MSGTYPE(*INQ) KEYVAR(&MBAN)                 */
/*           RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +      */
/*                        MSG(&KOTE)                                  */
/*           IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +  */
/*                        THEN(GOTO CMDLBL(STP2))                     */
/*           GOTO       EXIT                                          */
/*                                                                    */
/* STP3:     CRTDTAARA  DTAARA(&WLIB/EDIC40ACT) TYPE(*CHAR) LEN(10) + */
/*                        AUT(*ALL)                                   */
/*           MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(STP1))        */
/*                                                                    */
/*           CALL EDIR40 PARM(&US)                                    */
/*                                                                    */
/* END:      DLTDTAARA  DTAARA(&WLIB/EDIC40ACT)                       */
/*           MONMSG     MSGID(CPF2105)                                */
/* TCHK1 */
/* TCHK1 */  CALL       PGM(EDIR40)
/* TCHK1 */
/* TCHK1 END */

 EXIT:       ENDPGM

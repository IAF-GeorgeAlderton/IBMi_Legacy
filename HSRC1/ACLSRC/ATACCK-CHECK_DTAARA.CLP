             PGM        PARM(&BUMN  &ANS)
             /** ATACCK ************************************/
             /* DTAARA CHK                                 */
             /*                              86.11.12      */
             /************************************ ATAC81 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&RPY)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BUMN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ANS)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ARA1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ARA2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CORD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CP)   TYPE(*CHAR) LEN(1)

             DCL        VAR(&MINBAN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&NOUHIN) TYPE(*CHAR) LEN(2)
             RTVDTAARA  DTAARA(MINBAN) RTNVAR(&MINBAN)
             RTVDTAARA  DTAARA(NOUHIN) RTNVAR(&NOUHIN)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             IF (&BUMN  *EQ '0111 ' )  DO
                 CHGVAR   VAR(&CORD)   VALUE('I ')
             ENDDO

             CHGVAR     VAR(&ARA2)   VALUE(&NOUHIN *CAT &CORD)
             CHGVAR     VAR(&ARA1)   VALUE(&MINBAN *CAT &CORD)

             /*------------------------------------------------------*/
             CHKOBJ     OBJ(HFILE1/&ARA1) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP04))
 STEP91:     SNDPGMMSG  MSG('(G) UNDELV RETRIEVAL HANDLE IS ACTIVE. +
                          WAIT UNTIL IT DONE.') +
                          TOMSGQ(&WSNO) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         (&KOTE *NE 'G') GOTO STEP91
             CHGVAR     VAR(&ANS)  VALUE('D')
             GOTO END
             /*-----------------------------------------------------*/
 STEP04:     CHKOBJ     OBJ(&ARA2) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP14))
 STEP13:     SNDPGMMSG  MSG('(G) DELV STATEMENTS ARE PUBLISHING. +
                          WAIT UNTIL IT DONE.') +
                          TOMSGQ(&WSNO) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         (&KOTE *NE 'G') GOTO STEP13
             CHGVAR     VAR(&ANS)  VALUE('D')
             GOTO       END
 STEP14:     CRTDTAARA  DTAARA(HFILE1/&ARA1) TYPE(*CHAR) LEN(4) +
                          TEXT('EACH FACTORY UNDELIVERED / RETRIEVAL +
                          HANDL DTAARA') AUT(*ALL)

 END:        ENDPGM

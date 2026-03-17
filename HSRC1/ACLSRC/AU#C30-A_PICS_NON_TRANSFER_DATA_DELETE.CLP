             PGM
             /** AU#C30 **********************************/
             /*   A-PICS NON-TRANSFER DATA DELETE        */
             /*       MSK.KUNIEDA         98.05.18       */
             /********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&WTIME) TYPE(*CHAR) LEN(6)

             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WTIME)
             RTVJOBA    JOB(&WSID)  USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             IF         ((%SST(&WTIME 3 2) *GE '30') *AND +
                          (%SST(&WTIME 3 2) *LT '50')) DO
             ENDDO
             ELSE       DO
 STP1:
             CHGVAR     VAR(&MSGTXT) VALUE('( G ) DELECTION OF +
                          NON-TRANSFERED DATA IS AVAILABLE TO +
                          TRANSACT FROM EVERY AT 30MINITES TO 50.')

             CHGVAR     VAR(&PKINP) VALUE('Gg   ')

             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &KOTE)

             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP1))
             GOTO       END

             SNDPGMMSG  MSG('( G ) DELECTION OF NON-TRANSFERED DATA +
                          IS AVAILABLE TO TRANSACT FROM EVERY AT +
                          30MINITES TO 50.') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP1))
             GOTO       END
             ENDDO

             OVRPRTF QSYSPRT OUTQ(&PRTG)
             CALL       PGM(AU#R30) PARM(&USER)
             DLTOVR QSYSPRT

 END:        ENDPGM

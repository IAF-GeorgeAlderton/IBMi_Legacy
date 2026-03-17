             PGM
             /** AIAC07 **********************************/
             /* || M/F DATA FOR REPUBLICATION TRANSMISSION || */
             /* I-HASADA                  86.10.16       */
             /********************************** AIAC07 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BMN1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BMON) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DSKT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CFILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(10) +
                          VALUE('IAF       ')

             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             CLRPFM     FILE(AIANP07)
             CALL       PGM(AIAR07) PARM(&BMN1 &DSKT)

          /*つるべ対応めっきかんばんマスターデータを追加*/
             CALL       PGM(AIARA7)

          /* A-PICS2/3 KANBAN MASTER ADD */
             CALL       PGM(AIARA8)

             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       END
             ENDDO

             CALL       PGM(AIAR09) PARM(&BMN1)

             CLRPFM     FILE(AIA0111)

             OVRDBF     FILE(INPUT) TOFILE(AIANP07)
             CALL       PGM(AIAR04)
             CALL       PGM(AIAR05)
             DLTOVR     FILE(INPUT)

             CLRPFM     FILE(A0A0111A)

             OVRDBF     FILE(OUTPUT1) TOFILE(A0A0111A)

             CALL       PGM(AIAR06) PARM('A')

       /*    CPYF       FROMFILE(AIANP07) TOFILE(AIANP07SV) +   */
       /*                 MBROPT(*ADD)                          */

             CLRPFM     FILE(AIANP07)
             CLRPFM     FILE(AIA0111)

             DLTOVR     FILE(OUTPUT1)

             IF         (&DSKT *EQ 'D') DO

 STP1:       SNDPGMMSG  MSG('( G )  COPY DATA IN FD AND PROCESS < +
                          CONFIRMATION OK - G >') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP1

             ENDDO

 END:        ENDPGM

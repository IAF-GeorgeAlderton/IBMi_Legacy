             PGM
             /** IZAC30 **********************************/
             /* NUMBER OF MATERIAL KANBAN ADJUTING LIST  */
             /*   I-HASADA                 2000.08.07    */
             /********************************** IZAC30 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL3) TYPE(*CHAR) LEN(9)

             DCL        VAR(&CFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FIL1) VALUE(IZAWP301 *CAT &WS)
             CHGVAR     VAR(&FIL2) VALUE(IZAWP302 *CAT &WS)
             CHGVAR     VAR(&FIL3) VALUE(IZAWP31 *CAT &WS)

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(IZAWP301) TOFILE(&FIL1)
             OVRDBF     FILE(IZAWP302) TOFILE(&FIL2)
             CHGVAR     VAR(&CFLG) VALUE(' ')
             CALL       PGM(IZAR30) PARM(&CFLG)
             DLTOVR     FILE(*ALL)
             IF         COND(&CFLG *NE ' ') THEN(DO)
 STP1:       SNDPGMMSG  MSG('( G ) KANBAN NON-UPDATED DATA IS +
                          EXITED.  < G-ENTER >') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)

             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP1))
             ENDDO
             IF         (%SWITCH(00XXXXXX)) DO
             DLTF       FILE(&FIL1)
             DLTF       FILE(&FIL2)
             GOTO       END
             ENDDO

             IF         (%SWITCH(1XXXXXXX)) DO

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL3) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FIL1)) +
                          OUTFILE(HWFILE1/&FIL3) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(IZAS31) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FIL1)

      /*     OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) PAGESIZE(66 + */
      /*                  198) LPI(6) CPI(15) RPLUNPRT(*YES) +     */
      /*                  OUTQ(&PRTG) FORMTYPE(K6H1)               */
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             OVRDBF     FILE(IZAWP31) TOFILE(&FIL3)
             CALL       PGM(IZAR31)
             DLTF       FILE(&FIL3)
             DLTOVR     FILE(*ALL)

             ENDDO

             IF         (%SWITCH(X1XXXXXX)) DO

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL3) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FIL2)) +
                          OUTFILE(HWFILE1/&FIL3) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(IZAS31) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FIL2)

      /*     OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) PAGESIZE(66 + */
      /*                  198) LPI(6) CPI(15) RPLUNPRT(*YES) +     */
      /*                  OUTQ(&PRTG) FORMTYPE(K6H1)               */
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             OVRDBF     FILE(IZAWP31) TOFILE(&FIL3)
             CALL       PGM(IZAR31)
             DLTF       FILE(&FIL3)
             DLTOVR     FILE(*ALL)

             ENDDO

 END:        ENDPGM

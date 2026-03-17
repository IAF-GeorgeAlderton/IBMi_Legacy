             PGM
             /** AAHC10 **************************************/
             /*  PART WITHDRAWAL KANBAN PUBLICATION (DAILY)  */
             /*        S.YAMAGAMI        93.11.05            */
             /************************************** AAHC10 **/
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WS5) TYPE(*CHAR) LEN(5)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS5) VALUE(%SST(&WSID 1 5))
           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGJOB     RUNPTY(40) SWS(00000000)

             DLTF       FILE(AAHWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(AAHWP101)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(AAHWP10H)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(AAHWP10T)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/AAHWP10) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(&WLIB/AAHWP101) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(&WLIB/AAHWP10H) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(&WLIB/AAHWP10T) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(&WLIB/AAHWP10)
             OVRDBF     FILE(OUTPUT2) TOFILE(&WLIB/AAHWP101)
             OVRDBF     FILE(OUTPUT3) TOFILE(&WLIB/AAHWP10H)
             OVRDBF     FILE(OUTPUT4) TOFILE(&WLIB/AAHWP10T)
             CALL       PGM(AAHR10) PARM(' ')
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)
             DLTOVR     FILE(OUTPUT3)
             DLTOVR     FILE(OUTPUT4)

             OVRDBF     FILE(INPUT) TOFILE(&WLIB/AAHWP101)
             CALL       PGM(AAHR12)
             DLTOVR     FILE(INPUT)
             DLTF       FILE(AAHWP101)

     /* FOR AUTO DAILY PROCESS */
             IF         (%SWITCH(1XXXXXXX)) DO
             IF         COND(&WS5 *EQ 'DAILY') THEN(GOTO CMDLBL(END))
             ENDDO

             IF         (%SWITCH(1XXXXXXX)) DO
 SF1:        SNDPGMMSG  MSG('( G ) BECAUSE A CALENDAR IS +
                          ABNORMAL,INFORM YOU TO COMPUTER PERSON IN +
                          CHARGE.') TOMSGQ(QSYS/QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE *EQ 'G') GOTO END
             GOTO       SF1
             ENDDO


 END:        CHGJOB     RUNPTY(20)

             ENDPGM

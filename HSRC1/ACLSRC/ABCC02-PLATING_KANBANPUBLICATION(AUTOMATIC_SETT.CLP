             PGM
             /** ABCC02 **************************************/
             /* PLATING KANBANPUBLICATION(AUTOMATIC SETTING NUMBER HANDLING)*/
             /* I-HASADA                      94.07.11       */
             /************************************** ABCC02 **/
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             DLTF       FILE(ABCWPM1)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(ABCWPM11)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(ABCWPM1H)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(ABCWPPR1)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/ABCWPM1) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/ABCWPM11) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/ABCWPM1H) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/ABCWPPR1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(ABCWPM1)
             OVRDBF     FILE(OUTPUT2) TOFILE(ABCWPM11)
             OVRDBF     FILE(OUTPUT3) TOFILE(ABCWPM1H)
             OVRDBF     FILE(OUTPUT4) TOFILE(ABCWPPR1)
             CALL       PGM(AAFR10) PARM('Z')
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)
             DLTOVR     FILE(OUTPUT3)
             DLTOVR     FILE(OUTPUT4)
             DLTF       FILE(ABCWPM1H)

             OVRDBF     FILE(INPUT) TOFILE(ABCWPM11)
             CALL       PGM(AAFR12)
             DLTOVR     FILE(INPUT)
             DLTF       FILE(ABCWPM11)

             IF         (%SWITCH(1XXXXXXX)) DO
 SF1:        SNDPGMMSG  MSG('( G ) CALENDAR IS BEING ABNORMAL,PLEASE +
                          CONTACT YOU TO INFORMATION SECTION') +
                          TOMSGQ(QSYS/QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE *EQ 'G') GOTO END
             GOTO       SF1
             ENDDO

             /*----------------------*/
             /*   USUALLY   KANBAN   */
             /*----------------------*/
             IF         (%SWITCH(X1XXXXXX)) DO

             DLTF       FILE(ABCWPMK)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWPMK) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABCWPM1)) +
                          OUTFILE(HWFILE1/ABCWPMK) SRCFILE(FMTSRC) +
                          SRCMBR(AAFS10) OPTION(*NOPRT)
             DLTF       FILE(ABCWPM1)

             ENDDO
             ELSE       DO

             DLTF       FILE(ABCWPM1)
             DLTF       FILE(ABCWPMK)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDDO

 END:        ENDPGM

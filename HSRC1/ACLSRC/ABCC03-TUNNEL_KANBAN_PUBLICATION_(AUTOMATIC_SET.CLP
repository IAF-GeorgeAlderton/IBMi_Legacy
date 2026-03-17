             PGM
             /** ABCC03 ****************************************/
             /*  TUNNEL KANBAN PUBLICATION (AUTOMATIC SETTING NUMBER HANDLING)*/
             /* I-HASADA                        94.07.11       */
             /**************************************** ABCC03 **/
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             DLTF       FILE(ABCWPT1)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(ABCWPT11)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(ABCWPT1H)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/ABCWPT1) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/ABCWPT11) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/ABCWPT1H) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(ABCWPT1)
             OVRDBF     FILE(OUTPUT2) TOFILE(ABCWPT11)
             OVRDBF     FILE(OUTPUT3) TOFILE(ABCWPT1H)
             OVRDBF     FILE(OUTPUT4) TOFILE(ABCWPPR1)
             CALL       PGM(AAGR10) PARM('Z')
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)
             DLTOVR     FILE(OUTPUT3)
             DLTOVR     FILE(OUTPUT4)
             DLTF       FILE(ABCWPT1H)

             OVRDBF     FILE(INPUT) TOFILE(ABCWPT11)
             CALL       PGM(AAGR12)
             DLTOVR     FILE(INPUT)
             DLTF       FILE(ABCWPT11)

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

             DLTF       FILE(ABCWPTN)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWPTN) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABCWPT1)) +
                          OUTFILE(HWFILE1/ABCWPTN) SRCFILE(FMTSRC) +
                          SRCMBR(AAGS10) OPTION(*NOPRT)
             DLTF       FILE(ABCWPT1)

             ENDDO
             ELSE       DO

             DLTF       FILE(ABCWPT1)
             DLTF       FILE(ABCWPTN)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDDO

 END:        ENDPGM

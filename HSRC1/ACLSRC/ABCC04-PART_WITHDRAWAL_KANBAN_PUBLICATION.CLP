             PGM
             /** ABCC04 ************************************/
             /* PART WITHDRAWAL KANBAN PUBLICATION         */
             /*              (AUTOMATIC SETTING HANDLING). */
             /* I-HASADA                    94.07.11       */
             /************************************ ABCC04 **/
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             DLTF       FILE(ABCWPH1)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(ABCWPH11)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(ABCWPH1H)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/ABCWPH1) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/ABCWPH11) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/ABCWPH1H) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(ABCWPH1)
             OVRDBF     FILE(OUTPUT2) TOFILE(ABCWPH11)
             OVRDBF     FILE(OUTPUT3) TOFILE(ABCWPH1H)
             OVRDBF     FILE(OUTPUT4) TOFILE(ABCWPPR1)
             CALL       PGM(AAHR10) PARM('Z')
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)
             DLTOVR     FILE(OUTPUT3)
             DLTOVR     FILE(OUTPUT4)
             DLTF       FILE(ABCWPH1H)

             OVRDBF     FILE(INPUT) TOFILE(ABCWPH11)
             CALL       PGM(AAHR12)
             DLTOVR     FILE(INPUT)
             DLTF       FILE(ABCWPH11)

             IF         (%SWITCH(1XXXXXXX)) DO
 SF1:        SNDPGMMSG  MSG('( G ) A CALENDAR IS BEING +
                          ABNORMAL,PLEASE CONTACT YOU TO +
                          INFORMATION SECTION') +
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

             DLTF       FILE(ABCWPHT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWPHT) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABCWPH1)) +
                          OUTFILE(HWFILE1/ABCWPHT) SRCFILE(FMTSRC) +
                          SRCMBR(AAHS10) OPTION(*NOPRT)
             DLTF       FILE(ABCWPH1)

             ENDDO
             ELSE       DO

             DLTF       FILE(ABCWPH1)
             DLTF       FILE(ABCWPHT)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDDO

 END:        ENDPGM

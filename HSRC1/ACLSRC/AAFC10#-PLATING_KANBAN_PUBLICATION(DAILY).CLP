             PGM
             /** AAFC10 ***************************************************/
             /*   PLATING KANBAN PUBLICATION(DAILY).                      */
             /* S.YAMAGAMI               93.11.05                         */
             /* H.AMANO                  02.03.19                         */
             /* H.AMANO                  04.05.11                         */
             /* JW1       2023.06.02 SKIP MONTHLY AUTO SETTING ERROR      */
             /* JW2       2025.09.09 CHG DISPLAY MSG TO UTLC97A           */
             /*************************************************************/
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS5)   TYPE(*CHAR) LEN(5)
/* JW2 */
             DCL        VAR(&LIN1) TYPE(*CHAR) LEN(60)
             DCL        VAR(&LIN2) TYPE(*CHAR) LEN(60)
             CHGVAR     VAR(&LIN1) VALUE('Someone is going to +
                          process this job,')
             CHGVAR     VAR(&LIN2) VALUE('or previous data was not +
                          processed properly (AAFC10)')

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WS5) VALUE(%SST(&WSID 1 5))

             CHGJOB     RUNPTY(40) SWS(00000000)

             CALL       PGM(AAFR13) PARM('AAFT0111' 'C')

     /* FOR AUTO DAILY PROCESS */
             IF         (%SWITCH(XXXXXXX1)) DO
             IF         COND(&WS5 *EQ 'DAILY') THEN(GOTO CMDLBL(END))
             ENDDO

     /* JW1: SKIP AUTO SETTING ERROR (I0888)  */
             IF         (%SWITCH(XXXXXXX1)) DO
             IF         COND(&USER *EQ 'I0888') THEN(GOTO CMDLBL(END))
             ENDDO

             IF         (%SWITCH(XXXXXXX1)) DO

             CALL       PGM(UTLC97A) PARM((&LIN1) (&LIN2))
             GOTO       END

  /** JW2                                                                **/
  /**  STP0: SNDPGMMSG  MSG('( G ) DATA OF LAST TIME HAD NOT +           **/
  /**                     PROCESSED BY COMMUNICATION (AAFC10)') +        **/
  /**                     TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)      **/
  /**        RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +         **/
  /**                     MSG(&KOTAE)                                    **/
  /**        IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +   **/
  /**                     THEN(GOTO CMDLBL(STP0))                        **/
  /**        GOTO       END                                              **/

             ENDDO

             CHKOBJ     OBJ(&WLIB/AAFACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))

     /* FOR AUTO DAILY PROCESS */
             IF         COND(&WS5 *EQ 'DAILY') THEN(GOTO CMDLBL(END))

             SNDBRKMSG  MSG('SOMEBODY ELSE IS USING THE SAME +
                          PROGRAM. RUN IT LATER. (AAFC10)') +
                          TOMSGQ(&WSID) MSGTYPE(*INFO)
             GOTO       END

 STP1:       CRTDTAARA  DTAARA(&WLIB/AAFACT) TYPE(*CHAR) LEN(10) +
                          TEXT('PLATING KANBAN PUBLICATION')


             CHGJOB     SWS(00000000)

             CALL       PGM(AAFR13) PARM('AAFT0111' 'H')

             DLTF       FILE(AAFWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(AAFWP101)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(AAFWP10H)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(AAFWP10T)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/AAFWP10) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(&WLIB/AAFWP101) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(&WLIB/AAFWP10H) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(&WLIB/AAFWP10T) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(AAFWP10)
             OVRDBF     FILE(OUTPUT2) TOFILE(AAFWP101)
             OVRDBF     FILE(OUTPUT3) TOFILE(AAFWP10H)
             OVRDBF     FILE(OUTPUT4) TOFILE(AAFWP10T)
             CALL       PGM(AAFR10) PARM(' ')
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)
             DLTOVR     FILE(OUTPUT3)
             DLTOVR     FILE(OUTPUT4)

             OVRDBF     FILE(INPUT) TOFILE(AAFWP101)
             CALL       PGM(AAFR12)
             DLTOVR     FILE(INPUT)
             DLTF       FILE(AAFWP101)

     /* FOR AUTO DAILY PROCESS */
             IF         (%SWITCH(1XXXXXXX)) DO
             IF         COND(&WS5 *EQ 'DAILY') THEN(GOTO CMDLBL(SEND))
             ENDDO

             IF         (%SWITCH(1XXXXXXX)) DO
 SF1:        SNDPGMMSG  MSG('( G ) CALENDAR BEING ABNORMAL SO THAT +
                          PLEASE CONTACT INFORMATION SECTION +
                          (AAFC10)') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(SEND))
             GOTO       SF1
             ENDDO
             /*----------------------*/
             /*   USUALLY   KANBAN   */
             /*----------------------*/
             IF         (%SWITCH(X1XXXXXX)) DO

             DLTF       FILE(AAFWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAFWP11) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(AAFWP12)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAFWP12) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(AAFT0111)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAFT0111) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AAFWP10)) +
                          OUTFILE(&WLIB/AAFWP11) SRCFILE(FMTSRC) +
                          SRCMBR(AAFS10) OPTION(*NOPRT)
             DLTF       FILE(AAFWP10)

             OVRDBF     FILE(OUTPUT1) TOFILE(AAFWP11)
             OVRDBF     FILE(OUTPUT2) TOFILE(AAFWP12)
             CALL       PGM(AAFR80)
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)

             OVRDBF     FILE(OUTPUT1) TOFILE(AAFWP12)
             OVRDBF     FILE(OUTPUT2) TOFILE(AAFT0111)
             CALL       PGM(AAFR81)
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)

             DLTF       FILE(AAFWP11)

             IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)
             CALL       PGM(AAFR13) PARM('AAFT0111' ' ')
             ENDDO

             ENDDO
             ELSE       DO

             CALL       PGM(AAFR13) PARM('AAFT0111' 'D')

             DLTF       FILE(AAFWP10)
             DLTF       FILE(AAFWP11)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDDO
             /*----------------------*/
             /*    FRACTIONS KANBAN   */
             /*----------------------*/
             IF         (%SWITCH(XX1XXXXX)) DO

             DLTF       FILE(AAFWP11H)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAFWP11H) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(AAFWP12H)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAFWP12H) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(AAFWP13H)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAFWP13H) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AAFWP10H)) +
                          OUTFILE(&WLIB/AAFWP11H) SRCFILE(FMTSRC) +
                          SRCMBR(AAFS10) OPTION(*NOPRT)
             DLTF       FILE(AAFWP10H)

             OVRDBF     FILE(OUTPUT1) TOFILE(AAFWP11H)
             OVRDBF     FILE(OUTPUT2) TOFILE(AAFWP12H)
             CALL       PGM(AAFR80)
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)

             OVRDBF     FILE(OUTPUT1) TOFILE(AAFWP12H)
             OVRDBF     FILE(OUTPUT2) TOFILE(AAFWP13H)
             CALL       PGM(AAFR81)
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)

             DLTF       FILE(AAFWP11H)

             IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)
             CALL       PGM(AAFR13) PARM('AAFT0111' ' ')
             ENDDO

             ENDDO
             ELSE       DO

             CALL       PGM(AAFR13) PARM('AAFT0111' 'D')

             DLTF       FILE(AAFWP10H)
             DLTF       FILE(AAFWP11H)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDDO


 SEND:
             DLTDTAARA  DTAARA(&WLIB/AAFACT)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM

             PGM
             /** AAPC90 ****************************/
             /*  DATA TRANSFER                     */
             /*  A.MAMIYA              2000.10.24  */
             /**************************** AAPC90 **/
             DCLF       FILE(AAPPW90)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGMSGQ    MSGQ(&WSID) DLVRY(*BREAK)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AAPPW901)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&ERR) VALUE(*BLANK)

             IF         COND(&@KUBN *EQ '1') THEN(GOTO CMDLBL(STP2))
             IF         COND(&@KUBN *EQ '2') THEN(GOTO CMDLBL(STP2))
             IF         COND(&@KUBN *EQ '3') THEN(GOTO CMDLBL(STP2))
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN01) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('PLEASE INPUT 1 OR 2 OR 3')
             GOTO STP1

STP2:        IF         (&IN05 *EQ '0') GOTO STP1

             /************************************/
             /* KANBAN MASTER FILE DATA TRANSFER */
             /************************************/
             IF         COND(&@KUBN *EQ '1') THEN(DO)
             DLTF       FILE(AAPWP90)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAPWP90) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(AAPWP91)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAPWP91) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AAPR90)
             ENDDO
             /*********************************************/
             /* PART INFOMATION MASTER FILE DATA TRANSFER */
             /*********************************************/
             IF         COND(&@KUBN *EQ '2') THEN(DO)
             DLTF       FILE(AAPWP92)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAPWP92) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(AAPWP93)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAPWP93) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AAPR91)
             ENDDO
             /*****************************/
             /* WASHER PART DATA TRANSFER */
             /*****************************/
             IF         COND(&@KUBN *EQ '3') THEN(DO)
             DLTF       FILE(AAPWP94)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAPWP94) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AAPR92)
             ENDDO

 END:     /* DLTF       FILE(AAPWP90)  */
          /* MONMSG     MSGID(CPF3261 CPF2105)  */
          /* DLTF       FILE(AAPWP91)  */
          /* MONMSG     MSGID(CPF3261 CPF2105)  */
          /* DLTF       FILE(AAPWP92)  */
          /* MONMSG     MSGID(CPF3261 CPF2105)  */
          /* DLTF       FILE(AAPWP93)  */
          /* MONMSG     MSGID(CPF3261 CPF2105)  */
          /* DLTF       FILE(AAPWP94)  */
          /* MONMSG     MSGID(CPF3261 CPF2105)  */
             DLTOVR     FILE(*ALL)

             ENDPGM

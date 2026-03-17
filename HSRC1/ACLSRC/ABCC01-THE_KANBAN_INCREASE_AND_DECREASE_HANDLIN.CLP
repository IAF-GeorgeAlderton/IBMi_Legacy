             PGM        PARM(&PKBN &PCD &PYM)
             /** ABCC01 ********************/
             /*   THE KANBAN INCREASE AND DECREASE HANDLING   */
             /* I-HASADA 86.12.08 */
             /******************** ABCC01 **/
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD1) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD2) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD4) TYPE(*CHAR) LEN(3)
             DCL        VAR(&HIZK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&HIZK) VALUE(%SUBSTRING(&MCEDP01 1 6))

             /*----------------------------*/
             /*   THE HANDWRITING KANBAN INCREASE AND DECREASE   */
             /*----------------------------*/
             DLTF       FILE(ABCWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWP01) RCDLEN(350) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             /*--------------------------*/
             /*   THE SUPPLIER KANBAN INCREASE AND DECREASE   */
             /*--------------------------*/
             DLTF       FILE(ABCWP1Y)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWP1Y) RCDLEN(200) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             /*--------------------------*/
             /*   THE QUENCHING KANBAN INCREASE AND DECREASE   */
             /*--------------------------*/
             DLTF       FILE(ABCWP1Z)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWP1Z) RCDLEN(200) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             /*----------------*/
             /*   A LABEL   */
             /*----------------*/
             DLTF       FILE(ABCWPR1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWPR1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(20000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             /*----------------------------*/
             /*   THE INTRA-PROCESS KANBAN INCREASE AND DECREASE   */
             /*----------------------------*/
             DLTF       FILE(ABCWP1X)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWP1X) RCDLEN(250) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ABCR01) PARM(&PKBN &PYM &HIZK &PCD &PCD1 +
                          &PCD2 &PCD3 &PCD4)

             IF         (%SWITCH(1XXXXXXX)) DO
 STP1:       SNDPGMMSG  MSG('( G ) CALENDAR IS BEING WRONG, PLEASE +
                          CONTACT YOU TO EDP SECTION') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP1
             ENDDO

             /*----------------------------*/
             /*   THE INTRA-PROCESS KANBAN INCREASE AND DECREASE   */
             /*----------------------------*/
             IF         (%SWITCH(XX1XXXXX)) DO

             DLTF       FILE(ABCWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWP11) RCDLEN(250) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABCWP1X)) +
                          OUTFILE(HWFILE1/ABCWP11) SRCFILE(FMTSRC) +
                          SRCMBR(ABCS11) OPTION(*NOPRT)
             DLTF       FILE(ABCWP1X)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) LPI(6) CPI(15) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABCR11) PARM(&PCD &PCD1 &PCD2 &PCD3 &PCD4)
             DLTOVR     FILE(QPRINT)
             ENDDO

             ELSE       DO
             DLTF       FILE(ABCWP1X)
             ENDDO

             /*--------------------------*/
             /*   THE SUPPLIER KANBAN INCREASE AND DECREASE   */
             /*--------------------------*/
             IF         (%SWITCH(XXX1XXXX)) DO

             DLTF       FILE(ABCWP2Y)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWP2Y) RCDLEN(200) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABCWP1Y)) +
                          OUTFILE(HWFILE1/ABCWP2Y) SRCFILE(FMTSRC) +
                          SRCMBR(ABCS14) OPTION(*NOPRT)
             DLTF       FILE(ABCWP1Y)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABCR14) PARM(&PCD &PCD1 &PCD2 &PCD3 &PCD4)
             DLTOVR     FILE(QPRINT)
             ENDDO

             ELSE       DO
             DLTF       FILE(ABCWP1Y)
             ENDDO

             /*--------------------------*/
             /*   THE QUENCHING KANBAN INCREASE AND DECREASE   */
             /*--------------------------*/
             IF         (%SWITCH(XXXX1XXX)) DO

             DLTF       FILE(ABCWP2Z)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWP2Z) RCDLEN(200) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABCWP1Z)) +
                          OUTFILE(HWFILE1/ABCWP2Z) SRCFILE(FMTSRC) +
                          SRCMBR(ABCS17) OPTION(*NOPRT)
             DLTF       FILE(ABCWP1Z)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) LPI(6) CPI(15) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABCR17) PARM(&PCD &PCD1 &PCD2 &PCD3 &PCD4)
             DLTOVR     FILE(QPRINT)
             ENDDO

             ELSE       DO
             DLTF       FILE(ABCWP1Z)
             ENDDO

             /*----------------------------*/
             /*   THE HANDWRITING KANBAN INCREASE AND DECREASE   */
             /*----------------------------*/
             IF         (%SWITCH(X1XXXXXX)) DO

             DLTF       FILE(ABCWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWP02) RCDLEN(350) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABCWP01)) +
                          OUTFILE(HWFILE1/ABCWP02) SRCFILE(FMTSRC) +
                          SRCMBR(ABCS02) OPTION(*NOPRT)
             DLTF       FILE(ABCWP01)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) LPI(6) CPI(15) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABCR02) PARM(&PCD &PCD1 &PCD2 &PCD3 &PCD4)
             DLTOVR     FILE(QPRINT)
             ENDDO

             ELSE       DO
             DLTF       FILE(ABCWP01)
             ENDDO

             /*----------------------------------*/
             /*   THE COMPONENTS KANBAN INCREASE AND DECREASE HANDLING   */
             /*----------------------------------*/
             CALL       PGM(ABEC01) PARM(&PKBN &PYM &HIZK &PCD &PCD1 +
                          &PCD2 &PCD3 &PCD4)

             /*------------------------*/
             /*   PLATING KANBAN   */
             /*------------------------*/
             CALL       PGM(ABCC02)

             /*--------------------------*/
             /*   TUNNEL KANBAN   */
             /*--------------------------*/
             CALL       PGM(ABCC03)

             /*----------------------*/
             /*   PART WITHDRAWAL KANBAN   */
             /*----------------------*/
             CALL       PGM(ABCC04)

             /*----------------------------------*/
             /* LISTS KANBAN PUBLICATION DATA   */
             /*   PLATING TUNNEL / PICK-UP */
             /*----------------------------------*/
             DLTF       FILE(ABCWPPR2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABCWPPR2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABCWPPR1)) +
                          OUTFILE(HWFILE1/ABCWPPR2) SRCFILE(FMTSRC) +
                          SRCMBR(ABCS18) OPTION(*NOPRT)
             DLTF       FILE(ABCWPPR1)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(ABCR18)
             DLTOVR     FILE(QPRINT)

             /*----------------*/
             /*   A LABEL   */
             /*----------------*/
   /*        IF         (&PKBN *EQ 'A') DO       */
   /*        CALL       PGM(GCGC10)              */
   /*        ENDDO                               */

 END:        ENDPGM

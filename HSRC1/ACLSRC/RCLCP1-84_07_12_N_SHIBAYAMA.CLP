             PGM
             /** RCLCP1 ************************************/
         /*RCLCP1 PRODUCT DEMAND FORECAST INPUT(EXTRA DELIVERY INSTRUCTION)*/
             /*        .84.07.12             N.SHIBAYAMA */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&FIL1) VALUE('RCLWP11' *CAT +
                        (%SUBSTRING(&WSID 1 2)))
             CHGVAR     VAR(&FIL2) VALUE('RCLWP12' *CAT +
                        (%SUBSTRING(&WSID 1 2)))
             CHGVAR     VAR(&FIL3) VALUE('RAAWPA6' *CAT +
                        (%SUBSTRING(&WSID 1 2)))

             DLTF     FILE(&FIL1)
             MONMSG   MSGID(CPF3261 CPF2105)
             DLTF     FILE(&FIL2)
             MONMSG   MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/&FIL1) RCDLEN(179) +
                          TEXT('INSTRUCTION EXTRA INPUT-FILE') SIZE(1000 100) +
                          LVLCHK(*NO)
             CRTPF      FILE(HWFILE1/&FIL2) RCDLEN(179) +
                          TEXT('INSTRUCTION EXTRA SORTFINISHED -FILE') +
                          SIZE(1000 100) +
                          LVLCHK(*NO)

             CHGJOB     SWS(00000000)

             OVRDBF     FILE(RCLWP11) TOFILE(&FIL1)
             CALL       PGM(RCLR11)
             DLTOVR     FILE(RCLWP11)

             IF         (%SWITCH(1XXXXXXX)) GOTO STEP3
             IF         (%SWITCH(X1XXXXXX)) GOTO STEP3
             GOTO       END

 STEP3:      FMTDTA     INFILE((&FIL1)) OUTFILE(&FIL2) +
                          SRCFILE(FMTSRC) SRCMBR(AAXS16) +
                          OPTION(*NOPRT *NOCHK)
             DLTF       FILE(&FIL1)

             IF         (%SWITCH(0XXXXXXX)) GOTO STEP1

 CTP3:       CHKOBJ     OBJ(HFILE1/RCLACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CTP1))

 CTP2:     SNDPGMMSG  MSG('(G)LIMITED K TEMP ACCUMULATION DATA +
                           IS ACTIVE WAIT MINUTES') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE *NE 'G') GOTO CTP2
             GOTO       CTP3

 CTP1:       CRTDTAARA  DTAARA(HFILE1/RCLACT) TYPE(*CHAR) LEN(10) +
                          TEXT('FOR LIMITED K TEMPORARY +
                          ACCUMULATION DATA CHECK')

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL3) RCDLEN(100) +
                          TEXT('PROD.    ORDER NO.-WORK') +
                          OPTION(*NOLIST) SIZE(100 100) +
                          ALLOCATE(*YES) CONTIG(*YES) LVLCHK(*NO)

             OVRDBF     FILE(RCLWP12) TOFILE(&FIL2)
             OVRDBF     FILE(RAAWPA6) TOFILE(&FIL3)
             CALL       PGM(RAARA6) PARM(&USER)
             DLTOVR     FILE(RCLWP12)

             OVRPRTF    FILE(KAAPR01) PAGESIZE(66) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          COPIES(2) /* LIMITATION KANBAN DETAILS & ERROR LIST */
             CALL       PGM(KAAR01) PARM('B' &USER)
             DLTOVR     FILE(RAAWPA6)
             DLTOVR     FILE(KAAPR01)
             DLTF       FILE(&FIL3)

             DLTDTAARA  DTAARA(HFILE1/RCLACT)
             MONMSG   MSGID(CPA0701 CPF2105)

             IF         (%SWITCH(X0XXXXXX)) GOTO END

 STEP1:      OVRPRTF    FILE(QPRINT) OVRFLW(65) ALIGN(*YES) +
                          OUTQ(&PRTG) FORMTYPE(D973) /* PROD.    ORDER BOOK */
             OVRDBF     FILE(RAAWP13) TOFILE(&FIL2)
             CALL       PGM(GCLR03) PARM(&USER)
             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(RAAWP13)
             MONMSG     MSGID(CPF2128)
             DLTF       FILE(&FIL2)
             MONMSG   MSGID(CPF3261 CPF2105)
             GOTO       FIN

 END:        DLTF       FILE(&FIL1)
             MONMSG   MSGID(CPF3261 CPF2105)
             DLTF       FILE(&FIL2)
             MONMSG   MSGID(CPF3261 CPF2105)

 FIN:        ENDPGM

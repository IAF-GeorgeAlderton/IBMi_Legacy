             PGM
             /** MBDC57 *********************************/
             /* YEARLY RESULT LIST BY RECEIVING ... */
             /*         I-HASADA 85.07.23               */
             /*         N-HYOTO  01.04.09 ADD AMOUNT    */
             /********************************* MBDC57 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PHIZK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHIZ1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHIZ2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WS) USER(&US)
             CHGJOB     RUNPTY(40) SWS(00000000)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)


             DLTF       FILE(MBDWP57)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MBDWP57) RCDLEN(20) +
                          OPTION(*NOLIST) SIZE(100 100) LVLCHK(*NO)

             CALL       PGM(MBDR57) PARM(&PHIZK &PHIZ1 &PHIZ2)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(MBDWP57)
             GOTO       END
             ENDDO

             DLTF       FILE(MBDWP58)
             MONMSG   MSGID(CPF3261 CPF2105)
             DLTF       FILE(MBDWP59)
             MONMSG   MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/MBDWP58) RCDLEN(98) +
                          OPTION(*NOLIST) SIZE(50000 10000 3) +
                          LVLCHK(*NO)
             CRTPF      FILE(&WLIB/MBDWP59) RCDLEN(98) +
                          OPTION(*NOLIST) SIZE(50000 10000 3) +
                          LVLCHK(*NO)

 STP2:       SNDPGMMSG  MSG('( G.C ) DELIVERY STATISTICS FILE' *CAT &PHIZ1 +
                        *CAT 'MONTH SET TAPE') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STP3))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP2

 STP3:       RSTOBJ     OBJ(MBDPP01) SAVLIB(HFILE1) DEV(TAPE1) +
                          OBJTYPE(*FILE) VOL(IAF) ENDOPT(*UNLOAD) +
                          RSTLIB(IKOULIB)
             CPYF       FROMFILE(IKOULIB/MBDPP01) TOFILE(MBDWP58) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(IKOULIB/MBDPP01)

 STP4:       SNDPGMMSG  MSG('( G.C ) DELIVERY STATISTICS FILE' *CAT &PHIZ2 +
                          *CAT 'MONTH SET TAPE') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STP5))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP4

 STP5:       RSTOBJ     OBJ(MBDPP01) SAVLIB(HFILE1) DEV(TAPE1) +
                          OBJTYPE(*FILE) VOL(IAF) ENDOPT(*UNLOAD) +
                          RSTLIB(IKOULIB)
             CPYF       FROMFILE(IKOULIB/MBDPP01) TOFILE(MBDWP59) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(IKOULIB/MBDPP01)

 STP6:       SNDPGMMSG  MSG('( G.C ) TAKE OUT DELIVERY STATISTICS FILE <2D> +
                        TAPE') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STP7))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP6

 STP7:       CLRPFM     FILE(MBDWP61)
             CALL       PGM(MBDR58)

             DLTF       FILE(MBDWP57)
             DLTF       FILE(MBDWP58)
             DLTF       FILE(MBDWP59)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(MBDR59) PARM(&PHIZK)

             DLTF       FILE(&WLIB/WMBDWP61)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(WMBDWP61)
             MONMSG     MSGID(CPF0000)

             RUNQRY     QRY(QMBDWP61) QRYFILE((&WLIB/MBDWP61))

             DLTOVR     FILE(QPRINT)
             CLRPFM     FILE(MBDWP61)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM

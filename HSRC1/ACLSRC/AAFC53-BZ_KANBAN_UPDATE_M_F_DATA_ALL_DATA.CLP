             PGM
             /** AAFC53 **************************************/
             /* BZ KANBAN UPDATE M/F DATA ALL DATA */
             /* PROCEDURE OF KANBAN SORTING MACHINE M/F ALL CHANGE */
             /* 1. LO.DPSMNT +KEY                              */
             /* 2. R.             +KEY                         */
             /* 3. CHECK M/F INITIALIZED INDEX */
             /* 4. SUPPLIER M/F INITIALIZE */
             /* 5. KANBAN M/F INITIALIZE*/
             /* 6. SUPPLIER M/F INPUT                              */
             /* 7. KANBAN M/F INPUT                              */
             /* 8. CHECK M/F INPUT                               */
             /*         I-HASADA               86.10.20      */
             /************************************** AAFC53 **/
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DLTF       FILE(AAFWP53)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AAFWP53) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(2000 1000 5) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINT) FORMTYPE(K6S1)
             CALL       PGM(AAFR53)
             DLTOVR     FILE(QPRINT)
 STP1:       SNDPGMMSG  MSG('( G.C ) BZKANBAN M/F UPDATE DATA < +
                          BZ.ALLDATA > SET DISKETT') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'G') GOTO STP2
             IF         (&KOTAE = 'C') GOTO END
             GOTO       STP1
 STP2:       CLRDKT     DEV(QDKT) VOL(AOYAMA) CHECK(*NO)
             CPYTODKT   FROMFILE(AAFWP53) TOFILE(QDKT) +
                          TOLABEL(KBANDATA) TOVOL(AOYAMA)
             DLTF       FILE(AAFWP53)
 STP3:       SNDPGMMSG  MSG('( G ) BZKANBAN M/F UPDATE DATA < BZ.ALLDATA +
                          > TAKE OUT DISKETT') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'G') GOTO STP4
             GOTO STP3
 STP4:       DLTF       FILE(AAFWP54)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AAFWP54) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(2000 1000 5) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINT) FORMTYPE(K6S1)
             CALL       PGM(AAFR54)
             DLTOVR     FILE(QPRINT)
 BTP1:       SNDPGMMSG  MSG('( G.C ) BZKANBAN M/F UPDATE DATA < +
                          BZ.ALLDATA > SET DISKETT') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'G') GOTO BTP2
             IF         (&KOTAE = 'C') GOTO END
             GOTO       BTP1
 BTP2:       CLRDKT     DEV(QDKT) VOL(AOYAMA) CHECK(*NO)
             CPYTODKT   FROMFILE(AAFWP54) TOFILE(QDKT) +
                          TOLABEL(KBANDATA) TOVOL(AOYAMA)
 BTP3:       SNDPGMMSG  MSG('( G ) BZKANBAN M/F UPDATE DATA < BZ.ALLDATA +
                          > TAKE OUT DISKETT') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'G') GOTO END
             GOTO BTP3
 END:        ENDPGM

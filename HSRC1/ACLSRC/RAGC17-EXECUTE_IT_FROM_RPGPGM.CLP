             /***RAGC17********************************/
             /* ...TOYOTA CAR BODY DELIVERY OF PRODUCTS DATA CREATE ... */
             /*            EXECUTE IT FROM RPGPGM   */
             /*               PGM NAME RAGR17... */
             /* I-HASADA                83.03.24      */
             /*********************************RAGC17**/
             PGM        PARM(&KUBN)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KUBN) TYPE(*CHAR) LEN(1)
             CHGJOB     SWS(00000000)
             DLTF       FILE(RAGWP17)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/RAGWP17) RCDLEN(56) +
                        TEXT('TOYOTA SHATAI DELV PROD ODR RCP DATA +
                        SORT OUTPUT') OPTION(*NOLIST) SIZE(2000 1000 2) +
                        LVLCHK(*NO)
             CHKOBJ     OBJ(RA#NP16) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(XTP1))
             FMTDTA     INFILE((RA#NP16)) OUTFILE(RAGWP17) +
                          SRCFILE(FMTSRC) SRCMBR(AAXS09) +
                          OPTION(*NOPRT)
             CLRPFM     FILE(RA#NP16)
 XTP1:       DLTF       FILE(RAGWP18)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/RAGWP18) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) LVLCHK(*NO)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(UPRINT) FORMTYPE(K6H1) HOLD(*YES)
             CALL       PGM(RAGR16)
             DLTF       FILE(RAGWP17)
             DLTOVR     FILE(QPRINT)
             IF         (%SWITCH(1XXXXXXX)) GOTO STP6
             DLTF       FILE(RAGWP18)
             GOTO       END
 STP6:       SNDPGMMSG  MSG('( G.C ) JITU3158 46 TOYOTA CAR BODY +
                          SET DELIVERY DATA DISKETT +
                          FROM...ORDER RECEIPT DATA INPUT') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'G') GOTO STP4
             IF         (&KOTAE = 'C') RETURN
             GOTO       STP6
 STP4:       CLRDKT     DEV(QDKT) VOL(AOYAMA) CHECK(*NO)
             OVRDKTF    FILE(QDKT) VOL(AOYAMA) LABEL(JITU3158)
             CPYF       FROMFILE(RAGWP18) TOFILE(QDKT) MBROPT(*REPLACE)
             DLTOVR     FILE(QDKT)
 STP5:       SNDPGMMSG  MSG('( G ) JITU3158 46 TAKE IT OUT') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'G') GOTO END
             GOTO       STP5
 END:        RETURN
             ENDPGM

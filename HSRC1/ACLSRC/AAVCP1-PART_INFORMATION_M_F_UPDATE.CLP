             PGM
             /** AAVCP1 ****************************************/
             /* PART INFORMATION M/F UPDATE                    */
             /* I-HASADA                     87.01.17          */
             /* N-HYOTO 2001.02.28 ADD TEST MODE               */
             /* TCH     2005.02.18 ADDED &WLIB  IN ALBCHK      */
             /*            AND OAECHK1                         */
             /* JW1   2018.09.07 CHG ERROR MSG FOR USING OTHER */
             /**************************************************/
             DCL        VAR(&JAVDS1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PM)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&PKYM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&FLA5)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FLB5)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FLH5)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FLI5)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FLJ5)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FLO)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AAVACT' 'AAVCP1' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO END)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVDTAARA  DTAARA(JAVDS1) RTNVAR(&JAVDS1)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)

             CHGVAR     VAR(&PM) VALUE(%SST(&ABADS1 5 2))
             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABBDS3 1 6))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

      /*JW1  CHKOBJ     OBJ(&WLIB/AAVACT) OBJTYPE(*DTAARA)             */
      /*     MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))         */
      /*                                                               */
      /*     STP2: SNDPGMMSG  MSG('( G ) KANBAN M/F LIST HANDLING OR + */
      /*                PROD ORDER BOOK MAKING  HANDLING OR +          */
      /*                INTRA-PROCESS LOCATION CODE M/F IS +           */
      /*                ACTIVE, WAIT FOR A WHILE') TOMSGQ(&WSID) +     */
      /*                MSGTYPE(*INQ) KEYVAR(&MBAN)                    */
      /*     RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +       */
      /*                MSG(&KOTE)                                     */
      /*     IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +   */
      /*                THEN(GOTO CMDLBL(STP2))                        */
      /*     GOTO       END                                            */

 STP1:
      /*JW1  CRTDTAARA  DTAARA(&WLIB/AAVACT) TYPE(*CHAR) LEN(10) +     */
      /*                  TEXT('PART INFORMATION M/F UPDATE +          */
      /*                  HANDLING') AUT(*ALL)                         */

             IF         (&JAVDS1 *EQ 'Y') DO
 STP3:       SNDPGMMSG  MSG('( G ) BEING CHGJRN, PART M/F UPDATE +
                        HANDLING GO INAFTER 5 MINUTES ...') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP3))
             GOTO       STP4
             ENDDO

             CLRPFM     FILE(GHCWP21)
             CLRPFM     FILE(GHCWP22)
             CLRPFM     FILE(GHCTP22)
             CLRPFM     FILE(GHCNP21)

 /* WORK FILE CREATE */
             CHGVAR     VAR(&FLA5) VALUE('ALBWPA5' *CAT (%SST(&WSID 1 +
                          2)))
             CHGVAR     VAR(&FLB5) VALUE('ALBWPB5' *CAT (%SST(&WSID 1 +
                          2)))
             CHGVAR     VAR(&FLH5) VALUE('ALBWPH5' *CAT (%SST(&WSID 1 +
                          2)))
             CHGVAR     VAR(&FLI5) VALUE('ALBWPI5' *CAT (%SST(&WSID 1 +
                          2)))
             CHGVAR     VAR(&FLJ5) VALUE('ALBWPJ5' *CAT (%SST(&WSID 1 +
                          2)))
             CHGVAR     VAR(&FLO) VALUE('OAEWP01' *CAT (%SST(&WSID 1 +
                          2)))
             CHGVAR     VAR(&FILE) VALUE('AIA' *CAT (%SST(&WSID 1 2)))

             DLTF       FILE(&WLIB/&FLA5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FLA5) RCDLEN(130) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&FLB5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FLB5) RCDLEN(130) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&FLH5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FLH5) RCDLEN(130) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&FLI5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FLI5) RCDLEN(130) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&FLJ5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FLJ5) RCDLEN(130) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE) RCDLEN(300) +
                          TEXT('TOSHIBA  UPDATE M/F DATA') +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(&WLIB/&FLO)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FLO) RCDLEN(51) OPTION(*NOLIST +
                          *NOSRC) SIZE(5000 1000 3) LVLCHK(*NO) +
                          AUT(*ALL)

 /* KANBAN M/F & CHECK M/F CREATE */
             OVRDBF     FILE(ALBWPA5) TOFILE(&WLIB/&FLA5)
             OVRDBF     FILE(ALBWPB5) TOFILE(&WLIB/&FLB5)
             OVRDBF     FILE(ALBWPH5) TOFILE(&WLIB/&FLH5)
             OVRDBF     FILE(ALBWPI5) TOFILE(&WLIB/&FLI5)
             OVRDBF     FILE(ALBWPJ5) TOFILE(&WLIB/&FLJ5)
             OVRDBF     FILE(OUTPUT)  TOFILE(&WLIB/&FILE)
             OVRDBF     FILE(OAEWP01) TOFILE(&WLIB/&FLO)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) OVRFLW(60) +
                          OUTQ(TOPICS) FORMTYPE(K6H1) HOLD(*YES) +
                          IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINT2) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

             STRCMTCTL  LCKLVL(*ALL) NFYOBJ(*NONE)
             CALL       PGM(AAVR01) PARM(&USER &PM &PKYM)
             ENDCMTCTL
             MONMSG     MSGID(CPF8356)
             DLTOVR     FILE(*ALL)

 STPA:       CHKOBJ     OBJ(ALBCHK) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPB))

             DLYJOB     DLY(10)
             GOTO       STPA

 STPB:       CRTDTAARA  DTAARA(&WLIB/ALBCHK) TYPE(*CHAR) LEN(10) +
                          TEXT('TOPICS RECIEVE M/F DATA CREATE +
                          CHECK') AUT(*ALL)
             MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(STPA))

 STPC:       CHKOBJ     OBJ(OAECHK1) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPD))

             DLYJOB     DLY(10)
             GOTO       STPC

 STPD:       CRTDTAARA  DTAARA(&WLIB/OAECHK1) TYPE(*CHAR) LEN(10) +
                          TEXT('ARRS INT CO.INFORMATION UPDATE DATA +
                          CREATE CHECK') AUT(*ALL)
             MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(STPC))


             CHKOBJ     OBJ(ALBWPA5) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/ALBWPA5) RCDLEN(130) +
                          TEXT('TOPICS RECIEVE KANBAN M/F') +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CHKOBJ     OBJ(ALBWPB5) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/ALBWPB5) RCDLEN(130) +
                          TEXT('TOPICS RECIEVE CHECK M/F') +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CHKOBJ     OBJ(ALBWPH5) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/ALBWPH5) RCDLEN(130) +
                          TEXT('TOPICS RECIEVE CHECK M/F') +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CHKOBJ     OBJ(ALBWPI5) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/ALBWPI5) RCDLEN(130) +
                          TEXT('TOPICS RECIEVE CHECK M/F') +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CHKOBJ     OBJ(ALBWPJ5) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/ALBWPJ5) RCDLEN(130) +
                          TEXT('TOPICS RECIEVE CHECK M/F') +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CHKOBJ     OBJ(OAEWP01) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/OAEWP01) RCDLEN(51) +
                          TEXT('ARRS INTRAL COMPANY INFORMATION +
                          DATA') OPTION(*NOSRC *NOLIST) SIZE(10000 +
                          1000 3) LVLCHK(*NO) AUT(*ALL))

             CPYF       FROMFILE(&WLIB/&FLA5) TOFILE(ALBWPA5) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(&WLIB/&FLB5) TOFILE(ALBWPB5) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(&WLIB/&FLH5) TOFILE(ALBWPH5) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(&WLIB/&FLI5) TOFILE(ALBWPI5) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(&WLIB/&FLJ5) TOFILE(ALBWPJ5) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(&WLIB/&FILE) TOFILE(AIANP04) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(&WLIB/&FLO)  TOFILE(OAEWP01) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             DLTF       FILE(&WLIB/&FLA5)
             DLTF       FILE(&WLIB/&FLB5)
             DLTF       FILE(&WLIB/&FLH5)
             DLTF       FILE(&WLIB/&FLI5)
             DLTF       FILE(&WLIB/&FLJ5)
             DLTF       FILE(&WLIB/&FLO)
             DLTF       FILE(&WLIB/&FILE)

             DLTDTAARA  DTAARA(&WLIB/ALBCHK)
             MONMSG     MSGID(CPF2105)

             DLTDTAARA  DTAARA(&WLIB/OAECHK1)
             MONMSG     MSGID(CPF2105)

 STP4:
       /*JW1 DLTDTAARA  DTAARA(&WLIB/AAVACT)            */
             CALL CHKC45 ('AAVACT' 'AAVCP1' 'N'  '' '')

 END:        ENDPGM

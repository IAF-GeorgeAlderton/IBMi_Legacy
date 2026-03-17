             PGM        PARM(&PFILE &PLIBR)
             /** AJBC73 ******************************************/
             /*  ..AS/400 IAF ATC<-->AOYAMA DATABASE TRANSFER..  */
             /*  ..SRCMBR.SRCFILE.LIBRARY                        */
             /*      I-HASADA                    2001.04.23      */
             /****************************************** AJBC73 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSYT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PSYN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PUSR) TYPE(*CHAR) LEN(3)
             RTVJOBA    USER(&USER)
             RTVNETA    SYSNAME(&PSYN)

             IF         COND((&PSYN *EQ 'IAFAYM  ') *AND (&USER *EQ +
                          'IAF       ')) THEN(DO)
             CHGVAR     VAR(&PSYT) VALUE('SYSTEM1')
             CHGVAR     VAR(&PSYS) VALUE('ASJ')
             CHGVAR     VAR(&PUSR) VALUE('IAF')
             ENDDO

             IF         COND((&PSYN *EQ 'IAFAYM  ') *AND (&USER *EQ +
                          'ATC       ')) THEN(DO)
             CHGVAR     VAR(&PSYT) VALUE('SYSTEM1')
             CHGVAR     VAR(&PSYS) VALUE('ASJ')
             CHGVAR     VAR(&PUSR) VALUE('ATC')
             ENDDO

             IF         (&PSYN *EQ 'IAF     ') DO
             CHGVAR     VAR(&PSYT) VALUE('SYSTEM1')
             CHGVAR     VAR(&PSYS) VALUE('IAF')
             CHGVAR     VAR(&PUSR) VALUE('IAF')
             ENDDO

             IF         (&PSYN *EQ 'ATC     ') DO
             CHGVAR     VAR(&PSYT) VALUE('SYSTEM1')
             CHGVAR     VAR(&PSYS) VALUE('ATC')
             CHGVAR     VAR(&PUSR) VALUE('ATC')
             ENDDO

             DLTF       FILE(APSAVLIB/&PFILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(APSAVLIB/&PFILE) AUT(*ALL)

             SAVOBJ     OBJ(&PFILE) LIB(&PLIBR) DEV(*SAVF) +
                          OBJTYPE(*ALL) SAVF(APSAVLIB/&PFILE) +
                          TGTRLS(V7R3M0) SAVACT(*SYSDFN) DTACPR(*YES)

             /*---------------*/
             /*  ..SNDNETF..  */
             /*---------------*/
             SNDNETF    FILE(APSAVLIB/&PFILE) TOUSRID((TFILE &PSYT))

             DLTF       FILE(APSAVLIB/&PFILE)
             MONMSG     MSGID(CPF3261 CPF2105)

             /*-----------------*/
             /*  ..SBMNETJOB..  */
             /*-----------------*/
             IF         COND((&PSYN *EQ 'IAFAYM  ') *AND (&USER *EQ +
                          'IAF       ')) THEN(DO)

             DLTF       FILE(IKOULIB/AJBT64)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HSRC1/ACLSRC) +
                          TOFILE(IKOULIB/AJBT64) FROMMBR(AJBT64) +
                          CRTFILE(*YES)

             OVRDBF     FILE(INPUT) TOFILE(IKOULIB/AJBT64)
             CALL       PGM(AJBR63) PARM(&PFILE &PLIBR)
             DLTOVR     FILE(*ALL)

             SBMNETJOB  FILE(IKOULIB/AJBT64) TOUSRID((QFILE &PSYT))

             DLTF       FILE(IKOULIB/AJBT64)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDDO

             IF         COND((&PSYN *EQ 'IAFAYM  ') *AND (&USER *EQ +
                          'ATC       ')) THEN(DO)

             DLTF       FILE(IKOULIB/AJBT65)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HSRC1/ACLSRC) +
                          TOFILE(IKOULIB/AJBT65) FROMMBR(AJBT65) +
                          CRTFILE(*YES)

             OVRDBF     FILE(INPUT) TOFILE(IKOULIB/AJBT65)
             CALL       PGM(AJBR63) PARM(&PFILE &PLIBR)
             DLTOVR     FILE(*ALL)

             SBMNETJOB  FILE(IKOULIB/AJBT65) TOUSRID((QFILE &PSYT))

             DLTF       FILE(IKOULIB/AJBT65)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDDO

             IF         (&PSYN *EQ 'IAF     ') DO

             DLTF       FILE(IKOULIB/AJBT66)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HSRC1/ACLSRC) +
                          TOFILE(IKOULIB/AJBT66) FROMMBR(AJBT66) +
                          CRTFILE(*YES)

             OVRDBF     FILE(INPUT) TOFILE(IKOULIB/AJBT66)
             CALL       PGM(AJBR63) PARM(&PFILE &PLIBR)
             DLTOVR     FILE(*ALL)

             SBMNETJOB  FILE(IKOULIB/AJBT66) TOUSRID((QFILE &PSYT))

             DLTF       FILE(IKOULIB/AJBT66)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDDO

             IF         (&PSYN *EQ 'ATC     ') DO

             DLTF       FILE(IKOULIB/AJBT67)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HSRC1/ACLSRC) +
                          TOFILE(IKOULIB/AJBT67) FROMMBR(AJBT67) +
                          CRTFILE(*YES)

             OVRDBF     FILE(INPUT) TOFILE(IKOULIB/AJBT67)
             CALL       PGM(AJBR63) PARM(&PFILE &PLIBR)
             DLTOVR     FILE(*ALL)

             SBMNETJOB  FILE(IKOULIB/AJBT67) TOUSRID((QFILE &PSYT))

             DLTF       FILE(IKOULIB/AJBT67)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDDO

             ENDPGM

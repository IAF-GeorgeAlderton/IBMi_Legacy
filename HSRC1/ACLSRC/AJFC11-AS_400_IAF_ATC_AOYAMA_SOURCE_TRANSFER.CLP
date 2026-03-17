             PGM        PARM(&PPGM &PSRC)
             /** AJFC11 ****************************************/
             /*  ..AS/400 IAF ATC<-->AOYAMA SOURCE TRANSFER..  */
             /*    I-HASADA                        97.09.19    */
             /**************************************** AJFC11 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPGM) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PSRC) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PUSR) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PSYT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PSYN) TYPE(*CHAR) LEN(8)
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

             DLTF       FILE(IKOULIB/&PPGM)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSRCPF   FILE(IKOULIB/&PPGM) IGCDTA(*YES) +
                          SIZE(*NOMAX) CCSID(5026) AUT(*ALL)

             CPYSRCF    FROMFILE(HSRC1/&PSRC) TOFILE(IKOULIB/&PPGM) +
                          FROMMBR(&PPGM) TOMBR(&PPGM)

             MONMSG     MSGID(CPF2817 CPF2105 CPF2868) EXEC(DO)
             DLTF       FILE(IKOULIB/&PPGM)
             MONMSG     MSGID(CPF3261 CPF2105)
             GOTO       END
             ENDDO

             DLTF       FILE(APSAVLIB/&PPGM)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(APSAVLIB/&PPGM) AUT(*ALL)

             SAVOBJ     OBJ(&PPGM) LIB(IKOULIB) DEV(*SAVF) +
                          OBJTYPE(*FILE) SAVF(APSAVLIB/&PPGM) +
                          DTACPR(*YES)

             /*---------------*/
             /*  ..SNDNETF..  */
             /*---------------*/
             SNDNETF    FILE(APSAVLIB/&PPGM) TOUSRID((TFILE &PSYT))

             DLTF       FILE(IKOULIB/&PPGM)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(APSAVLIB/&PPGM)
             MONMSG     MSGID(CPF3261 CPF2105)

             /*-----------------*/
             /*  ..SBMNETJOB..  */
             /*-----------------*/
             IF         COND((&PSYN *EQ 'IAFAYM  ') *AND (&USER *EQ +
                          'IAF       ')) THEN(DO)
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QSRC &PSYT)) +
                          MBR(AJBT60)
             ENDDO

             IF         COND((&PSYN *EQ 'IAFAYM  ') *AND (&USER *EQ +
                          'ATC       ')) THEN(DO)
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QSRC &PSYT)) +
                          MBR(AJBT61)
             ENDDO

             IF         (&PSYN *EQ 'IAF     ') DO
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QSRC &PSYT)) +
                          MBR(AJBT62)
             ENDDO

             IF         (&PSYN *EQ 'ATC     ') DO
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QSRC &PSYT)) +
                          MBR(AJBT63)
             ENDDO

 END:        ENDPGM

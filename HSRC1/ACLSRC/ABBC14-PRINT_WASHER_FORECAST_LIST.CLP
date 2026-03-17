             PGM
             /** ABBC14 ********************/
             /* WASHER FORECAST LIST PRINT */
             /*  I-HASADA      2000.06.29  */
             /******************** ABBC14 **/
             DCLF       FILE(ABBPW14)
             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR5) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM3) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM4) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM5) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SYSNAME) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PYMD) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&SYSNAME)
             CHGVAR     VAR(&USR5) VALUE(%SST(&USER 1 5))

             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             CHGVAR     VAR(&PYM) VALUE(%SST(&ABBDS3 1 6))
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&PYMD)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ABBPW141)

             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN05 *EQ '0') GOTO STP1

             DLTF       FILE(ABBWP131)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP131) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(ABBWP132)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP132) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(ABBWP133)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP133) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(ABBR13) PARM(&PYM &PYM1 &PYM2 &PYM3 +
                          &PYM4 &PYM5 &PYM6)

             DLTF       FILE(ABBWP14)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP14) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ABBWP131)) +
                          OUTFILE(&WLIB/ABBWP14) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS14) OPTION(*NOPRT)
             DLTF       FILE(ABBWP131)

             IF         COND(&USR5 *EQ 'A0018' *OR &USR5 *EQ 'A5009' +
                          *OR &USR5 *EQ 'A5010' *OR &USR5 *EQ +
                          'A5011' *OR &USR5 *EQ 'A5012' *OR &USR5 +
                          *EQ 'A5013') THEN(DO)
             GOTO       CMDLBL(STP2)
             ENDDO

             IF         COND((&USR5 *EQ 'B1005') *OR (&USR5 *EQ +
                          'A2065')) THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(TPRINT) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             ENDDO
             ELSE       DO
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(QPRINTB) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             ENDDO

             CLRPFM     FILE(ABBWP19)

             CALL       PGM(ABBR14) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6)
             DLTOVR     FILE(QPRINT)
 STP2:
 /*2004.10.14*/
             IF         COND(&USR5 *EQ 'A0018' *OR &USR5 *EQ 'A5009' +
                          *OR &USR5 *EQ 'A5010' *OR &USR5 *EQ +
                          'A5011' *OR &USR5 *EQ 'A5012' *OR &USR5 +
                          *EQ 'A5013') THEN(DO)
             DLTF       FILE(ABBWP2B)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP2B) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             CALL       PGM(ABBR2B) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6 &SYSNAME &PYMD)
             SNDNETF    FILE(&WLIB/ABBWP2B) TOUSRID((QFILE +
                          SYSTEM1))
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE SYSTEM1)) +
                          MBR(ABBT2B)
             ENDDO
 /*2004.10.14*/
 /** TEMP    DLTF       FILE(ABBWP14) **/

             DLTF       FILE(ABBWP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP20) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ABBWP132)) +
                          OUTFILE(&WLIB/ABBWP20) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS20) OPTION(*NOPRT)
    /*TEMP   DLTF       FILE(ABBWP132)                        **/

             IF         COND(&USR5 *EQ 'A0018' *OR &USR5 *EQ 'A5009' +
                          *OR &USR5 *EQ 'A5010' *OR &USR5 *EQ +
                          'A5011' *OR &USR5 *EQ 'A5012' *OR &USR5 +
                          *EQ 'A5013') THEN(DO)
             GOTO       CMDLBL(STP3)
             ENDDO

             IF         COND((&USR5 *EQ 'B1005') *OR (&USR5 *EQ +
                          'A2065')) THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(TPRINT) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             ENDDO
             ELSE       DO
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(QPRINTB) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)

             ENDDO

             CLRPFM     FILE(ABBWP17)
             CALL       PGM(ABBR20) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6)
             DLTOVR     FILE(QPRINT)

             DLTF       FILE(ABBWP28)
             CRTPF      FILE(HFILE1/ABBWP28) RCDLEN(1500) +
                          OPTION(*NOLIST) SIZE(15000 2000) +
                          LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(ABBR28) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6)
 STP3:
 /*2004.10.09*/
             IF         COND(&USR5 *EQ 'A0018' *OR &USR5 *EQ 'A5009' +
                          *OR &USR5 *EQ 'A5010' *OR &USR5 *EQ +
                          'A5011' *OR &USR5 *EQ 'A5012' *OR &USR5 +
                          *EQ 'A5013') THEN(DO)
             DLTF       FILE(ABBWP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP2A) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             CALL       PGM(ABBR2A) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6 &SYSNAME &PYMD)
             SNDNETF    FILE(&WLIB/ABBWP2A) TOUSRID((QFILE +
                          SYSTEM1))
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE +
                          SYSTEM1)) MBR(ABBT2A)
             ENDDO
 /*2004.10.09*/
     /*TEMP  DLTF       FILE(ABBWP20)       **/

             DLTF       FILE(ABBWP1A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP1A) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ABBWP133)) +
                          OUTFILE(&WLIB/ABBWP1A) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS14) OPTION(*NOPRT)
             DLTF       FILE(ABBWP133)

             IF         COND(&USR5 *EQ 'B1005' *OR &USR5 *EQ 'A4039' +
                          *OR &USR5 *EQ 'A5011' *OR &USR5 *EQ +
                          'A5012' *OR &USR5 *EQ 'A5009' *OR &USR5 +
                          *EQ 'A2065') THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(TPRINT) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             ENDDO
             ELSE       DO
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(QPRINTB) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)

             ENDDO

             CALL       PGM(ABBR1A) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6)
             DLTOVR     FILE(QPRINT)

             /*------------------*/
             /*  ..SNDNETSPLF..  */
             /*------------------*/
             IF         COND((&USR5 *EQ 'B1005') *OR (&USR5 *EQ +
                          'A2065')) THEN(DO)
             CALL       PGM(AGGC01)
             ENDDO

 END:        ENDPGM

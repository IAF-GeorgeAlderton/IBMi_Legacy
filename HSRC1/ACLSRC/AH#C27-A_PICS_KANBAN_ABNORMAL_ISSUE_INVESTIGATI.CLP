             PGM
             /** AH#C27 ********************************/
             /*  A-PICSかんばん異常発行調査リスト..  */
             /*         (調査ﾒﾇn発行ﾎﾟﾜhﾞ[w )      */
             /*       A.INOUE           96.09.12       */
             /******************************** AH#C27 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL5) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL6) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL7) TYPE(*CHAR) LEN(9)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WS) USER(&USER)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             CHGJOB     RUNPTY(40) SWS(00000000)

          /* CALL       PGM(KZZR00) PARM(&WS &PRT &TYPE &PRTG) */
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 STP1:       CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&WSID) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FIL1) VALUE(AH#WP30 *CAT &WSID)
             CHGVAR     VAR(&FIL2) VALUE(AH#WP32 *CAT &WSID)
             CHGVAR     VAR(&FIL3) VALUE(AH#WP33 *CAT &WSID)
             CHGVAR     VAR(&FIL4) VALUE(AH#WP3A *CAT &WSID)
             CHGVAR     VAR(&FIL5) VALUE(AH#WP34 *CAT &WSID)
             CHGVAR     VAR(&FIL6) VALUE(AH#WP3B *CAT &WSID)
             CHGVAR     VAR(&FIL7) VALUE(AH#WP36 *CAT &WSID)

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP30) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000 3) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRDBF     FILE(AH#WP30) TOFILE(&FIL1)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(AH#R27) PARM(&USER)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FIL1)
             DLTOVR     FILE(*ALL)
             GOTO       END
             ENDDO


             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL2) RCDLEN(134) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL3) RCDLEN(134) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL4) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP3A) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL5) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP34) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL6) RCDLEN(162) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL7)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL7) RCDLEN(162) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AH#R35)

             DLTF       FILE(&FIL1)
             DLTF       FILE(&FIL2)
             DLTF       FILE(&FIL3)
             DLTF       FILE(&FIL4)
             DLTF       FILE(&FIL5)
             DLTF       FILE(&FIL6)
             DLTF       FILE(&FIL7)
             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM

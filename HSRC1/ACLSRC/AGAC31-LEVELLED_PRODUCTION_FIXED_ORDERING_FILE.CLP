             PGM
             /** AGAC31 ************************************/
             /* LEVELLED PRODUCTION FIXED ORDERING FILE UPDATE CL */
             /* A-PICS PRODUCTION INSTRUCTION ADD-DATA LIST */
             /* 92,7.28                    Y.TANOUE        */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSNO 1 2))

             CHGVAR     VAR(&FIL1) VALUE(AGAWP36A *CAT &WS)
             CHGVAR     VAR(&FIL2) VALUE(AGAWP36B *CAT &WS)

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL1) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(6000 3000 3) +
                          LVLCHK(*NO)

             OVRDBF     FILE(AGAWP36A) TOFILE(&FIL1)
             CALL       PGM(AGAR31) PARM(&USER)
             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             DLTF       FILE(&FIL1)
             GOTO       CMDLBL(END)
             ENDDO

             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL2) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(6000 3000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((&WLIB/&FIL1)) OUTFILE(&WLIB/&FIL2) +
                          SRCFILE(FMTSRC) SRCMBR(AGAS36) OPTION(*NOPRT)
        /*   DLTF       FILE(&FIL1)  */

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

             OVRDBF     FILE(AGAWP36B) TOFILE(&FIL2)
             CALL       PGM(AGAR36) PARM(&USER)
        /*   DLTF       FILE(&FIL2)  */
        /*   DLTOVR     FILE(*ALL)  */

 END:        ENDPGM

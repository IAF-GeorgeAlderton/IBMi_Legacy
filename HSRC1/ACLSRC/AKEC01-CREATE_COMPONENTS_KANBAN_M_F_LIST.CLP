             PGM
             /** AKEC01 ************************************/
             /* CREATE COMPONENTS KANBAN M/F LIST */
             /* I-HASADA                    93.07.26       */
             /************************************ AKEC01 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL5) TYPE(*CHAR) LEN(9)

             CHGJOB     RUNPTY(40) SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&US)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&FIL1) VALUE('AKEWP01' *CAT &WS)
             CHGVAR     VAR(&FIL2) VALUE('AKEWP02' *CAT &WS)
             CHGVAR     VAR(&FIL3) VALUE('AKEWP03' *CAT &WS)
             CHGVAR     VAR(&FIL4) VALUE('AKEWP04' *CAT &WS)
             CHGVAR     VAR(&FIL5) VALUE('AKEWP05' *CAT &WS)

             DLTF       FILE(HWFILE1/&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 5000 3) +
                          LVLCHK(*NO)

             OVRDBF     FILE(AKEWP01) TOFILE(&FIL1)
             CALL       PGM(AKER01)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(HWFILE1/&FIL1)
             DLTOVR     FILE(*ALL)
             GOTO       END
             ENDDO

             DLTF       FILE(HWFILE1/&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 5000 3) +
                          LVLCHK(*NO)

             OVRDBF     FILE(AKEWP02) TOFILE(&FIL2)
             CALL       PGM(AKER02)
             DLTF       FILE(HWFILE1/&FIL1)

             IF         (%SWITCH(X0XXXXXX)) DO
             DLTF       FILE(HWFILE1/&FIL2)
             DLTOVR     FILE(*ALL)
             GOTO       END
             ENDDO

             DLTF       FILE(HWFILE1/&FIL4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL4) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 5000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FIL2)) +
                          OUTFILE(HWFILE1/&FIL4) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AKES04) +
                          OPTION(*NOPRT)
             DLTF       FILE(HWFILE1/&FIL2)

             DLTF       FILE(HWFILE1/&FIL5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL5) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 5000 3) +
                          LVLCHK(*NO)

             OVRDBF     FILE(AKEWP04) TOFILE(&FIL4)
             OVRDBF     FILE(AKEWP05) TOFILE(&FIL5)
             CALL       PGM(AKER04)
             DLTF       FILE(HWFILE1/&FIL4)

             DLTF       FILE(HWFILE1/&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL3) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AKEWP03) OPTION(*NOLIST *NOSRC) +
                          SIZE(30000 5000 3) LVLCHK(*NO)

             OVRDBF     FILE(AKEWP03) TOFILE(&FIL3)
             CALL       PGM(AKER05)
             DLTF       FILE(HWFILE1/&FIL5)

             OVRPRTF    FILE(AKEPR03) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) FORMTYPE(@627)
             CALL       PGM(AKER03) PARM(&US)
             DLTF       FILE(HWFILE1/&FIL3)
             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM

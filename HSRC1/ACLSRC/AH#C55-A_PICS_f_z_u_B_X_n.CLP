             PGM
             /** AH#C55 ********************************/
             /*  A-PICSかんばん異常発行予定リスト..  */
             /*                                        */
             /*       MSK.KUNIEDA       98.07.09       */
             /******************************** AH#C55 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PHAZ) TYPE(*CHAR) LEN(8) VALUE('        ')
             DCL        VAR(&PTYP) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PKEI) TYPE(*CHAR) LEN(4) VALUE('    ')

             RTVJOBA    JOB(&WS) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&WSID) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FIL1) VALUE(AH#WP55 *CAT &WSID)
             CHGVAR     VAR(&FIL2) VALUE(AH#WP56 *CAT &WSID)

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL1) RCDLEN(170) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL2) RCDLEN(170) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AH#WP55) TOFILE(&FIL1)

             CALL       PGM(AH#R55) PARM(&PHAZ &PTYP &PKEI)

             FMTDTA     INFILE((HWFILE1/&FIL1)) +
                          OUTFILE(HWFILE1/&FIL2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S56) +
                          OPTION(*NOPRT)

             OVRDBF     FILE(AH#WP56) TOFILE(&FIL2)
             OVRPRTF    FILE(AH#PR56) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)

             CALL       PGM(AH#R56) PARM(&PHAZ &PTYP &PKEI &USER)

             DLTF       FILE(&FIL1)
             DLTF       FILE(&FIL2)
             DLTOVR     FILE(*ALL)

             ENDPGM

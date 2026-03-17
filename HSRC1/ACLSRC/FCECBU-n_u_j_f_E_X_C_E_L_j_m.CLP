             PGM
             /** FCECBU **********************************/
             /*   部品マスターからＥＸＣＥＬデータ作成 */
             /*                                          */
             /*     CODING:T.SAKASHITA       2004.09.22  */
             /********************************** FCECBU **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTOKU) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TOKULEN) TYPE(*DEC) LEN(5 0)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             CHGJOB     OUTQ(&PRTG)

             DLTF       FILE(HWFILE1/FCEWPBU1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/FCEWPBU1) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(50000 5000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT) TOFILE(HWFILE1/FCEWPBU1)
             CALL       PGM(FCERZ2)
             DLTOVR     FILE(*ALL)

             DLTF       FILE(HWFILE1/FCEWPBU)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/FCEWPBU) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(50000 5000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(INPUT) TOFILE(HWFILE1/FCEWPBU1)
             OVRDBF     FILE(OUTPUT) TOFILE(HWFILE1/FCEWPBU)
             CALL       PGM(FCEROK)
             DLTOVR     FILE(*ALL)

             DLTF       FILE(HWFILE1/FCEWPBU1)
             MONMSG     MSGID(CPF3261 CPF2105)

@END:
             ENDPGM

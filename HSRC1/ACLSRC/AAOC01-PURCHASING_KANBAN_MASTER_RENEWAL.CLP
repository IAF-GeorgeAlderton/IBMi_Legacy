             PGM
             /** AAOC01 ************************************/
             /* PURCHASING KANBAN MASTER RENEWAL           */
             /*                H.ITO       86.10.03        */
             /************************************ AAOC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     OUTQ(&PRTG)

             OVRDBF     FILE(AAJTL14) SHARE(*YES)
             OPNDBF     FILE(AAJTL14) OPTION(*ALL) OPNID(A01) +
                          TYPE(*PERM)
             MONMSG     MSGID(CPA0701 CPF4174)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE('AAP' *CAT &WS)
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(300) +
                          TEXT('A-PICSf]ﾈbﾍ]f]ﾌﾞ] ﾃcﾆ]uﾇjｰ mﾞｰj') +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)
             OVRDBF     FILE(OUTPUT) TOFILE(&FILE1)
             CALL       PGM(AAOR01) PARM(&USER &FILE1)
             CLOF       OPNID(A01)

             ENDPGM

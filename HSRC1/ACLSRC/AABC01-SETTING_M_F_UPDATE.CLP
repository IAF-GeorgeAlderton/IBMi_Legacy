             PGM
             /** AABC01 ****************************************/
             /* SETTING M/F UPDATE                       */
             /*          I-HASADA            86.06.03          */
             /**************************************** AABC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSYS) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&WSYS)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE) VALUE('AABNP01' *CAT &WT)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)
             CHGJOB     SWS(00000000)

 STP1:
             OVRDBF     FILE(AABNP01) TOFILE(&FILE)
             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AABNP01) OPTION(*NOSRC *NOLIST) +
                          SIZE(1000 1000 3) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AABR01) PARM(&USER)


 END:        DLTOVR     FILE(AABNP01)
             DLTF       FILE(&FILE)
             ENDPGM

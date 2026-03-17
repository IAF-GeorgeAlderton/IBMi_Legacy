             PGM
             /** AXXC14 ********************/
             /* WASHER FORECAST LIST PRINT */
             /*  I-HASADA      2000.06.29  */
             /******************** AXXC14 **/
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

             DLTF       FILE(AXXWP131)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AXXWP131) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(AXXWP132)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AXXWP132) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(AXXWP133)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AXXWP133) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(AXXR13) PARM(&PYM &PYM1 &PYM2 &PYM3 +
                          &PYM4 &PYM5 &PYM6)

             DLTF       FILE(AXXWP14)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AXXWP14) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AXXWP131)) +
                          OUTFILE(&WLIB/AXXWP14) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS14) OPTION(*NOPRT)
             DLTF       FILE(AXXWP131)

             CLRPFM     FILE(AXXWP19)

             CALL       PGM(AXXR14) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6)

 END:        ENDPGM

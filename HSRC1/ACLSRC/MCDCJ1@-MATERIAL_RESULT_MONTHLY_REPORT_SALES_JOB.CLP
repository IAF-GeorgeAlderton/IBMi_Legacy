             PGM        PARM(&HIZU &PRTG &PDEVT &PIGCD)
             /*****************************************************/
             /* MATERIAL RESULT MONTHLY REPORT SALES JOBQ */
             /*            M-OKUDA        1981.09.03              */
             /*            N-HYOTO        2001.03.06              */
             /*****************************************************/
             DCL        VAR(&HIZU) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&US)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             DLTF       FILE(&WLIB/MCDWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MCDWP11) RCDLEN(150) +
                          TEXT('MATERIAL TOTALIZATION FILE') +
                          OPTION(*NOLIST) SIZE(60000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MCDWP11) TOFILE(&WLIB/MCDWP11)

             CALL       PGM(MCDR11)

             DLTF       FILE(&WLIB/MCDWP12)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MCDWP12) RCDLEN(150) +
                          TEXT('MATERIAL TOTALIZATION WORK2') +
                          OPTION(*NOLIST) SIZE(60000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/MCDWP11)) +
                          OUTFILE(&WLIB/MCDWP12) SRCFILE(FMTSRC) +
                          SRCMBR(MCDS15) OPTION(*NOPRT)
             DLTF       FILE(&WLIB/MCDWP11)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINT3) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINT2) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(SAVEOUTQ) +
                          FORMTYPE(K6S1) COPIES(1) IGCDTA(&PIGCD)

             DLTF       FILE(&WLIB/MCDWP12X)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MCDWP12X) RCDLEN(98) +
                          OPTION(*NOLIST) SIZE(60000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MCDWP12) TOFILE(&WLIB/MCDWP12)
             OVRDBF     FILE(MCDWP12X) TOFILE(&WLIB/MCDWP12X)

             CALL       PGM(MCDR12) PARM(&HIZU)
             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(QPRINT2)

             ENDPGM

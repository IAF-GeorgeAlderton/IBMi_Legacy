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

             DLTF       FILE(MCDWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MCDWP11) RCDLEN(150) +
                          TEXT('MATERIAL TOTALIZATION FILE') +
                          OPTION(*NOLIST) SIZE(60000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(MCDR11)

             DLTF       FILE(MCDWP12)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MCDWP12) RCDLEN(150) +
                          TEXT('MATERIAL TOTALIZATION WORK2') +
                          OPTION(*NOLIST) SIZE(60000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/MCDWP11)) +
                          OUTFILE(&WLIB/MCDWP12) SRCFILE(FMTSRC) +
                          SRCMBR(MCDS15) OPTION(*NOPRT)
             DLTF       FILE(MCDWP11)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES) SAVE(*YES) IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINT3) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES) SAVE(*YES) IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINT2) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(SAVEOUTQ) +
                          FORMTYPE(K6S1) COPIES(1) IGCDTA(&PIGCD)

             DLTF       FILE(MCDWP12X)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MCDWP12X) RCDLEN(98) +
                          OPTION(*NOLIST) SIZE(60000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(MCDR12) PARM(&HIZU)
             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(QPRINT2)

             DLTF       FILE(MCDWP14)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MCDWP14) RCDLEN(150) +
                          TEXT('MATERIAL TOTALIZATION WORK2') +
                          OPTION(*NOLIST) SIZE(60000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/MCDWP12)) +
                          OUTFILE(&WLIB/MCDWP14) SRCFILE(FMTSRC) +
                          SRCMBR(MCDS14) OPTION(*NOPRT)
             DLTF       FILE(MCDWP12)

             CLRPFM     FILE(MCDNP12)
             CALL       PGM(MCDR14) PARM(&HIZU)

             CLRPFM     FILE(GKBNP21)
             CALL       PGM(MCDR17) PARM(&HIZU)

             DLTF       FILE(MCDWP14)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM

             PGM      PARM(&HIZU &PRTG &PDEVT &PIGCD)
             /***MCECJ1********************************************/
             /*COMPONENTS TOTALIZATION FOR MONTHLY JOBQ OP-EDP */
             /*            M-OKUDA        1981.10.10              */
             /*            N-HYOTO        2001.04.05              */
             /* TCHK1 12/03/10 CHG OVRPRTF                        */
             /*****************************************************/
             DCL      VAR(&HIZU) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&US)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CRTPF      FILE(&WLIB/MCEWP11) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(20000 3000)
             CALL       PGM(MCER11)

             CRTPF      FILE(&WLIB/MCEWP12) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(20000 3000)
             FMTDTA     INFILE((&WLIB/MCEWP11)) +
                          OUTFILE(&WLIB/MCEWP12) SRCFILE(FMTSRC) +
                          SRCMBR(MCES15) OPTION(*NOPRT)

             CLRPFM     FILE(MCENP13)

/* TCHK1     OVRPRTF    FILE(QPRINT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES ' ') +
                          ALIGN(*NO) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          FILESEP(1) IGCDTA(&PIGCD) */

/* TCHK1     OVRPRTF    FILE(QPRINT2) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES ' ') +
                          ALIGN(*NO) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          FILESEP(1) IGCDTA(&PIGCD) */

/* TCHK1 */  OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) +
                          LPI(6) OVRFLW(60) RPLUNPRT(*YES ' ') +
                          OUTQ(QPRINT) FORMTYPE(K6H1)

/* TCHK1 */  OVRPRTF    FILE(QPRINT2) PAGESIZE(66 132) +
                          LPI(6) OVRFLW(60) RPLUNPRT(*YES ' ') +
                          OUTQ(QPRINT) FORMTYPE(K6H1)

             CALL       PGM(MCER12) PARM(&HIZU)
             DLTF       FILE(MCEWP11)
             DLTF       FILE(MCEWP12)
             DLTOVR     FILE(*ALL)

             ENDPGM

             PGM
             /**FCKC12*******************************/
             /* ARRIVAL M/F LIST BY  SUPPLIER .. */
             /*        I-HASADA 82.08.19            */
             /*******************************FCKC12**/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             DLTF       FILE(FCKWP12)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/FCKWP12) RCDLEN(80) +
                          OPTION(*NOLIST) SIZE(100 100 2) +
                          ALLOCATE(*YES) CONTIG(*YES) LVLCHK(*NO)

             CALL       PGM(FCKR12)

             DLTF       FILE(FCKWP13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/FCKWP13) RCDLEN(80) +
                          OPTION(*NOLIST) SIZE(100 100 2) +
                          ALLOCATE(*YES) CONTIG(*YES) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/FCKWP12)) +
                          OUTFILE(HWFILE1/FCKWP13) SRCFILE(FMTSRC) +
                          SRCMBR(FCKS12) OPTION(*NOPRT)
             DLTF       FILE(FCKWP12)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(FCKR13)
             DLTF       FILE(FCKWP13)
             DLTOVR     FILE(QPRINT)

             ENDPGM

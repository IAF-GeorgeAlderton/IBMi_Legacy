             PGM
             /** GCQC48 ************************************/
             /*  DIE KANBAN M/F LIST                       */
             /*  MSK.KUNIEDA                 98.06.29      */
             /**********************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&RPY)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SW1)    TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             /*-----------------------------------------------------*/
             CHGJOB     OUTQ(&PRTG)
             DLTF       FILE(HWFILE1/GCQWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GCQWP11) RCDLEN(116) +
                          OPTION(*NOLIST) SIZE(500000 2000 5) +
                          LVLCHK(*NO)

             DLTF       FILE(HWFILE1/GCQWP47)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GCQWP47) RCDLEN(116) +
                          OPTION(*NOLIST) SIZE(500000 2000 5) +
                          LVLCHK(*NO)

             CALL       PGM(GCQR47)

             FMTDTA     INFILE((HWFILE1/GCQWP47)) +
                          OUTFILE(HWFILE1/GCQWP11) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS48) +
                          OPTION(*NOPRT)

    /*       OVRPRTF    FILE(GCQPR48) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) OVRFLW(60) OUTQ(&PRTG) FORMTYPE(K6H1) */

             OVRPRTF    FILE(GCQPR48) PAGESIZE(66 132) OVRFLW(60) +
                          OUTQ(QPRINTD) FORMTYPE(K6H1)

             CALL       PGM(GCQR48) PARM(&USER)

             DLTOVR     FILE(*ALL)

 END:        CHGJOB     OUTQ(&PRT)

             DLTF       FILE(HWFILE1/GCQWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/GCQWP47)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM

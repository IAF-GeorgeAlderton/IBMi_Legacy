             PGM
             /** GCQC47 ************************************/
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
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1)  TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE2)  TYPE(*CHAR)  LEN(9)

             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSNO 1 2))
             CHGVAR     VAR(&FILE1) VALUE('GCQWP11' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('GCQWP47' *CAT &WS)

             /*-----------------------------------------------------*/
             CHGJOB     OUTQ(&PRTG)
             DLTF       FILE(HWFILE1/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(123) +
                          OPTION(*NOLIST) SIZE(500000 2000 5) +
                          LVLCHK(*NO)

             DLTF       FILE(HWFILE1/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(123) +
                          OPTION(*NOLIST) SIZE(500000 2000 5) +
                          LVLCHK(*NO)

             OVRDBF     FILE(GCQWP47) TOFILE(HWFILE1/&FILE2)
             CALL       PGM(GCQR47)

             FMTDTA     INFILE((HWFILE1/&FILE2)) +
                          OUTFILE(HWFILE1/&FILE1) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS47) +
                          OPTION(*NOPRT)

             OVRPRTF    FILE(GCQPR48) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) OVRFLW(60) OUTQ(QPRINTD) FORMTYPE(K6H1)

             OVRDBF     FILE(GCQWP11) TOFILE(HWFILE1/&FILE1)
             CALL       PGM(GCQR48) PARM(&USER)

             DLTOVR     FILE(*ALL)

 END:        CHGJOB     OUTQ(&PRT)

             DLTF       FILE(HWFILE1/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM

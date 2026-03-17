             PGM        PARM(&PKBN &PYM &HIZK &PCD &PCD1 &PCD2 &PCD3 +
                          &PCD4)
             /** ABEC01 **************************/
             /*   THE COMPONENTS KANBAN INCREASE AND DECREASE HANDLING   */
             /* I-HASADA            92.10.06     */
             /************************** ABEC01 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HIZK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD1) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD2) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD4) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PLIST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(ABEWP06)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABEWP06) RCDLEN(200) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ABER01)

             CALL       PGM(ABER02)

             CALL       PGM(ABER03)

             CALL       PGM(ABER04) PARM(&PKBN &PYM &HIZK &PCD &PCD1 +
                          &PCD2 &PCD3 &PCD4 &PLIST)

             IF         (&PLIST *EQ '*') DO

             DLTF       FILE(ABEWP07)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABEWP07) RCDLEN(200) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABEWP06)) +
                          OUTFILE(HWFILE1/ABEWP07) SRCFILE(FMTSRC) +
                          SRCMBR(ABES07) OPTION(*NOPRT)
             DLTF       FILE(ABEWP06)

             DLTF       FILE(ABEWP08)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABEWP08) RCDLEN(200) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ABER08)
             DLTF       FILE(ABEWP07)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) OVRFLW(58) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(ABER07) PARM(&PCD &PCD1 &PCD2 &PCD3 &PCD4)
             DLTOVR     FILE(QPRINT)

             ENDDO
             ELSE       DO

             DLTF       FILE(ABEWP06)
             ENDDO

             CLRPFM     FILE(ABEWP04)
             CLRPFM     FILE(ABEWP05)

             ENDPGM

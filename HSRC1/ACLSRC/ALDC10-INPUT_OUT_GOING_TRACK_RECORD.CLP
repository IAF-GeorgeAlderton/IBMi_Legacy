             PGM
             /** ALDC01 ************************************/
             /* INPUT OF OUT-GOING TRACK RECORD            */
             /*       CREATE DATE : JUN/26/1997.           */
             /*       AUTHOR      : S.OHTAKE.              */
             /**********************************************/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&IFLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&AFLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&KFLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)   USER(&US)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

             /**************************************/
             /*    CREATE OF WORKFILE              */
             /**************************************/

             DLTF       FILE(ALDWP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALDWP20) RCDLEN(200) +
                          TEXT('WORKFILE FOR IAF KANBAN') +
                          OPTION(*NOLIST) SIZE(50000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(ALDWP30)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALDWP30) RCDLEN(200) +
                          TEXT('WORKFILE FOR APICS KANBAN') +
                          OPTION(*NOLIST) SIZE(50000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(ALDWP40)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALDWP40) RCDLEN(200) +
                          TEXT('WORKFILE FOR KOUTEINAI KANBAN') +
                          OPTION(*NOLIST) SIZE(50000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ALDR10) PARM(&IFLG &AFLG &KFLG)

             IF         (&IFLG *EQ ' ')  GOTO STP1
             /**************************************/
             /*    IAF KANBAN ROUTINE              */
             /**************************************/
             CALL       PGM(ALDR20)

             CALL       PGM(ALDR21)

             DLTF       FILE(ALDWP21)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALDWP21) RCDLEN(200) +
                          TEXT('WORKFILE FOR IAF KANBAN ERROR +
                          DATA') OPTION(*NOLIST) SIZE(50000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ALDR22) PARM(&US &PRTFLG)

             IF         (&PRTFLG *EQ ' ') GOTO STP1

             OVRPRTF    FILE(ALDPR20) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

             CALL       PGM(ALDR23) PARM(&US)

 STP1:       IF         (&AFLG *EQ ' ') GOTO  STP2
             /**************************************/
             /*    APICS KANBAN ROUTINE            */
             /**************************************/
             CHGVAR     VAR(&PRTFLG) VALUE(' ')

             CALL       PGM(ALDR30)

             CALL       PGM(ALDR31)

             DLTF       FILE(ALDWP31)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALDWP31) RCDLEN(200) +
                          TEXT('WORKFILE FOR APICS KANBAN ERROR +
                          DATA') OPTION(*NOLIST) SIZE(50000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ALDR32) PARM(&US &PRTFLG)

             IF         (&PRTFLG *EQ ' ') GOTO STP2

             OVRPRTF    FILE(ALDPR30) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

             CALL       PGM(ALDR33) PARM(&US)

 STP2:       IF         (&KFLG *EQ ' ') GOTO  END
             /**************************************/
             /*    KOTEINAI KANBAN ROUTINE         */
             /**************************************/
             CHGVAR     VAR(&PRTFLG) VALUE(' ')

             CALL       PGM(ALDR40)

             CALL       PGM(ALDR41)

             DLTF       FILE(ALDWP41)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALDWP41) RCDLEN(200) +
                          TEXT('WORKFILE FOR KOUTEINAI KANBAN ERROR +
                          DATA') OPTION(*NOLIST) SIZE(50000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ALDR42) PARM(&US &PRTFLG)

             IF         (&PRTFLG *EQ ' ') GOTO END

             OVRPRTF    FILE(ALDPR40) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

             CALL       PGM(ALDR43) PARM(&US)

END:         DLTF       FILE(HWFILE1/ALDWP10BK)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALDWP10BK) RCDLEN(100) +
                          SIZE(50000 10000) AUT(*ALL)
             CPYF       FROMFILE(HWFILE1/ALDWP10) +
                          TOFILE(HWFILE1/ALDWP10BK) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             DLTF       FILE(ALDWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALDWP10) RCDLEN(100) TEXT('''') +
                          OPTION(*NOLIST) SIZE(50000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             ENDPGM

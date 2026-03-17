             PGM
             /** ALDC50 ************************************/
             /* LIST OF  OUT-GOING TRACK RECORD            */
             /*       CREATE DATE : NOV/26/1997.           */
             /*       AUTHOR      : S.OHTAKE.              */
             /**********************************************/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOJO)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&FLG)    TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)   USER(&US)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             /**************************************/
             /*    CREATE OF WORKFILE              */
             /**************************************/

             DLTF       FILE(ALDWP50)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALDWP50) RCDLEN(100) +
                          TEXT('WORKFILE') +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ALDR50) PARM(&NONY &KOJO &NUKE &FLG)

             IF         (&FLG  *EQ '*')  GOTO END

             DLTF       FILE(ALDWP51)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALDWP51) RCDLEN(200) +
                          TEXT('WORKFILE') OPTION(*NOLIST) +
                          SIZE(10000 3000) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ALDWP50)) +
                          OUTFILE(HWFILE1/ALDWP51) SRCFILE(FMTSRC) +
                          SRCMBR(ALDS50) OPTION(*NOPRT)
             DLTF       FILE(ALDWP50)

             OVRPRTF    FILE(ALDPR50) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

             CALL       PGM(ALDR51) PARM(&NONY &KOJO &NUKE &US)

       /*    DLTF       FILE(ALDWP51) */

 END:        ENDPGM

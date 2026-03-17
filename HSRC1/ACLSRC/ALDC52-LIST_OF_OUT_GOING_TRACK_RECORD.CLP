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
             DCL        VAR(&FLG)    TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)   USER(&US)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             /**************************************/
             /*    CREATE OF WORKFILE              */
             /**************************************/

             DLTF       FILE(QTEMP/ALDWP50)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ALDWP50) RCDLEN(100) +
                          TEXT('WORKFILE') +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ALDWP50) TOFILE(QTEMP/ALDWP50)
             CALL       PGM(ALDR52) PARM(&FLG)

             IF         (&FLG  *EQ '*')  GOTO END

             DLTF       FILE(QTEMP/ALDWP51)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ALDWP51) RCDLEN(200) +
                          TEXT('WORKFILE') OPTION(*NOLIST) +
                          SIZE(10000 3000) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((QTEMP/ALDWP50)) +
                          OUTFILE(QTEMP/ALDWP51) SRCFILE(FMTSRC) +
                          SRCMBR(ALDS50) OPTION(*NOPRT)
             DLTF       FILE(QTEMP/ALDWP50)

             OVRPRTF    FILE(ALDPR52) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

             OVRDBF     FILE(ALDWP51) TOFILE(QTEMP/ALDWP51)
             CALL       PGM(ALDR53) PARM(&US)

       /*    DLTF       FILE(ALDWP51) */

 END:        ENDPGM

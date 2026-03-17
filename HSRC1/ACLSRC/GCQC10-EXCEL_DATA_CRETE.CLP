             PGM
             /********************************************/
             /*     EXCEL DATA CRETE                     */
             /*      MSK               2005.04.02        */
             /********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             DLTF       FILE(HWFILE1/GCQWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GCQWP10) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(500000 2000 5) +
                          LVLCHK(*NO)

             CALL       PGM(GCQR10)

             ENDPGM

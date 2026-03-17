             PGM
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)    VALUE(QPRINT)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(HWFILE1/MEKWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MEKWP01) RCDLEN(15) +
                          TEXT('AJSPP01 ') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)

             CALL MEKR01

             OVRPRTF    FILE(MEKPR01) PAGESIZE(66) LPI(6) OVRFLW(35) +
                        RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(TEST)
             CALL       PGM(MEKR02)

             ENDPGM

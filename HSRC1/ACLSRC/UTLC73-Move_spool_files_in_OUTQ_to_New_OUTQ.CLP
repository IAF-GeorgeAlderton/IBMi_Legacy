             PGM        PARM(&OUTQ &NWOUTQ)

             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NWOUTQ) TYPE(*CHAR) LEN(10)

             DLTF       FILE(HWFILE1/SPLFILES)
             MONMSG     MSGID(CPF0000)

             WRKOUTQ    OUTQ(&OUTQ) OUTPUT(*PRINT)

             CRTPF      FILE(HWFILE1/SPLFILES) RCDLEN(132) +
                          SIZE(100000 10000 5)

             CPYSPLF    FILE(QPRTSPLQ) TOFILE(HWFILE1/SPLFILES) +
                          JOB(*) SPLNBR(*LAST) MBROPT(*ADD)

             CALL       PGM(RMVR73) PARM(&OUTQ &NWOUTQ)

             DLTF       FILE(HWFILE1/SPLFILES)

             ENDPGM

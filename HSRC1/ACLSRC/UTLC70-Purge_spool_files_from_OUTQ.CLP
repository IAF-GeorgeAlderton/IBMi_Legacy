             PGM        PARM(&OUTQ)

             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

             DLTF       FILE(HWFILE1/OQSPLFILES)
             MONMSG     MSGID(CPF0000)

             WRKOUTQ    OUTQ(&OUTQ) OUTPUT(*PRINT)

             CRTPF      FILE(HWFILE1/OQSPLFILES) RCDLEN(132) +
                          SIZE(100000 10000 5)

             CPYSPLF    FILE(QPRTSPLQ) TOFILE(HWFILE1/OQSPLFILES) +
                          JOB(*) SPLNBR(*LAST) MBROPT(*ADD)

             CALL       PGM(RPGR70) PARM(&OUTQ)

             DLTF       FILE(HWFILE1/OQSPLFILES)

             ENDPGM

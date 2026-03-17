/* MOVE SPOOL FILE TO CLROUTQ */
             PGM        PARM(&FILE &NO &USER &JOB &FL# &LIB2 &OUT2)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NO  ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FL# ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LIB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUT2) TYPE(*CHAR) LEN(10)

             CHGSPLFA   FILE(&FILE) JOB(&NO/&USER/&JOB) SPLNBR(&FL#) +
                          JOBSYSNAME(*ANY) CRTDATE(*LAST) +
                          SELECT(*ALL) OUTQ(&LIB2/&OUT2)
             MONMSG     MSGID(CPF3340)

             ENDPGM

             PGM        PARM(&FILE &JOB &JOBU &JOBN &SPNB )

             DCL        VAR(&FILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBU)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBN)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&SPNB)    TYPE(*DEC)  LEN(6 0)

             CHGSPLFA   FILE(&FILE) JOB(&JOBN/&JOBU/&JOB) +
                          SPLNBR(&SPNB) OUTQ(YAJIMA2)
             MONMSG     MSGID(CPF0000)

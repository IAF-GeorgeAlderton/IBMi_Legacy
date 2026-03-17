             PGM        PARM(&FILE &JOB &USER &JOB# &SPL# &CRDT +
                          &CRTM &NOUTQ)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB#) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SPL#) TYPE(*CHAR) LEN(9)
             DCL        VAR(&CRDT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CRTM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&NOUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CRDATE) TYPE(*CHAR) LEN(8)

             CHGVAR     VAR(&CRDATE) VALUE('20' *TCAT &CRDT)

             CHGSPLFA   FILE(&FILE) JOB(&JOB#/&USER/&JOB) +
                          SPLNBR(&SPL#) CRTDATE(&CRDATE &CRTM) +
                          OUTQ(OQHOLD)
             MONMSG     MSGID(CPF0000)

             ENDPGM

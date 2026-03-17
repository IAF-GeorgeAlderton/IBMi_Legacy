             PGM

             DCL        VAR(&SYS) TYPE(*CHAR) LEN(10)

             DCL        VAR(&PARM1)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM3)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM4)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&PARM5)  TYPE(*CHAR) LEN(2)

             RTVNETA    SYSNAME(&SYS)

             CHGVAR     VAR(&PARM1) VALUE('HWFILE1')
             CHGVAR     VAR(&PARM2) VALUE('NZUWPS1')
             CHGVAR     VAR(&PARM3) VALUE(&SYS)
             CHGVAR     VAR(&PARM4) VALUE('C:/AS400/DATA/NZUWPS1.CSV')
             CHGVAR     VAR(&PARM5) VALUE(' 1')

             DLTF       FILE(NZUWPS1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/NZUWPS1) RCDLEN(256) SIZE(10000 +
                          10000 100)

             CALL       PGM(NZURS1)

             CALL       PGM(APLC98) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

             EDTDTA     FILE(NZUWPS1)

             ENDPGM

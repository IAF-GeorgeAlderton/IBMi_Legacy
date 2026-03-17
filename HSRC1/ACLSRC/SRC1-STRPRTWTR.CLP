             PGM        PARM(&PGMOBJ)

             DCL        VAR(&PGMOBJ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJLIB) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&PGM) VALUE(%SST(&PGMOBJ 01 10))
             CHGVAR     VAR(&OBJLIB) VALUE(%SST(&PGMOBJ 11 10))

             SNDMSG     MSG(&PGM) TOMSGQ(HPIS1)

             DLTF       FILE(QTEMP/DSPOBJD)
             MONMSG     MSGID(CPF3261 CPF2105)
             DSPOBJD    OBJ(&PGM) OBJTYPE(*PGM) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/DSPOBJD)

             EDTDTA     FILE(QTEMP/DSPOBJD)

             ENDPGM

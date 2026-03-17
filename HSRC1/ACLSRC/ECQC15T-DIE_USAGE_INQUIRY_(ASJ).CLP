             PGM

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

/* JW1   *** CLRPFM     FILE(&WLIB/ECQWP15 )                     *****/
/* JW1   *** OVRDBF     FILE(ECQWP15 ) TOFILE(&WLIB/ECQWP15 )    *****/

             DLTF       FILE(QTEMP/ECQWP15)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ OBJ(ECQWP15) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             CLRPFM     FILE(QTEMP/ECQWP15)

             DLTF       FILE(QTEMP/ECQWW15)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ OBJ(ECQWW15) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             CLRPFM     FILE(QTEMP/ECQWW15)

             OVRDBF     FILE(ECQWP15) TOFILE(QTEMP/ECQWP15)
             OVRDBF     FILE(ECQWW15) TOFILE(QTEMP/ECQWW15)

             CALL       PGM(ECQR15A)

             ENDPGM

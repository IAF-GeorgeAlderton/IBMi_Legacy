             PGM
             /** AB#CAI **********************************************/
             /*  ASJ PARTS PULLED INF                                */
             /*    H.AMANO       APR/26/04                           */
             /*                                                      */
             /*                                                      */
             /********************************************** AB#CAI **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CRTDUPOBJ  OBJ(AB#WPAI) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WPAI
             OVRDBF     FILE(AB#WPAI) TOFILE(QTEMP/AB#WPAI)

             OVRDBF     FILE(GDGPL04) TOFILE(HFILE1/GDGPL04)
             OVRDBF     FILE(ALDPL21) TOFILE(HFILE1/ALDPL21)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/AGDPL12)
             OVRDBF     FILE(FCEPL01) TOFILE(HFILE1/FCEPL01)

             CALL       PGM(TOBJ1/AB#RAI)

             ENDPGM

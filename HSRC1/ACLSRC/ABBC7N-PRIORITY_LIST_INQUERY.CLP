/* TCHK  04/20/11 CREATE(COPY FROM ABBC72)                */

             PGM

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(8)

             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&MAIS) TYPE(*DEC) LEN(3 0) VALUE(0)
             DCL        VAR(&PMAIS) TYPE(*CHAR) LEN(3) VALUE('   ')
             DCL        VAR(&PKYM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMPRNT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMD)    TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABBDS3 1 6))

             OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE01)  VALUE('ABBWP80' *CAT &WS)

             CRTDUPOBJ  OBJ(ABBWP71) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABBWL71) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABBWP71

             CRTDUPOBJ  OBJ(ABBWP72) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABBWL72) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABBWP72
/* jw ADD START ---> */
             CRTDUPOBJ  OBJ(ABBWP7J) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABBWL7J) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABBWP7J
             OVRDBF     FILE(ABBWP7J) TOFILE(QTEMP/ABBWP7J)
             OVRDBF     FILE(ABBWL7J) TOFILE(QTEMP/ABBWL7J)

             CRTDUPOBJ  OBJ(ABBWP7K) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABBWP7K
             OVRDBF     FILE(ABBWP7K) TOFILE(QTEMP/ABBWP7K)
/* jw ADD END  <--- */

             OVRDBF     FILE(ABBWP71) TOFILE(QTEMP/ABBWP71)
             OVRDBF     FILE(ABBWL71) TOFILE(QTEMP/ABBWL71)
             OVRDBF     FILE(ABBWP72) TOFILE(QTEMP/ABBWP72)
             OVRDBF     FILE(ABBWL72) TOFILE(QTEMP/ABBWL72)
STP01:
             CALL       PGM(ABBR7N) PARM(&CMD)

             IF         COND(&CMD *NE '1') THEN(DO)
             CLRPFM QTEMP/ABBWP71
             CLRPFM QTEMP/ABBWP72
             CLRPFM QTEMP/ABBWP7J
             CLRPFM QTEMP/ABBWP7K
             GOTO   STP01
             ENDDO

             DLTOVR *ALL



             ENDPGM

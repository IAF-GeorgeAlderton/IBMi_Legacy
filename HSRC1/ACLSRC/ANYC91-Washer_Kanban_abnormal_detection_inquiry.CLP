/** ANYC91 ************************************************/
/*  WASHER KANBAN ABNORMAL DETECTING INQUIRY              */
/*                                                        */
/* TCHK  03/07/13 CREATE(COPY FROM ANYC71)                */
/**********************************************************/
   PGM

             DCL        VAR(&ABADS1)  TYPE(*CHAR) LEN(48)
             DCL        VAR(&PKYM)    TYPE(*CHAR) LEN(6)

             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)

             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABADS1 1 6))


             CRTDUPOBJ  OBJ(ANYWP91) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ANYWP91)


             CRTDUPOBJ  OBJ(ANYWP72) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ANYWP72)


             CPYF       FROMFILE(HFILE1/GDGPP01)  +
                        TOFILE(QTEMP/ANYWP72)     +
                        MBROPT(*ADD)             +
                        FMTOPT(*MAP *DROP)

             DLCOBJ     OBJ((GDGPP01 *FILE *EXCL))


             OVRDBF     FILE(ANYWP91) TOFILE(QTEMP/ANYWP91)
             OVRDBF     FILE(ANYWP72) TOFILE(QTEMP/ANYWP72)

             CALL       PGM(HOBJ1/ANYR91) PARM(&PKYM)


             DLTOVR     FILE(*ALL)

             ENDPGM

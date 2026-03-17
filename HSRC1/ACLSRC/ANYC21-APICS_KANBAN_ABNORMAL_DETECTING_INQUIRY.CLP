/** ANYC21 ************************************************/
/*  APICS KANBAN ABNORMAL DETECTING INQUIRY               */
/*                                                        */
/* TCHK  05/13/11 CREATE                                  */
/**********************************************************/
             PGM        PARM(&P1SHN1 &P1SHN2 &P1SHN3)
             DCL        VAR(&P1SHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P1SHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P1SHN3) TYPE(*CHAR) LEN(2)

             CRTDUPOBJ  OBJ(ANYWP21) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AD#WP11) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AD#WL11) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ANYWP21)
             CLRPFM     FILE(QTEMP/AD#WP11)

             CPYF       FROMFILE(HFILE1/AD#PP11)  +
                        TOFILE(QTEMP/AD#WP11)     +
                        MBROPT(*ADD)             +
                        FMTOPT(*NOCHK)

             DLCOBJ     OBJ((AD#PP11 *FILE *EXCL))

             OVRDBF     FILE(ANYWP21) TOFILE(QTEMP/ANYWP21)
             OVRDBF     FILE(AD#WL11) TOFILE(QTEMP/AD#WL11)

             CALL       PGM(HOBJ1/ANYR21) PARM(&P1SHN1 &P1SHN2 &P1SHN3)

             DLTOVR     FILE(*ALL)

             ENDPGM

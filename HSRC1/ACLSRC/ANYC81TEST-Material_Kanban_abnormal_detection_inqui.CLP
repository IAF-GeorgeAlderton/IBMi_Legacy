/** ANYC81 ************************************************/
/*  MATERIAAL KANBAN ABNORMAL DETECTING INQUIRY           */
/*                                                        */
/* TCHK  05/16/12 CREATE                                  */
/**********************************************************/
   PGM

             CRTDUPOBJ  OBJ(ANYWP81) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ANYWP81)


             CRTDUPOBJ  OBJ(ANYWP82) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ANYWP82)

             CPYF       FROMFILE(HFILE1/GDLPP01)  +
                        TOFILE(QTEMP/ANYWP82)     +
                        MBROPT(*ADD)             +
                        FMTOPT(*MAP *DROP)

             DLCOBJ     OBJ((GDLPP01 *FILE *EXCL))


             OVRDBF     FILE(ANYWP81) TOFILE(QTEMP/ANYWP81)
             OVRDBF     FILE(ANYWP82) TOFILE(QTEMP/ANYWP82)

             CALL       PGM(TOBJ1/ANYR81TEST)


             DLTOVR     FILE(*ALL)

             ENDPGM

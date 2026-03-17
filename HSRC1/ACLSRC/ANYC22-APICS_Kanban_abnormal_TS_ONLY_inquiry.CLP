/** ANYC22 ************************************************/
/*  APICS KANBAN ABNORMAL <<TS ONLY>> INQUIRY             */
/*                                                        */
/* TCHK  09/11/11 CREATE                                  */
/**********************************************************/
   PGM

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

             CALL       PGM(HOBJ1/ANYR22)

             DLTOVR     FILE(*ALL)

             ENDPGM

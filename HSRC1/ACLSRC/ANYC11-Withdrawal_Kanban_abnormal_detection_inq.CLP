/** ANYC11 ************************************************/
/*  WITHDRAWAL KANBAN ABNORMAL DETECTING INQUIRY          */
/*                                                        */
/* TCHK  05/09/11 CREATE                                  */
/**********************************************************/
   PGM

             CRTDUPOBJ  OBJ(ANYWP11) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ANYWP11)
             OVRDBF     FILE(ANYWP11) TOFILE(QTEMP/ANYWP11)

             CALL       PGM(ANYR11)

             DLTOVR     FILE(*ALL)

             ENDPGM

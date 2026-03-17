/** ANYC01 ************************************************/
/*  PLATING KANBAN ABNORMAL DETECTING INQUIRY             */
/*                                                        */
/* TCHK  05/05/11 CREATE                                  */
/**********************************************************/
   PGM

             CRTDUPOBJ  OBJ(ANYWP01) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ANYWP01)
             OVRDBF     FILE(ANYWP01) TOFILE(QTEMP/ANYWP01)

             CALL       PGM(TOBJ1/ANYR01@)

             DLTOVR     FILE(*ALL)

             ENDPGM

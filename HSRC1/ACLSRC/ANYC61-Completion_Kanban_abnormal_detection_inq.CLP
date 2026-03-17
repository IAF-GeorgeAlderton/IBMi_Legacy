/** ANYC61 ************************************************/
/*  COMPLETION KANBAN ABNORMAL DETECTING INQUIRY          */
/*                                                        */
/* TCHK  12/09/11 CREATE(COPY FROM ANYC01)                */
/**********************************************************/
   PGM

             CRTDUPOBJ  OBJ(ANYWP61) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ANYWP61)
             OVRDBF     FILE(ANYWP61) TOFILE(QTEMP/ANYWP61)

             CALL       PGM(ANYR61)

             DLTOVR     FILE(*ALL)

             ENDPGM

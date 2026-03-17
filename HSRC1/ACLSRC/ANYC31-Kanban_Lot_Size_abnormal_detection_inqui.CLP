/** ANYC31 ************************************************/
/*  KANBAN LOT SIZE ABNORMAL DETECTING INQUIRY            */
/*                                                        */
/* TCHK  06/22/11 CREATE                                  */
/**********************************************************/
   PGM

             CRTDUPOBJ  OBJ(ANYWP31) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ANYWP31)

             OVRDBF     FILE(ANYWP31) TOFILE(QTEMP/ANYWP31)

             CALL       PGM(HOBJ1/ANYR31)

             DLTOVR     FILE(*ALL)

             ENDPGM

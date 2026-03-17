/** ANYC32 ************************************************/
/*  KANBAN #OF COUNT ABNORMAL DETECTING INQUIRY           */
/*                                                        */
/* TCHK  08/17/11 CREATE                                  */
/**********************************************************/
   PGM

             CRTDUPOBJ  OBJ(ANYWP32) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ANYWP32)

             OVRDBF     FILE(ANYWP32) TOFILE(QTEMP/ANYWP32)

             CALL       PGM(HOBJ1/ANYR32)

             DLTOVR     FILE(*ALL)

             ENDPGM

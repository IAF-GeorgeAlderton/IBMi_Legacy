/** AKBC30 ************************************************/
/*  WASHER SETTING# INQUIRY                               */
/*                                                        */
/* TCHK  09/02/11 CREATE                                  */
/**********************************************************/
   PGM

             CRTDUPOBJ  OBJ(AKBWP30) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AKBWP31) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AKBWP30)
             CLRPFM     FILE(QTEMP/AKBWP31)

             OVRDBF     FILE(AKBWP30) TOFILE(QTEMP/AKBWP30)
             OVRDBF     FILE(AKBWP31) TOFILE(QTEMP/AKBWP31)

             CALL       PGM(TOBJ1/AKBR30@)

             DLTOVR     FILE(*ALL)

             ENDPGM

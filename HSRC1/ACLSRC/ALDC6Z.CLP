/** ALDC6Y ************************************************/
/*  #OF SHORTAGE SCAN                                     */
/*                                                        */
/* TCHK  10/07/14 CREATE                                  */
/**********************************************************/
 PGM
             DLTF       FILE(QTEMP/ALDWP68)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(ALDWP68) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             OVRDBF     FILE(ALDWP68) TOFILE(QTEMP/ALDWP68)
             CLRPFM     FILE(QTEMP/ALDWP68)

             DLTF       FILE(QTEMP/ALDWP6ZH)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ALDWP6ZH) RCDLEN(132)

             DLTF       FILE(QTEMP/ALDWP6ZD)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ALDWP6ZD) RCDLEN(132)

             DLTF       FILE(QTEMP/ALDWP6ZT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ALDWP6ZT) RCDLEN(132)

             CALL       PGM(ALDR6Z)

             CALL       PGM(ALDR6@)

 ENDPGM

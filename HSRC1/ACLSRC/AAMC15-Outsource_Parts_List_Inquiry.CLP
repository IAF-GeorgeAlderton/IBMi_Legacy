  PGM
/** AAMC15 ************************************************/
/* OUTSOURCE PARTS LIST INQUIRY                           */
/*                                                        */
/* LEC  2022/05/04  CREATE                                */
/**********************************************************/

             DLTF       FILE(QTEMP/AAMWP15)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AAMWP15) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AAMWP15)

             OVRDBF     FILE(AAMWP15) TOFILE(QTEMP/AAMWP15)

             CALL       PGM(AAMR15)

             DLTOVR     FILE(*ALL)

             ENDPGM

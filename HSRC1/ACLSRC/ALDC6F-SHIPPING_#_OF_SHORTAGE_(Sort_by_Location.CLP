/** ALDC6E ************************************************/
/*  SHIPPING # OF SHORTAGE (BY LOCATION)                  */
/*                                                        */
/*  JW   2020.03.16                                       */
/**********************************************************/
 PGM
             DLTF       FILE(QTEMP/ALDWL6E)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(QTEMP/ALDWP6E)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(ALDWP6E) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             CRTDUPOBJ  OBJ(ALDWL6E) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             OVRDBF     FILE(ALDWP6E) TOFILE(QTEMP/ALDWP6E)
             OVRDBF     FILE(ALDWL6E) TOFILE(QTEMP/ALDWL6E)
             CLRPFM     FILE(QTEMP/ALDWP6E)

             CALL       PGM(ALDR6E) PARM('1')

 ENDPGM

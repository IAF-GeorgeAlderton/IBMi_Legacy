             PGM
/** AB#CAO2 ***********************************************/
/*  CREATE AB#WPAO1 (SCREEN DATA)                         */
/*  JW     2021.03.12                                     */
/**********************************************************/

             DLTF       FILE(QTEMP/AB#WPAO2)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WPAO2) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AB#WPAO2) TOFILE(QTEMP/AB#WPAO2)

             CALL       PGM(AB#RAO2)

             ENDPGM

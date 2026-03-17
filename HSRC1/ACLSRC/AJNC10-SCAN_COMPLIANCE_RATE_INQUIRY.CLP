             PGM
             /** AJNC10 **********************************************/
             /*  SCAN COMPLIANCE RATE INQUIRY                        */
             /*  JW       2020.05.11                                 */
             /********************************************************/

 /*1 SET WORK FILE IN QTEMP */
             DLTF       FILE(QTEMP/AJNWP10)
             MONMSG     MSGID(CPF2105)
             CRTDUPOBJ  OBJ(AJNWP10) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(AJNWP10) TOFILE(QTEMP/AJNWP10)
 /*1 */
             CALL       PGM(AJNR10)

             DLTOVR     FILE(*ALL)

             ENDPGM

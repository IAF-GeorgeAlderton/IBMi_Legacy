             PGM
             /** AB#CHE **********************************************/
             /*  HONDA PRE-ORDER SHIP DATE INQUIRY                   */
             /*  JW       2020.12.09                                 */
             /********************************************************/

             CLRPFM     FILE(AB#WPHE)
             DLTF       FILE(QTEMP/AB#WPHE)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AB#WPHE) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AB#WPHE) TOFILE(QTEMP/AB#WPHE)

             CALL       PGM(AB#RHE)

             ENDPGM

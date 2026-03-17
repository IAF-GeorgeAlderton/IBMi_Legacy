             PGM
             /** AB#CH5C *****************************************/
             /*  HONDA EDI(830/862) ORDER INQUIRY (V.03)         */
             /*  JW    2023.12.08                                */
             /****************************************************/

             DLTF       FILE(QTEMP/AB#WPH5)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPH5) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WPH5)

             OVRDBF     FILE(AB#WPH5) TOFILE(QTEMP/AB#WPH5)

 /** JW      CALL       PGM(AB#RH5C)   *********************/
             CALL       PGM(AB#RH5D)

             ENDPGM

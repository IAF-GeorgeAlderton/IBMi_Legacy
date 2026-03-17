             PGM
             /** GKTCB5 *********************/
             /* RETURN OF THE NETWORK JOB (DIE ORDER INFO)  */
             /*       MAEDA.    2017.11.14  */
             /*******************************/
             DLTF       FILE(APSAVLIB/GKTWPB0)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTSAVF    FILE(APSAVLIB/GKTWPB0) AUT(*ALL)

             RCVNETF    FROMFILE(GKTWPB0) TOFILE(APSAVLIB/GKTWPB0) +
                          USER(QFILE)

             RSTOBJ     OBJ(GKTWPB0) SAVLIB(WORKLIB) DEV(*SAVF) +
                          OBJTYPE(*FILE) SAVF(APSAVLIB/GKTWPB0) +
                          MBROPT(*ALL) ALWOBJDIF(*ALL) +
                          FRCOBJCVN(*YES) RSTLIB(QGPL)
             MONMSG     MSGID(CPF3773)

             OVRDBF     FILE(GKTWPB0) TOFILE(QGPL/GKTWPB0)
             CALL       PGM(GKTRB5)
             DLTOVR     FILE(GKTWPB0)

             DLTF       FILE(QGPL/GKTWPB0)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM

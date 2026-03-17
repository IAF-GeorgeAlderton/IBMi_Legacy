             PGM
             /*** AJ#C40C **********************************/
             /*  INVENTORY FILE  (V02)                     */
             /*  ITS.              2015.05.15              */
             /*----------------------------------          */
             /*  JW    2023.02.23 IMPROVING PROCESS TIME   */
             /**********************************************/

       /* SET WORK FILE  */
             DLTF       FILE(QTEMP/AJ#PP40)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(AJ#PP40) FROMLIB(HFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(AJ#PP40) TOFILE(QTEMP/AJ#PP40 )

             CALL       PGM(AJ#R40C)

             ENDPGM

             PGM
             /** ABBC70 ****************************************************/
             /*  PRIORITY KANBAN (ENTRY)                                   */
             /**************************************************************/

             ADDLIBLE   LIB(HWFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(HFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(HOBJ1)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ABBPL72) TOFILE(TFILE1/ABBPL72)

             CALL       PGM(TOBJ1/ABBR7A)

  /****      SIGNOFF   ***/

             ENDPGM

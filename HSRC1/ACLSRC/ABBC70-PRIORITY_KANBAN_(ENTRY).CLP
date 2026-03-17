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

             CALL       PGM(ABBR7A)

             SIGNOFF

             ENDPGM

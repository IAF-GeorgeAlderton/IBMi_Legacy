             PGM

  /** AL#C26 *************************************/
  /* CREATE TOYOTA KANBAN#/PART# M/F - AL#PP26   */
  /*    LEC       2023.07.21                     */
  /***********************************************/

             CLRPFM     FILE(HWFILE1/AL#WP26)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(HFILE1/AL#PP26)
             MONMSG     MSGID(CPF0000)

  /*  run sql to create toyota kanban# workfile...            */
             CALL       PGM(AL#R426)

  /*  process workfile into toyota kanban#/part# master file..*/
             CALL       PGM(AL#R26)

             ENDPGM

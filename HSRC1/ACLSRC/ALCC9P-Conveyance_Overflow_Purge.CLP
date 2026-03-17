             PGM
/** ALCC9P ************************************************/
/*  CONVEYANCE OVERFLOW PURGE                             */
/*  LEC          2023.07.31                               */
/**********************************************************/

             CALL       PGM(ALCR9P)

             RGZPFM     FILE(ALCPP9V)
             MONMSG     MSGID(CPF0000)

             ENDPGM

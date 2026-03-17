             PGM
/** ALDC9P ************************************************/
/*  SHIPPING OVERFLOW PURGE                               */
/*  LEC          2023.06.13                               */
/**********************************************************/

             CALL       PGM(ALDR9P)

             RGZPFM     FILE(ALDPP9V)
             MONMSG     MSGID(CPF0000)

             ENDPGM

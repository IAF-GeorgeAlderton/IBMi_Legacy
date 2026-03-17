   PGM
/** AKAC60 ************************************************/
/*  OUTSOURCE PARTS LOCATION TABLE FOR PC                 */
/*                                                        */
/* TCHK1 08/14/07 CREATE                                  */
/**********************************************************/
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
   @START:
             CLRPFM     FILE(&WLIB/AFDWP90)

             OVRDBF     FILE(AFDWP90) TOFILE(&WLIB/AFDWP90)

             CALL       PGM(AFDR90)

   @END:
             ENDPGM

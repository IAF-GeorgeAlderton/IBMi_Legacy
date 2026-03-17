   PGM
/** ADHC50 ************************************************/
/*  QUENCHING PARTS LOCATION LABLE FOR PC                 */
/*                                                        */
/* TCHK1 06/06/13 CREATE                                  */
/**********************************************************/
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
   @START:
             CLRPFM     FILE(HWFILE1/ADHWP50)

             OVRDBF     FILE(ADHWP50) TOFILE(HWFILE1/ADHWP50)

             CALL       PGM(ADHR50)

   @END:
             ENDPGM

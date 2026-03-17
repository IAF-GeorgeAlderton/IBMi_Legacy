   PGM
/** GDMC070 ***********************************************/
/*  ASJ WASHER LOCATION LABEL FOR PC                      */
/*                                                        */
/* TCHK1 11/19/10 CREATE                                  */
/**********************************************************/
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
   @START:
             CLRPFM     FILE(HWFILE1/GDMWP20)

             OVRDBF     FILE(GDMWP20) TOFILE(HWFILE1/GDMWP20)

             CALL       PGM(GDMR070)

   @END:
             ENDPGM

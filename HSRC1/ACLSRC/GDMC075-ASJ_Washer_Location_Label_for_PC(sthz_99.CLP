   PGM
/** GDMC075 ***********************************************/
/*  ASJ WASHER LOCATION LABEL FOR PC                      */
/*  SELECT STHZ 99999999                                  */
/*                                                        */
/* TCHK1 02/16/11 CREATE                                  */
/**********************************************************/
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
   @START:
             CLRPFM     FILE(HWFILE1/GDMWP20)

             OVRDBF     FILE(GDMWP20) TOFILE(HWFILE1/GDMWP20)

             CALL       PGM(GDMR075)

   @END:
             ENDPGM

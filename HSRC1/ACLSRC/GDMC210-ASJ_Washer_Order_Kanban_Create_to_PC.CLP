   PGM
/** GDMC210 ***********************************************/
/*  ASJ WASHER ORDER KANBAN CREATE TO PC                  */
/*                                                        */
/* TCHK1 11/24/10 CREATE                                  */
/**********************************************************/
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
   @START:
             CLRPFM     FILE(HWFILE1/GDMWP10)

             OVRDBF     FILE(GDMWP10) TOFILE(HWFILE1/GDMWP10)

             CALL       PGM(GDMR210)

   @END:
             ENDPGM

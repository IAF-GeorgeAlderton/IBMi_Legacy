    PGM
/** AFDC60 ************************************************/
/*  outsource parts list                                  */
/*                                                        */
/* TCHK  04/10/15 CREATE                                  */
/**********************************************************/
            DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
            DCL        VAR(&USR)   TYPE(*CHAR) LEN(10)

            RTVJOBA    USER(&USR)

            CLRPFM     HWFILE1/AFDWP60
            OVRDBF     FILE(AFDWP60) TOFILE(HWFILE1/AFDWP60)

            CALL       PGM(HOBJ1/AFDR60)

            ENDPGM

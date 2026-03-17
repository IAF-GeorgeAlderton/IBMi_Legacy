             PGM
/*** GTAC50 ***********************************************/
/*  INVOICE DATA CREATE                                   */
/*                                                        */
/* TCHK  01/08/13 CREATE                                  */
/**********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TMID) TYPE(*CHAR) LEN(06)

             RTVJOBA    JOB(&WSNO) USER(&USER)

             CPYF       FROMFILE(HWFILE1/GTAWP50)    +
                          TOFILE(HWFILE1/GTAWP50@SV) +
                          MBROPT(*ADD) CRTFILE(*NO)

             CLRPFM     FILE(HWFILE1/GTAWP50)

             CALL       PGM(HOBJ1/GTAR50)

 @END:
             ENDPGM

             PGM PARM(&TMID)
/*** GTAC40 ***********************************************/
/*  PACKING LIST DATA CREATE                              */
/*                                                        */
/* TCHK  11/14/12 CREATE                                  */
/**********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TMID) TYPE(*CHAR) LEN(06)

             RTVJOBA    JOB(&WSNO) USER(&USER)

             CLRPFM     FILE(HWFILE1/GTAWP40)
             CLRPFM     FILE(HWFILE1/GTAWP41)

             CALL       PGM(HOBJ1/GTAR40) PARM(&TMID)

 @END:
             ENDPGM

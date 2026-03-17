             PGM PARM(&TMID)
/*** GTAC20 ***********************************************/
/*  CASE LABEL DATA CREATE                               */
/*                                                        */
/* TCHK  08/27/12 CREATE                                  */
/**********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TMID) TYPE(*CHAR) LEN(06)

             RTVJOBA    JOB(&WSNO) USER(&USER)

             CLRPFM     FILE(HWFILE1/GTAWP20)

             OVRDBF     FILE(AB#PPCT) TOFILE(HFILE1/AB#PPCT)
             OVRDBF     FILE(GTAPP20) TOFILE(HFILE1/GTAPP20)

             CALL       PGM(HOBJ1/GTAR20) PARM(&TMID)

 @END:
             ENDPGM

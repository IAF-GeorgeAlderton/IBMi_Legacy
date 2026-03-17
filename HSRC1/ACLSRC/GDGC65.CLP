/*  ASJ PARTS SCANNED RESULT                                       */
/*               TCH  OCT/03/02                                    */
/*-----------------------------------------------------------------*/
             PGM

             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(&WLIB/GDGWP65)
             CLRPFM     FILE(&WLIB/GDGWP66)

             CALL       PGM(GDGR65)

             ENDPGM

             PGM        PARM(&UPGM &WKCD &WKNM &PGRP)
             /** BSDCD1 **************************************/
             /*CREATE SIGN-ON INFORMATION                  */
             /*        T.SAKAKI        2015.10.13            */
             /************************************************/
             DCL        VAR(&UPGM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WKNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 /*CREATE SIGN-ON INFORMATION */
 @STEP01:

 @END:
             ENDPGM

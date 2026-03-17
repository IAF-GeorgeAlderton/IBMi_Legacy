/** ALCC10 ************************************************/
/*  COPIED FROM ALCC01                                    */
/*   WORKER CODE AND USER ID ARE PASSED IN, AND PASSED TO */
/*   CONVEYANCE PULL 3-POINT SCAN                         */
/*                                                        */
/* TCHK1 04/21/09 CREATE                                  */
/**********************************************************/
             PGM        PARM(&WKCD &USRID &SECT)

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SECT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)

             RTVJOBA    USER(&USER)
           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             OVRDBF    FILE(AGDPP11) TOFILE(&PLIB/A@DPP11)
             OVRDBF    FILE(AGDPL11) TOFILE(&PLIB/A@DPL11)
             OVRDBF    FILE(AGDPL12) TOFILE(&PLIB/A@DPL12)

 /*  Run Conveyance Pull 3pt Scan                                   */
             CALL       PGM(ALCR10) PARM(&WKCD &USRID &SECT)

 ENDPGM

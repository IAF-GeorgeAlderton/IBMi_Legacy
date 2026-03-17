/** ALCC101 ***********************************************/
/*  COPIED FROM ALCC10                                    */
/*   WORKER CODE AND USER ID ARE PASSED IN, AND PASSED TO */
/*   CONVEYANCE PULL 4-POINT SCAN                         */
/*                                                        */
/**********************************************************/
             PGM        PARM(&WKCD &USRID)

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)

             OVRDBF    FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF    FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF    FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

 /*  Run OQ 4pt Scan                                   */
             CALL       PGM(ALCR101) PARM(&WKCD &USRID)

 ENDPGM

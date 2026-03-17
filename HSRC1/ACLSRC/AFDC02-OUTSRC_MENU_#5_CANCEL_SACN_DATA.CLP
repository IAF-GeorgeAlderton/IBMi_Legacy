             PGM        PARM(&USER &WKCD &SUPP &SUPX)
             /** AFDC01 **************************************/
             /*  OUTGOING DETAIL                             */
             /*      TO CURTIS (SUPPLYER CODE = 2222)        */
             /*  TCH 2001.12.12                              */
             /*                                              */
             /************************************** AFDC01 **/
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKCD)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&SUPP)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&SUPX)    TYPE(*CHAR) LEN(1)

     /*      CHGVAR     VAR(&SUPP) VALUE('2222') */

             CALL       PGM(AFDR02) PARM(&USER &WKCD &SUPP &SUPX)

             ENDPGM

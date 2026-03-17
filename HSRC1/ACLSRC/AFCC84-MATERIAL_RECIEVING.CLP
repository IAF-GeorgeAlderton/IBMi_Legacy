             PGM
             /** AFCC84 ************************************/
             /* MATERIAL RECEIVING                         */
             /* <LOCAL PARTS PROCUREMENT SYSTEM>           */
             /*                                            */
             /*                                            */
             /************************************ AFCC84 **/
             DCL        VAR(&WKCD)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&END)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)

             RTVJOBA      USER(&USER)

             CALL       PGM(AFBR8W) PARM(&WKCD &END)

             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))

             CALL       PGM(AFCR84) PARM(&USER &WKCD)
 @END:
             ENDPGM

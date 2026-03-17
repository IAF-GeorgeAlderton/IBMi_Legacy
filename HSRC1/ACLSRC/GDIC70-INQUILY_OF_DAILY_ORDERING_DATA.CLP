             PGM
             /**** GDIC70 ************************/
             /*  INQUILY OF DAILY ORDERING DATA  */
             /*   N.HAYAKAWA          97/02/20   */
             /************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(GDIR70) PARM(&USER)

             ENDPGM

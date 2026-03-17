             PGM
             /**** GDIC22 ****************/
             /*  DELETE OF ORDER         */
             /*  N.HAYAKAWA    97/02/20  */
             /****************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(GDIR22) PARM(&USER)

             ENDPGM

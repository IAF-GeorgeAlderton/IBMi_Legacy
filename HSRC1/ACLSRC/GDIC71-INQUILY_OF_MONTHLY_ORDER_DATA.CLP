             PGM
             /**** GDIC71 ***********************/
             /*  INQUILY OF MONTHLY ORDER DATA  */
             /*  N.HAYAKAWA           97/02/18  */
             /***********************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(GDIR71) PARM(&USER)

             ENDPGM

             PGM
             /**** GDIC80 ****************************/
             /*  DIE & LOCATION MASTER TABLE UPDATE  */
             /*   N.HAYAKAWA              97/05/20   */
             /****************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(GDIR80) PARM(&USER)

             ENDPGM

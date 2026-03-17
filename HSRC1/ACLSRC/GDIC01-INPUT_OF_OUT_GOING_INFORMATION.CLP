             PGM
             /**** GDIC01 ************************/
             /*  INPUT OF OUT GOING INFORMATION  */
             /*    N.HAYAKAWA        97/02/18    */
             /************************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(GDIR01) PARM(&USER)

             ENDPGM

             PGM
             /**** GDIC30 ************************/
             /*  PRINT OF ORDER REMAINDER TABLE  */
             /*   N.HAYAKAWA          97/02/24   */
             /************************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(GDIR30) PARM(&USER)

             ENDPGM

             PGM
             /**** GDIC31 **********************/
             /*  PRINT OF ORDER HISTORY TABLE  */
             /*   N.HAYAKAWA        97/02/24   */
             /**********************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(GDIR31) PARM(&USER)

             ENDPGM

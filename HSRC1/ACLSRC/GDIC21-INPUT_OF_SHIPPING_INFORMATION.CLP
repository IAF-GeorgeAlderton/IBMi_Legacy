             PGM
             /**** GDIC21 ***********************/
             /*  INPUT OF SHIPPING INFORMATION  */
             /*    N.HAYAKAWA       97/02/20    */
             /***********************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(GDIR21) PARM(&USER)

             ENDPGM

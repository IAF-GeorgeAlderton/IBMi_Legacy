             PGM
             /*** CTAC01 *********************************/
             /* INPUT OF THE ISSUE A-PICS2 DATA     <CL> */
             /*                     T.SAKAKI   2020.08.19*/
             /********************************** CTAC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(CTAR01) PARM(&USER)

             ENDPGM

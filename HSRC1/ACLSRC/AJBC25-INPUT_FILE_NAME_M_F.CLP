             PGM
             /*** AJBC25 *************************/
             /* INPUT FILE NAME M/F              */
             /* H.ITO              87.05.21      */
             /************************* AJBC25 ***/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&US)


             CALL       PGM(AJBR25) PARM(&US)


             ENDPGM

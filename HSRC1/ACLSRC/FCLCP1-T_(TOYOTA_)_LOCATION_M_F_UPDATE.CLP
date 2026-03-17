             PGM
             /**FCLCP1*******************************************/
             /* T (TOYOTA ) LOCATION M/F UPDATE                           */
             /*            M-OKUDA        1984.07.09            */
             /*******************************************FCLCP1**/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&US)

             CALL       PGM(FCLR11) PARM(&US)

             ENDPGM

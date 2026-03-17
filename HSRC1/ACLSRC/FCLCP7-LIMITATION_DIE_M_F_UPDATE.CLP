             PGM
             /**FCLCP7*******************************************/
             /* LIMITATION DIE M/F UPDATE                                  */
             /*            M-OKUDA        1984.07.09            */
             /*******************************************FCLCP1**/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&US)
             CALL       PGM(FCLR71) PARM(&US)
             ENDPGM

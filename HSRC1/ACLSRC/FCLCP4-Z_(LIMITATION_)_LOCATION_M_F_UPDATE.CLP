             PGM
             /**FCLCP4*******************************************/
             /* Z (LIMITATION ) LOCATION M/F UPDATE                         */
             /*            M-OKUDA        1984.07.09            */
             /*******************************************FCLCP4**/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&US)

             CALL       PGM(FCLR41) PARM(&US)

             ENDPGM

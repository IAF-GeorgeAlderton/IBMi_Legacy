             PGM
             /******************************************************/
             /* MACHINE ABILITY M/F UPDATE                                  */
             /*            M-OKUDA        1983.06.16               */
             /******************************************************/
             DCL        VAR(&PUSER) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&PUSER)
             CALL       PGM(FCHR31) PARM(&PUSER)
             ENDPGM

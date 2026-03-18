             PGM        PARM(&PSIRE &FILE3)
             /** AB#C2J ***********************************/
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FILE3)   TYPE(*CHAR) LEN(10)

      /*     DLYJOB     DLY(7200)  */
             DLYJOB     DLY(20)
             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             CALL       PGM(AB#R2J) PARM(&PSIRE)


 END:        ENDPGM

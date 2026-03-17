             PGM
             /** CAIC11 ******************************************/
             /*  ..A-PICS2 CYCLE M/F UPDATE                   .  */
             /*       T-SAKAKI              2020.08.19           */
             /****************************************** CAIC11 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(CAIR11) PARM(&USER)

             ENDPGM

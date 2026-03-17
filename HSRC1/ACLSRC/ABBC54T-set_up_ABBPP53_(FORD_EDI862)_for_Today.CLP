             PGM
             /* ABBC54T *******************************************/
             /* SET UP ABBPP53 (FORD EDI862)                      */
             /*  (RECEIVED DATE --> TODAY)                        */
             /* J.W      2024.11.08                               */
             /*****************************************************/
             DCL        VAR(&RCVDT)  TYPE(*CHAR) LEN(8)
/* GET TODAY     */
             CALL       PGM(UTLR02T) PARM(&RCVDT)
             CALL       PGM(ABBR54)  PARM(&RCVDT)

             ENDPGM

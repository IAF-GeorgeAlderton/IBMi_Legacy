             PGM
             /** AJEC12 ********************/
             /*   PASS THROUGH EXECUTION   */
             /* I-HASADA 91.05.23 */
             /******************** AJEC12 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&US)

             CALL       PGM(AJER12) PARM(&US)

             ENDPGM

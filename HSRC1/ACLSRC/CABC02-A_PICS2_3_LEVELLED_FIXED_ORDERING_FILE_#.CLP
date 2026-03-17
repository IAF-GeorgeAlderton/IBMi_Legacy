             PGM
             /** CABC02 ********************************************/
             /*  A-PICS2/3 LEVELLED FIXED ORDERING FILE - UPDATE.  */
             /*  ..# OF BOX UPDATE                                 */
             /*       T.SAKAKI              2020.08.19             */
             /******************************************** CABC02 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(CABR02) PARM(&USER)

             ENDPGM

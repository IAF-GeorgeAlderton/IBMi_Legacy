             PGM
             /** CABC01 ********************************************/
             /*  A-PICS2/3 LEVELLED FIXED ORDERING FILE - UPDATE.  */
             /*       T.SAKAKI                    2020.03.10       */
             /******************************************** CABC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(CABR01) PARM(&USER)

             ENDPGM

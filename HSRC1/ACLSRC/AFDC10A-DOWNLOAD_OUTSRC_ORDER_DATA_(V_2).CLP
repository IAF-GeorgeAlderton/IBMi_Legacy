             PGM        PARM(&SUPP)
             /** AFDC10A *********************************************/
             /*  DOWNLOAD OUTSRC ORDER DATA (V.2)                    */
             /*----------------------------------                    */
             /* JW1    2023.10.11 ADD DOWNLOAD TO CSV                */
             /********************************************************/

             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(4)

             CALL       PGM(AFDR10A) PARM(&SUPP)

             ENDPGM

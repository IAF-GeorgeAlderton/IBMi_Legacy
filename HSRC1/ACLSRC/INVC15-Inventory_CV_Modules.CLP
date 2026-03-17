             PGM
             /***INVC15 ****************************************/
             /* INVENTORY -- CV MODULES                        */
             /**************************************************/

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

             RTVJOBA    USER(&USER)

             /*****************************************************************/
             /*  TEAM MEMBER SIGN-ON                                          */
                         CALL       PGM(ALCR0Y) PARM(&WKCD &USER &VALID)

             /*****************************************************************/
             /*  MODULE INVENTORY SCAN PROGRAM                                */
                         IF         COND(&VALID = 'Y') THEN(DO)
                                     CALL       PGM(INVR15) PARM(&WKCD &USER)
                                                       ENDDO

             /*****************************************************************/

             SIGNOFF

             ENDPGM

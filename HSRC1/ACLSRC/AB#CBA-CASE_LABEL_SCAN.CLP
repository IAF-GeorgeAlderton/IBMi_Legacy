             PGM
             /** AB#CBA ***********************************************/
             /*  ..PRINT TMS CASE LABEL                               */
             /*                                                       */
             /*                                                       */
             /***************************** AB#C2C ********************/

             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

 /*******************************************************************/
 /*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USER &VALID)

 /*******************************************************************/
 /*  IF WORKER CODE IS VALID, CALL SCAN PGM                         */
             IF         COND(&VALID = 'Y') THEN(DO)

             CALL       PGM(AB#RBA) PARM(&WKCD)
                        ENDDO

 /*******************************************************************/

             SIGNOFF

             ENDPGM

             PGM
   /** ALXC01 ************************************************/
   /*  TEST SCAN MENU                                        */
   /**********************************************************/

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6) VALUE('999999')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(20) VALUE('TEST')
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

 /*******************************************************************/
 /*  CONVEYANCE SYSTEM MENU                                         */
                         CALL       PGM(ALXR00) PARM(&WKCD &USER)

 /*******************************************************************/

             SIGNOFF

             ENDPGM

             PGM        PARM(&PIPGMN)
             /** EJKC66 *******************************************/
             /* HULFT  FILE SENT CHECK PROCESS                    */
             /* THIS IS AUTOMATICALLY PROCESSED AFTER HULFT WORKS */
             /*    **ORIGINAL IS JK916C FROM ASJ**                */
             /*  T.SAKAKI                    2016.10.13           */
             /******************************************* EJKC66 **/
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)

             CALL       PGM(APLR81) PARM(&PIPGMN)
END2:
             ENDPGM

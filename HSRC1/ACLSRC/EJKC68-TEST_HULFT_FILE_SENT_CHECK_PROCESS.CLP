             PGM        PARM(&PIPGMN)
             /** EJKC68 *******************************************/
             /* <TEST> HULFT  FILE SENT CHECK PROCESS             */
             /* THIS IS AUTOMATICALLY PROCESSED AFTER HULFT WORKS */
             /*    **ORIGINAL IS JK916C FROM ASJ**                */
             /*  T.SAKAKI                    2016.10.13           */
             /******************************************* EJKC68 **/
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)

             OVRDBF     FILE(APLPP80) TOFILE(TFILE1/APLPP80)
             CALL       PGM(APLR81) PARM(&PIPGMN)
             DLTOVR     FILE(*ALL)
END2:
             ENDPGM

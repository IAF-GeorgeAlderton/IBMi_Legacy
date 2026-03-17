             /** UEXC05E **********************************************/
             /*  TEST - UEXR05E                                       */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&SHN   ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&DPT   ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DAT   ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LOC   ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SET   ) TYPE(*CHAR) LEN(5)

             CHGVAR     VAR(&SHN ) VALUE('AA1612B9N68D ')
             CHGVAR     VAR(&DPT ) VALUE('3111')
             CHGVAR     VAR(&DAT ) VALUE('20240617')

             CALL       PGM(UEXR05E) PARM(&SHN &DPT &DAT &LOC &SET)

             ENDPGM

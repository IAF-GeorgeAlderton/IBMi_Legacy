             PGM        PARM(&PGM &TACD &TANM &CMD &STS)
             /** ALDCS1 **************************************/
             /* CALL PGM                                     */
             /*        KIRI            2014.02.19            */
             /************************************************/
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TACD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TAC5) TYPE(*CHAR) LEN( 5)
             DCL        VAR(&TANM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMD ) TYPE(*CHAR) LEN( 2)
             DCL        VAR(&STS ) TYPE(*CHAR) LEN( 1)

             CHGVAR     VAR(&TAC5) VALUE(%SST(&TACD 1 5))

 @STEP01:
             CALL       PGM(&PGM)  PARM(&TAC5 &TANM &CMD &STS)


             ENDPGM

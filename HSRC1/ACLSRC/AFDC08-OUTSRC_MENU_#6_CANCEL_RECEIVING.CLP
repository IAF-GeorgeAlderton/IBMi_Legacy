             PGM        PARM(&SUPP &SUPX)
             /** AFDC08 **************************************/
             /*  OUTGOING DETAIL                             */
             /*  TCH 2001.12.12                              */
             /************************************************/
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKCD)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&SUPP)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&SUPX)    TYPE(*CHAR) LEN(1)

             CALL       PGM(AFDR08) PARM(&SUPP &SUPX)

             ENDPGM

             PGM        PARM(&BAR &USR &NONY &NOHZ &MAN# )
             /** AC#C95 ********************************/
             /*  RETRIEVE MANIFEST NUMBER              */
             /*  J.WATANABE      2017.0403             */
             /******************************************/
             DCL        VAR(&BAR ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&USR ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&BIN ) TYPE(*DEC ) LEN(2 0)
             DCL        VAR(&MAN#) TYPE(*CHAR) LEN(18)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR53) PARM(&BAR &BIN &RTN)

             CALL       PGM(AB#R95) PARM(&USR &NONY &NOHZ &BIN &MAN#)

             ENDPGM

             PGM        PARM(&USER &WKCD &SUPP &PID)
             /** AFDC07 **************************************/
             /*  OUTSRC RECEIVE DETAIL (HH/HH)               */
             /*  TCH 2001.12.12                              */
             /************************************************/
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKCD)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&SUPP)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&PID)     TYPE(*CHAR) LEN(1)

             CALL       PGM(AFDR07) PARM(&USER &WKCD &SUPP &PID)

             ENDPGM

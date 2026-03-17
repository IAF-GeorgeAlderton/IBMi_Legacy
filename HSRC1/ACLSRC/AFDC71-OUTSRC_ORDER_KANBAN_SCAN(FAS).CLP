    PGM     PARM(&USER &WKCD &SUPP &PID)
/** AFDC71 ************************************************/
/*  OUTGOING ORDER KANBAN SCAN(FAS)                       */
/*                                                        */
/* TCHK1 09/20/12 CREATE                                  */
/**********************************************************/
            DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
            DCL        VAR(&WKCD)  TYPE(*CHAR) LEN(6)
            DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
            DCL        VAR(&PID)   TYPE(*CHAR) LEN(1)
            DCL        VAR(&USR)   TYPE(*CHAR) LEN(10)
            DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
            RTVJOBA    USER(&USR)
            CALL       PGM(ALBC00) PARM(&USR &WLIB)

            CALL       PGM(AFDR71) PARM(&USER &WKCD &SUPP &PID)

            DLTOVR     FILE(*ALL)

            ENDPGM

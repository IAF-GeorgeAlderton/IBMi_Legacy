             PGM
/** AB#CBG *************************************************/
/*  ..PRINT TMS CASE LABEL AFTER PACKING                   */
/*                                                         */
/* TCHK1 12/22/09 CREATE                                   */
/***************************** AB#CBG **********************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(&WLIB/AB#WP2Q)

             CALL       PGM(AB#RBG)

             ENDPGM

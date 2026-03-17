             PGM
             /** AB#C6K ************************/
             /*  ..TMMNA ACCOUNT PAYBALE LIST  */
             /*                                */
             /* TCHK1 06/17/09 CHG LANPRT04 --> LANPRT03 */
             /************************ AB#C6G **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&USR &WLIB)

/* TCHK1     OVRPRTF    FILE(QPRINT) OUTQ(LANPRT04) FORMTYPE(K6H1) */
/* TCHK1 */  OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03) FORMTYPE(K6H1)
             CALL       PGM(AB#R6K)

             ENDPGM

             PGM        PARM(&CUST &YYMM)
             /** AB#C6K ************************/
             /*  ..TMMNA ACCOUNT PAYBALE LIST  */
             /*                                */
             /* TCHK1 06/17/09 CHG LANPRT04 --> LANPRT03 */
             /************************ AB#C6G **/
             DCL        VAR(&CUST) TYPE(*CHAR) LEN(2)
             DCL        VAR(&YYMM) TYPE(*DEC) LEN(6 0)

/* TCHK1     OVRPRTF    FILE(QPRINT) OUTQ(LANPRT04) FORMTYPE(K6H1) */
/* TCHK1 */  OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03) FORMTYPE(K6H1)
             CALL       PGM(AB#R6H) PARM(&CUST &YYMM)

             ENDPGM

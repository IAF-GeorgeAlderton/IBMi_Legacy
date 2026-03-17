             PGM        PARM(&DATE &TIME)
             /** AB#C6N ************************/
             /*  ..FORD  ACCOUNT PAYBALE LIST  */
             /*                                */
             /* TCHK1 06/17/09 CHG LANPRT04 --> LANPRT03 */
             /************************ AB#C6N **/
             DCL        VAR(&DATE) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&TIME) TYPE(*DEC) LEN(6 0)

/* TCHK1 */  OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(QDKT) FORMTYPE(K6H1)

             CALL       PGM(EB#R6N) PARM(&DATE &TIME)

             ENDPGM

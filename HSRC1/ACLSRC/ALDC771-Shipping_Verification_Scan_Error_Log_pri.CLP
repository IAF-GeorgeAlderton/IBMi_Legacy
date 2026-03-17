  PGM PARM(&STDT &EDDT)
/** ALDC77 *************************************************/
/*  SHIPPING VERIFICATION SCAN ERROR LOG LIST              */
/*                                                         */
/* TCHK1 03/12/10 CREATE                                   */
/***********************************************************/
             DCL        VAR(&STDT)     TYPE(*CHAR) LEN(08)
             DCL        VAR(&EDDT)     TYPE(*CHAR) LEN(08)

/* ERROR LOG */
             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(LANPRT06) FORMTYPE(K6H1)

             CALL       PGM(ALDR771)   PARM(&STDT &EDDT)

             DLTOVR     FILE(QPRINT)

             ENDPGM

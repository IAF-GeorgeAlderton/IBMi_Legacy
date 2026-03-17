             PGM
             /** ALDC60 ************************************/
             /*     3-POINT ERROR LOG LIST                 */
             /*                                            */
             /* TCHK1 03/07/06 ADD EE(4-POINT) ERROR LOG   */
             /* TCHK2 07/28/10 CHG EE(4-POINT) ERROR LOG   */
             /* TCHK2 07/28/10 CHG 4/3-POINT)  ERROR LOG   */
             /* TCHK2 07/28/10 RMV COMBINED PARTIAL  LOG   */
             /**********************************************/
/* TCHK2     OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(QPRINT) FORMTYPE(K6H1) */
/* TCHK2 */  OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(QDKT)   FORMTYPE(K6H1)
             CALL       PGM(ALDR60)
             DLTOVR QPRINT

             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 132) OUTQ(LANPRT50) +
                          FORMTYPE(K6H1) HOLD(*YES) SAVE(*YES)
             CALL       PGM(AB#R1C)

/* TCHK2     CALL       PGM(AFAC70) */

/* TCHK1 */  DLTOVR     QPRINT
/* TCHK1 */  OVRPRTF    FILE(QPRINT) CPI(15) RPLUNPRT(*YES) +
/* TCHK2 */               OUTQ(QDKT) FORMTYPE(K6H1)         +
/* TCHK1 */               PAGESIZE(*N 198)
/* TCHK1 */  CALL       PGM(AFAR6Z)
/* TCHK1 */  DLTOVR     QPRINT
/* TCHK1 */
/* TCHK1 */  OVRPRTF    FILE(QPRINT) CPI(15) RPLUNPRT(*YES) +
/* TCHK1 */               OUTQ(LANPRT08) FORMTYPE(K6H1)     +
/* TCHK1 */               PAGESIZE(*N 198)
/* TCHK1 */  CALL       PGM(AFAR6Z)
/* TCHK1 */  DLTOVR     QPRINT

             ENDPGM

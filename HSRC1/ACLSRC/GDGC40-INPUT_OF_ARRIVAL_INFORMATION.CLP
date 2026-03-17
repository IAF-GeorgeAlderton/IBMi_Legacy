             PGM
             /** GDGC40 ************************/
             /* INPUT OF ARRIVAL INFORMATION   */
             /*   G.B.C             97/02/24   */
             /*   TCHK1 CHG OUTQ    06/02/13   */
             /************************ GDGC40 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

/* TCHK1     CHGJOB     OUTQ(&PRTG)                                 */
/* TCHK1     OVRPRTF    FILE(QPRINT) OVRFLW(51) OUTQ(&PRTG) +       */
/* TCHK1                  FORMTYPE(K6H1)                            */
/* TCHK1 */  OVRPRTF    FILE(QPRINT) OVRFLW(51) OUTQ(ASJOUTQ) +
/* TCHK1 */               FORMTYPE(K6H1)
             CALL       PGM(GDGR40) PARM(&USER)
             DLTOVR     FILE(*ALL)

             ENDPGM

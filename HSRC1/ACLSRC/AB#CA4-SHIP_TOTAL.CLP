             PGM
/** AB#CA4 ************************************************/
/* ..SHIP TOTAL                                           */
/*                                                        */
/* TCHK1 05/12/26                                         */
/* TCHK2 02/09/11 CHG QPRINTC --> QPRINTB                 */
/**********************************************************/
             DCL        VAR(&ID)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&YY)  TYPE(*DEC) LEN(4 0)
             DCL        VAR(&MM)  TYPE(*DEC) LEN(2 0)
             DCL        VAR(&SRT) TYPE(*CHAR) LEN(1)

             CRTDUPOBJ  OBJ(AB#WPA4) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
/* TCHK1 */  CRTDUPOBJ  OBJ(AB#WLA4) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
/* TCHK1 */  MONMSG     MSGID(CPF0000)

             CLRPFM QTEMP/AB#WPA4

             OVRDBF     FILE(AB#WPA4) TOFILE(QTEMP/AB#WPA4)
/* TCHK1 */  OVRDBF     FILE(AB#WLA4) TOFILE(QTEMP/AB#WLA4)

/* TCHK1     CALL       PGM(AB#RA4) PARM(&ID &YY &MM) */
/* TCHK1 */  CALL       PGM(AB#RA4) PARM(&ID &YY &MM &SRT)

             IF         COND(&ID  *EQ '9') THEN(GOTO CMDLBL(END))

             IF         COND(&SRT *EQ '1') THEN(DO)
/* TCHK2     OVRPRTF    FILE(QPRINT) OUTQ(QPRINTC) */
/* TCHK2 */  OVRPRTF    FILE(QPRINT) OUTQ(LANPRT09)
             CALL       PGM(AB#RA51) PARM(&YY &MM)
             ENDDO

             IF         COND(&SRT *EQ '2') THEN(DO)
/* TCHK2     OVRPRTF    FILE(QPRINT) OUTQ(QPRINTC) */
/* TCHK2 */  OVRPRTF    FILE(QPRINT) OUTQ(LANPRT09)
             CALL       PGM(AB#RA52) PARM(&YY &MM)
             ENDDO

             DLTOVR *ALL

   END:

             ENDPGM

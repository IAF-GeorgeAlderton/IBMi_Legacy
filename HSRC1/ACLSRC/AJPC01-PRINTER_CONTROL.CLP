             PGM
             /** AJPC01 ****************************************/
             /*   PRINTER CONTROL                              */
             /*            AUG/27/02                           */
             /*                                                */
             /* TCHK1 11/23/05 ADD CHECK OUTQ FOR LANPRT01     */
             /* TCHK2 10/09/08 RMV QPRINT CHECK                */
             /*                RMV QPRINTD START               */
             /* TCHK3 11/20/08 RMV QPRINTA START               */
             /* TCHK4 08/05/10 ADD LANPRT04,LANPRT09 CHECK     */
             /* TUCKER05/28/15 ADD QPRINT    %0001             */
             /**************************************** AJPC01 **/
             DCLF       FILE(AJPPW01)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US2) TYPE(*CHAR) LEN(2)

             RTVJOBA    USER(&US)
             CHGVAR     VAR(&US2) VALUE(%SUBSTRING(&US 1 2))
   STRT:
             CHGVAR     VAR(&SLCT) VALUE(0)

             SNDRCVF    RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))
             IF         COND(&SLCT *EQ 7) THEN(DO)
             WRKOUTQ    OUTQ(QPRINTA)
             ENDDO
  /* LANPRT03 */
             IF         COND(&SLCT *EQ 1) THEN(DO)
             WRKOUTQ    OUTQ(LANPRT03)
             ENDDO
 /* PB */
             IF         COND(&SLCT *EQ 58) THEN(DO)
             ENDWTR     WTR(QPRINTB) OPTION(*IMMED)
             MONMSG     MSGID(CPF3313)
             DLYJOB     DLY(2)
             STRPRTWTR  DEV(QPRINTB) OUTQ(QPRINTB) MSGQ(*DEVD)
             MONMSG    MSGID(CPF3310 CPF3396 CPF3347 CPF3363 CPF0000)

             ENDDO

             IF         COND(&SLCT *EQ 2) THEN(DO)
             WRKOUTQ    OUTQ(QPRINTB)
             ENDDO
 /* PC */
             IF         COND(&SLCT *EQ 59) THEN(DO)
             ENDWTR     WTR(QPRINTC) OPTION(*IMMED)
             MONMSG     MSGID(CPF3313)
             DLYJOB     DLY(2)
             STRPRTWTR  DEV(QPRINTC) OUTQ(QPRINTC) MSGQ(*DEVD)
             MONMSG    MSGID(CPF3310 CPF3396 CPF3347 CPF3363 CPF0000)

             ENDDO

             IF         COND(&SLCT *EQ 3) THEN(DO)
             WRKOUTQ    OUTQ(QPRINTC)
             ENDDO

             IF         COND(&SLCT *EQ 4) THEN(DO)
             WRKOUTQ    OUTQ(QPRINTD)
             ENDDO

/* TCHK4 */  IF         COND(&SLCT *EQ 5) THEN(DO)
             WRKOUTQ    OUTQ(LANPRT02)
             ENDDO

/* TCHK4 */  IF         COND(&SLCT *EQ 6) THEN(DO)
             WRKOUTQ    OUTQ(LANPRT09)
             ENDDO

/* %0001 */  IF         COND(&SLCT *EQ 8) THEN(DO)
             WRKOUTQ    OUTQ(QUSRSYS/QPRINT)
             ENDDO

             IF         COND(&SLCT *EQ 50) THEN(DO)
             WRKOUTQ    OUTQ(SAVEOUTQ)
             ENDDO
 /* P1 */
             IF         COND(&SLCT *EQ 60) THEN(DO)
             ENDWTR     WTR(QPRINT) OPTION(*IMMED)
             DLYJOB     DLY(2)
             STRPRTWTR  DEV(QPRINT) OUTQ(QUSRSYS/QPRINT) MSGQ(DSP01)
             MONMSG    MSGID(CPF3310 CPF3396 CPF3347 CPF3363 CPF0000)
             ENDDO

/* TCHK1 S */
  /* LANPRT01 */
             IF         COND(&SLCT *EQ 21) THEN(DO)
             WRKOUTQ    OUTQ(LANPRT01)
             ENDDO
/* TCHK1 E */

/* TCHK4 S */
  /* LANPRT04 */
             IF         COND(&SLCT *EQ 22) THEN(DO)
             WRKOUTQ    OUTQ(LANPRT04)
             ENDDO
  /* LANPRT07 */
             IF         COND(&SLCT *EQ 23) THEN(DO)
             WRKOUTQ    OUTQ(LANPRT07)
             ENDDO
/* TCHK4 E */

             GOTO       CMDLBL(STRT)
   END:

             ENDPGM

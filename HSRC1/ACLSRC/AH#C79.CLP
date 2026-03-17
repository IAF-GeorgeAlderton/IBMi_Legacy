/* TCHK1 02/27/07 RE-MAKE                                 */
/* TCHK2 03/08/07 CHG PRINT TO EMAIL                      */

 PGM         PARM(&PDAT &CPY &OUTQ)

             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPY)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(8)
/* TCHK2     DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8) */

             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
/* TCHK2 */  DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

/* TCHK2 */  RTVJOBA    JOB(&WS) USER(&USER) NBR(&NBR)

             CALL       PGM(APLC40)

/* *MATERIAL LIST* */
             CLRPFM     FILE(HWFILE1/AH#WP79)
             OVRDBF     FILE(AH#WP79) TOFILE(HWFILE1/AH#WP79)
             OVRDBF     FILE(AH#WL79) TOFILE(HWFILE1/AH#WL79)

/* TCHK2     OVRPRTF    FILE(QPRINT) RPLUNPRT(*YES) OUTQ(&OUTQ) +
                          FORMTYPE(K6H1) COPIES(&CPY) */
/* TCHK2 */  OVRPRTF    FILE(QPRINT) RPLUNPRT(*YES) OUTQ(QPRINT) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(AH#R79) PARM(&PDAT)

/* TCHK2 */  CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WS) SPLNBR(*LAST)
/* TCHK2 */  DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WS) +
                          SPLNBR(*LAST)
/* TCHK2 */  MONMSG     MSGID(CPF0000)

/* TCHK2 */  OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
/* TCHK2 */  CALL       PGM(AB#RW0)

/*JW*/
             IF         COND(&USER *EQ 'I0777') THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((KAZ.WATANABE@iafi.com)) +
                          DSTD('Priority Material List') +
                          MSG('Please check the Material list as +
                          attached.') DOCFILE(HWFILE1/PRT132B) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) +
                          DOCD('Priority Material list')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(PRT132)
             DLTOVR     FILE(QPRINT)
             ENDDO

 /* SNDDST */
             IF         COND(&USER *NE 'I0777') THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((PriorityFlagList@iafi.com) +
                          (TanebeK@iafi.com *CC)) DSTD('Priority +
                          Material List') MSG('Please check the +
                          Material list as attached.') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Priority Material +
                          list') /* TCHK2 */
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(PRT132)
             DLTOVR     FILE(QPRINT)
             ENDDO


/* *WASHER LIST* */
             CLRPFM     FILE(HWFILE1/AH#WP82)
             OVRDBF     FILE(AH#WP82) TOFILE(HWFILE1/AH#WP82)
             OVRDBF     FILE(AH#WL82) TOFILE(HWFILE1/AH#WL82)

             OVRPRTF    FILE(QPRINT) RPLUNPRT(*YES) OUTQ(QPRINT) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(AH#R82) PARM(&PDAT)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WS) SPLNBR(*LAST)
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WS) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

/*JW*/
             IF         COND(&USER *EQ 'I0777') THEN(DO)
             SNDDST     TYPE(*FILE) TOINTNET(                 +
                          (PriorityFlagList@iafi.com)         +
                          (TanebeK@iafi.com *CC)              +
                                               )              +
                          DSTD('Priority Washer List') MSG('Please +
                          check the Washer list as attached.') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Priority Washer list')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(PRT132)
             DLTOVR     FILE(QPRINT)
             ENDDO
 /* SNDDST */
             IF         COND(&USER *NE 'I0777') THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((PriorityFlagList@iafi.com) +
                          (TanebeK@iafi.com *CC)) DSTD('Priority +
                          Washer List') MSG('Please check the +
                          Washer list as attached.') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Priority Washer +
                          list') /* TCHK2 */
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(PRT132)
             DLTOVR     FILE(QPRINT)
             ENDDO

             DLTOVR     FILE(*ALL)

             ENDPGM

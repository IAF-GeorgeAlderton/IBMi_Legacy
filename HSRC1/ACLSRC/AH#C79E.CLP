/* TCHK1 02/27/07 RE-MAKE                                 */
/* TCHK2 03/08/07 CHG PRINT TO EMAIL                      */
/* JW1   2019.10.14 USE QTEMP FOR WORK FILE               */

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

   /*JW1     CLRPFM     FILE(HWFILE1/AH#WP79)                   */
   /*        OVRDBF     FILE(AH#WP79) TOFILE(HWFILE1/AH#WP79)   */
   /*        OVRDBF     FILE(AH#WL79) TOFILE(HWFILE1/AH#WL79)   */
   /*JW1 USE QTEMP  ** START **                                 */
             CRTDUPOBJ  OBJ(AH#WP79) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                           TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AH#WL79) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                           TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AH#WP79)
             OVRDBF     FILE(AH#WP79) TOFILE(QTEMP/AH#WP79)
             OVRDBF     FILE(AH#WL79) TOFILE(QTEMP/AH#WL79)
   /*JW1 USE QTEMP  ** END **                                   */

/* *MATERIAL LIST* */

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

/* TCHK2 */  SNDDST     TYPE(*FILE) TOINTNET(                 +
                          (PriorityFlagList@iafi.com)         +
                          (TanebeK@iafi.com *CC)              +
                                               )              +
                          DSTD('Priority Material List') MSG('Please +
                          check the Material list as attached.') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Priority Material list')
/* TCHK2 */  MONMSG     MSGID(CPF0000)
/* TCHK2 */  DLTOVR     FILE(PRT132)
/* TCHK2 */  DLTOVR     FILE(QPRINT)


   /*        CLRPFM     FILE(HWFILE1/AH#WP82)                   */
   /*        OVRDBF     FILE(AH#WP82) TOFILE(HWFILE1/AH#WP82)   */
   /*        OVRDBF     FILE(AH#WL82) TOFILE(HWFILE1/AH#WL82)   */
   /*JW1 USE QTEMP  ** START **                                 */
             CRTDUPOBJ  OBJ(AH#WP82) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                           TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AH#WL82) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                           TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AH#WP82)
             OVRDBF     FILE(AH#WP82) TOFILE(QTEMP/AH#WP82)
             OVRDBF     FILE(AH#WL82) TOFILE(QTEMP/AH#WL82)
   /*JW1 USE QTEMP  ** END **                                   */

/* *WASHER LIST* */

/* TCHK2     OVRPRTF    FILE(QPRINT) RPLUNPRT(*YES) OUTQ(&OUTQ) +
                          FORMTYPE(K6H1) COPIES(&CPY) */
/* TCHK2 */  OVRPRTF    FILE(QPRINT) RPLUNPRT(*YES) OUTQ(QPRINT) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(AH#R82) PARM(&PDAT)

/* TCHK2 */  CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WS) SPLNBR(*LAST)
/* TCHK2 */  DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WS) +
                          SPLNBR(*LAST)
/* TCHK2 */  MONMSG     MSGID(CPF0000)

/* TCHK2 */  OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
/* TCHK2 */  CALL       PGM(AB#RW0)

/* TCHK2 */  SNDDST     TYPE(*FILE) TOINTNET(                 +
                          (PriorityFlagList@iafi.com)         +
                          (TanebeK@iafi.com *CC)              +
                                               )              +
                          DSTD('Priority Washer List') MSG('Please +
                          check the Washer list as attached.') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Priority Washer list')
/* TCHK2 */  MONMSG     MSGID(CPF0000)
/* TCHK2 */  DLTOVR     FILE(PRT132)
/* TCHK2 */  DLTOVR     FILE(QPRINT)


             DLTOVR     FILE(*ALL)


             ENDPGM

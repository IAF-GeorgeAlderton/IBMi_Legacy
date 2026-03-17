  PGM
/** AB#C0B *************************************************/
/*  EDI ORDER PROCESSING (FORD)  FORD 862                  */
/*                                                         */
/* TCHK1 09/20/06 ADD CHECK(LAST CUM DATE & QTY) RTN       */
/* TCHK2 06/12/09 ADD TEMPORARY CHANGE CALENDAR M/F        */
/* JW1   02/25/16 ADD SAVE AB#EP50 TO AB#EP50S            */
/* LEC   10/24/16 ADD SEQUENCE DOWN ERROR LIST EMAIL      */
/* JW2   10/28/20 ADD SAVE ABF1P01 TO ABF1P01S            */
/* JWX   09/25/25 CHG FOR SWITCHING TO GENTRAN            */
/***********************************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT)  TYPE(*DEC) LEN(10 0)
/* TCHK1 */  DCL        VAR(&CNT1) TYPE(*DEC) LEN(10 0)

/* TCHK2 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK2 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK2 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVMBRD    FILE(AB#EP50) NBRCURRCD(&CNT)
             IF         COND(&CNT *EQ 0) THEN(GOTO CMDLBL(@END))

       /* JW1 2016.02.25 ADDED: SAVE AB#EP50 TO AB#EP50S */
       /* JWX CALL       PGM(EDSR50)   *******************/
       /* JWX EDSR50 RUNS IN AB#CBK    *******************/

    /* CLEAR 1PROCESS FILE */
             CLRPFM     FILE(ABF1P01)
             MONMSG     MSGID(CPF0000)

    /* CREATE 1PROCESS FILE */
             CALL       PGM(AB#R0E)

    /* PRINT DATA LIST */
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ)
             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1) /*JW*/
             CALL       PGM(AB#RF2)
             DLTOVR     FILE(QPRINT)

/* TCHK1 */  CLRPFM     FILE(ABFJP01)
/* TCHK1 */
             CPYF       FROMFILE(ABF1P01) TOFILE(ABFHP01) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
/*JW2*/
             CPYF       FROMFILE(ABF1P01) TOFILE(ABF1P01S) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)

    /* UPDATE FORD ORDER ACCUMULATE FILE */
             CALL       PGM(AB#RF7F4)

/* TCHK1 */  RTVMBRD    FILE(ABFJP01) NBRCURRCD(&CNT1)
/* TCHK1 */  IF         COND(&CNT1 *GT 0) THEN(DO)
/* TCHK1 */  CPYF       FROMFILE(ABFJP01) TOFILE(ABFJP02) +
/* TCHK1 */               MBROPT(*ADD) FMTOPT(*NOCHK)
/* TCHK1 */  ENDDO

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/*JW*/       OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1 ) FORMTYPE(K6H1) +
                          HOLD(*YES) SAVE(*YES)

    /* PRINT FORD PLANT & DOCK NEW REPORT */
             CALL       PGM(AB#RFN) PARM(&PD)

             IF         COND(&PD *NE ' ') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             RLSSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

/* TCHK1 */  SNDDST     TYPE(*FILE) +
                          TOINTNET((FordOrderError@iafi.com)) +
                          DSTD('FORD error List') MSG('Please check +
                          the attached list.') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('FORD Error list')
             DLTOVR     FILE(PRT132)
             ENDDO

    /* PRINT FORD SEQUENCE DOWN AND EMAIL */

             IF         COND(&CNT1 *GT 0) THEN(DO)

             CHGVAR     VAR(&PD) VALUE(' ')
             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1 ) FORMTYPE(K6H1) +
                          HOLD(*YES) SAVE(*YES)

             CALL       PGM(AB#RF@) PARM(&PD)

             IF         COND(&PD *NE ' ') THEN(DO)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             RLSSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((FordOrderError@iafi.com)) +
                          DSTD('FORD Sequence Down') MSG('Please check +
                          the attached list.') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('FORD Sequence Down')
             DLTOVR     FILE(PRT132)
             ENDDO
             ENDDO

     /* JWX SAVE EDI862 LOG */
             CALL       PGM(CHKR61D) PARM(' ')

/********************************************************************/

             CLRPFM     FILE(AB#EP50)

             DLTOVR     FILE(*ALL)
@END:
             ENDPGM

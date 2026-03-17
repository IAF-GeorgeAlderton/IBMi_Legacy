  PGM
/** AN#C0B ************************************************/
/*  ANDROID EDI ORDER PREPARE PROCESS                     */
/*                                                        */
/* TCHK1 07/10/06 CREATE(COPY FROM AB#C0B)                */
/* TCHK2 10/03/06 ADD SEND DATA LIST                      */
/* TCHK3 06/12/09 ADD TEMPORARY CHANGE CALENDAR M/F       */
/**********************************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)

             RTVMBRD    FILE(AB#EP51) NBRCURRCD(&CNT)
             IF         COND(&CNT *EQ 0) THEN(GOTO CMDLBL(@END))


/* TCHK3 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK3 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK3 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

/* TCHK2 */  RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* CLEAR 1PROCESS FILE */
             CLRPFM     FILE(ABR1P01)
             MONMSG     MSGID(CPF0000)

/* CREATE 1PROCESS FILE */
             CALL       PGM(AN#R0E)

/* PRINT DATA LIST */
/* TCHK2     OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) */
/* TCHK2 */  OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) SAVE(*YES)
/* TCHK2 */
             CALL       PGM(AN#RF2)
/* TCHK2 */
/* TCHK2 */  CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132) +
/* TCHK2 */               JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
/* TCHK2 */
/* TCHK2 */  OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132)
/* TCHK2 */  CALL       PGM(AB#RW0)
/* TCHK2 */  DLTOVR     FILE(PRT132)
/* TCHK2 */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((AndroidOrder@iafi.com)) +
                          DSTD('Android order information') MSG('We +
                          received the order information from +
                          Android. Please check the attachedlist. +
                          (AN#C0B)') DOCFILE(HWFILE1/PRT132) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('Android +
                          order information') /* TCHK2 */
/* TCHK2 */
             DLTOVR     FILE(QPRINT)

/*                 */
             CPYF       FROMFILE(ABR1P01) TOFILE(ABRHP01) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(AN#RF7F4)

             CLRPFM     FILE(AB#EP51)

             DLTOVR     FILE(*ALL)
@END:

             ENDPGM

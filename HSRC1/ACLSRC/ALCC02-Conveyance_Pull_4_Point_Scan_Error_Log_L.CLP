/* TCHK2 */ PGM  PARM(&SHFT &SCDT &RFLG &PRTR)
/** ALCC02 ************************************************/
/*  CONVEYANCE PULL 3-POINT SCAN ERROR LOG LIST           */
/*                                                        */
/* TCHK1 04/22/09 CREATE                                  */
/* TCHK2 06/29/09 ADD FOR MANUAL PRINT                    */
/* TCHK3 10/16/09 ADD AUTO PROCESS SEND LIST VIA E-MAIL   */
/* LEC   06/21/18 ADD PRINTER SELECTION                   */
/**********************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             DCL        VAR(&SHFT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SCDT)  TYPE(*CHAR) LEN(8)
/* TCHK2 */  DCL        VAR(&RFLG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTR)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* TCHK3 */  IF         (&SCDT *EQ '        ') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ)   +
                            PAGESIZE(66 132) LPI(6)   +
                            OVRFLW(60) FORMTYPE(K6H1) +
                            HOLD(*YES)
             ENDDO
             ELSE DO
             IF         COND(&PRTR *EQ '2') THEN(OVRPRTF +
                          FILE(QPRINT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) OUTQ(LANPRT31) FORMTYPE(K6H1))
             IF         COND(&PRTR *EQ '1') THEN(OVRPRTF +
                          FILE(QPRINT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) OUTQ(LANPRT10) FORMTYPE(K6H1))
             ENDDO

/* TCHK2 */  CALL       PGM(ALCR02) PARM(&SHFT &SCDT &RFLG)
/* TCHK3 */  IF         (&SCDT *EQ '        ') THEN(DO)
             IF         (&RFLG *EQ '1') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)
             SNDDST     TYPE(*FILE) TOINTNET((Conveyance@iafi.com)) +
                          DSTD('Conveyance 3 point error Log List') +
                          MSG('Please check attached list. +
                          (ALCC02)') DOCFILE(HWFILE1/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) +
                          DOCD('Conveyance 3 point error Log List.')
             DLTOVR     FILE(PRT132)
             ENDDO
             ENDDO

             DLTOVR     FILE(*ALL)

 ENDPGM

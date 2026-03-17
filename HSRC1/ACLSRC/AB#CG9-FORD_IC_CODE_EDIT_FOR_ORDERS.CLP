             PGM

/** AB#CG9 *************************************************/
/*  IC CODE EDIT FOR FORD ORDERS                           */
/*                                                         */
/************************************** AB#CG9 *************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT)  TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/******************************************************************************/
/* run program to list all ic codes not found in Ford route master.           */

             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1) FORMTYPE(K6H1) +
                          HOLD(*YES) SAVE(*YES)

             CALL       PGM(AB#RG9) PARM(&PD)

/******************************************************************************/
/* if edi data contains plant/dock/ic code combos that are not in Ford Route  */
/*    Master, then copy spool list file to a data file so it can be emailed.  */

             IF         COND(&PD *NE ' ') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             RLSSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

/******************************************************************************/
/* run program to add cr/lf to list file created above.                       */

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

/******************************************************************************/
/* and send email to distribution list.                                       */

             SNDDST     TYPE(*FILE) +
                          TOINTNET((FordOrderError@iafi.com)) +
                          DSTD('FORD Missing Plant/Dock/IC Code +
                          List') MSG('Please check the attached +
                          list.') DOCFILE(HWFILE1/PRT132B) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('FORD +
                          Missing Plant/Dock/IC Code List')

/******************************************************************************/

                                            ENDDO


             DLTOVR     FILE(*ALL)
@END:

             ENDPGM

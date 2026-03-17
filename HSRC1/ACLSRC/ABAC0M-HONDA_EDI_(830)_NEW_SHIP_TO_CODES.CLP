             PGM

/** ABAC0M *************************************************/
/*  HONDA EDI 850, 862 NEW SHIP TO CODE LIST               */
/*   LEC                2016.11.15                         */
/************************************** ABAC0M *************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT)  TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/******************************************************************************/
/* run program to list all ship-to codes in honda forecast that are not       */
/* currently known by programs and is not in honda files.                     */

             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) OUTQ(EPRINT1) +
                          FORMTYPE(K6H1) HOLD(*YES) SAVE(*YES)

             CALL       PGM(ABAR0M)

/******************************************************************************/
/*  edi data contains ship to codes that are not found in prgms and not in    */
/*    Honda ship to master. list work file in report, so it can be emailed.   */

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT198) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             RLSSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

/******************************************************************************/
/* run program to add cr/lf to list file created above.                       */

             CALL       PGM(AB#RW1)

/******************************************************************************/
/* and send email to distribution list.                                       */

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('Honda-ASN-Support@iafi.com')) +
                          DSTD('Honda EDI Forecast with New Ship To +
                          Codes') MSG('Please check the attached +
                          list. (ABAC0M)') DOCFILE(HWFILE1/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('Honda +
                          EDI Forecast New Ship To Codes')

/******************************************************************************/



             DLTOVR     FILE(*ALL)
@END:

             ENDPGM

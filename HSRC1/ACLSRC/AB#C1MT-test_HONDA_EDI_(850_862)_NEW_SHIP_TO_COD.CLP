             PGM

/** AB#C1M *************************************************/
/*  HONDA EDI 850, 862 NEW SHIP TO CODE LIST               */
/*   LEC                2016.11.14                         */
/************************************** AB#C1M *************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT)  TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/******************************************************************************/
/* run program to list all ship-to codes in honda orders that are not         */
/* currently known by programs and is not in honda files.                     */
/*                                                                            */
/*           OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) OUTQ(EPRINT1) +         */
/*                        FORMTYPE(K6H1) HOLD(*YES) SAVE(*YES)                */
/*                                                                            */
/*           CALL       PGM(AB#R1M)                                           */
/*                                                                            */
/******************************************************************************/
/*  edi data contains ship to codes that are not found in prgms and not in    */
/*    Honda ship to master. list work file in report, so it can be emailed.   */
/*                                                                            */
/*           CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT198) +                 */
/*                        JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)                 */
/*           RLSSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +                  */
/*                        SPLNBR(*LAST)                                       */
/*           MONMSG     MSGID(CPF0000)                                        */
/*                                                                            */
/******************************************************************************/
/* run program to add cr/lf to list file created above.                       */

             OVRDBF     FILE(PRT198) TOFILE(HWFILE1/PRT198)
             CALL       PGM(AB#RW1)

/******************************************************************************/
/* and send email to distribution list.                                       */

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('Honda-ASN-Support@iafi.com')) +
                          DSTD('Honda EDI Orders with New Ship To +
                          Codes') MSG('** CRITICAL ERROR ** Please +
                          check the attached list. (AB#C1M)') +
                          DOCFILE(HWFILE1/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Honda EDI Orders New +
                          Ship To Codes')

/******************************************************************************/
/*           CLRPFM     FILE(AB#WP90)                                         */
/*           MONMSG     MSGID(CPF0000)                                        */
             DLTOVR     FILE(*ALL)
@END:

             ENDPGM

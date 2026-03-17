             PGM
/** AB#C6L ************************************************/
/*  FORD ACCOUNT PAYABLE LIST                             */
/*                                                        */
/* JW    2017.07.14 COPIED FROM AB#C6J                    */
/*                  PROCESS FOR FORD ONLY                 */
/**********************************************************/

             DCL        VAR(&CN3)  TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&CN4)  TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&CN5)  TYPE(*DEC)  LEN(10 0)

             RTVMBRD    FILE(AB#PP6L) NBRCURRCD(&CN3)
             RTVMBRD    FILE(AB#PP6K) NBRCURRCD(&CN4)
             RTVMBRD    FILE(AB#PP6J) NBRCURRCD(&CN5)

             IF         COND(&CN3 *GT 0 *OR &CN4 *GT 0 *OR &CN5 *GT 0) +
                        THEN(DO)

/* JW CHG MESSAGE */
             SNDDST     TYPE(*LMSG) +
                          TOINTNET((EDI820REMITTANCEADVICE@iafi.com)) +
                          DSTD('FORD EDI Remittance Advice (820)') +
                          LONGMSG('FORD EDI remittance advice has +
                          been processed. Please check the FORD +
                          INQUIRY MENU - 01. FORD NOTE INQ. +
                          (AB#C6L)') DOCDATE(*NONE) ALWALTRCP(*NO)

             CALL       PGM(AB#R6P)
             ENDDO

        /* NO MORE AUTOMATICALLY PRINT          */
        /*   CALL       PGM(AB#R6J) PARM(&TIM)  */

             ENDPGM

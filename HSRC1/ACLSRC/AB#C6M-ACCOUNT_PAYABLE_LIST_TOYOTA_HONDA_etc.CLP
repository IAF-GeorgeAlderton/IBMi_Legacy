             PGM
/** AB#C6M ************************************************/
/*  TOYOTA/HONDA ACCOUNT PAYABLE LIST (EDI820)            */
/*                                                        */
/* JW    2017.07.14 COPIED FROM AB#C6J                    */
/*                  PROCESS FOR TOYOTA, HONDA ETC...      */
/**********************************************************/
             DCL        VAR(&TIM)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&TIM2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CNT)  TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&CN2)  TYPE(*DEC)  LEN(10 0)

             RTVMBRD    FILE(AB#PP6D) NBRCURRCD(&CNT)
             RTVMBRD    FILE(AB#PP6E) NBRCURRCD(&CN2)

             IF         COND(&CN2 *EQ 0) THEN(RTVMBRD FILE(AB#PP6F) +
                          NBRCURRCD(&CN2))

             IF         COND(&CNT *GT 0 *OR &CN2 *GT 0) THEN(DO)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET((EDI820REMITTANCEADVICE@iafi.com)) +
                          DSTD('EDI Remittance Advice (820)') +
                          LONGMSG('EDI remittance advice has been +
                          processed. Please check the menu screen +
                          and printed list. - TOYOTA/HONDA +
                          (AB#C6M).') DOCDATE(*NONE) ALWALTRCP(*NO)
             ENDDO


        /* NO MORE FORD transaction             */
        /*   CALL       PGM(AB#R6P)             */

        /* NO MORE AUTOMATICALLY PRINT          */
        /*   CALL       PGM(AB#R6J) PARM(&TIM)  */
        /*   DLYJOB     DLY(1)                  */

             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03) FORMTYPE(K6H1)
             CALL       PGM(AB#R6G) PARM(&TIM)
             CALL       PGM(AB#R6L) PARM(&TIM2)
             CALL       PGM(AB#R6M) PARM(&TIM2)
             DLTOVR     FILE(QPRINT)

             ENDPGM

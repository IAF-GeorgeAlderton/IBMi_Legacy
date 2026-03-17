  PGM
/** AB#CBK ********************************************/
/*  GENTRAN WORK FILE (BACKUP FOR B2B)                */
/*      T.SAKAKI        06/07/2017                    */
/*      J.WATANABE      06/22/2017  ADD EDSR80        */
/*      J.WATANABE      12/06/2021  ADD AB#C0E2       */
/* JW3  J.WATANABE      03/27/2025  ADD UNIVERSAL EDI */
/* JWX  J.WATANABE      09/25/2025  SWITCH TO GENTRAN */
/******************************************************/
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

     /*  TIME STAMP  */
             CALL       PGM(UTLR07D) PARM('AB#CBK    ' 'GENEDI')

     /*---------------------------------------*/
     /*  FORD 856 ASN INBOUND  06/09/2017     */
     /*---------------------------------------*/
     /** SAVE AB#EP41 TO AB#EP41S **/
             RTVMBRD    FILE(AB#EP41) NBRCURRCD(&REC)
             IF         COND(&REC *GT 0) THEN(DO)
             CALL       PGM(EDSR41)

/*** #STOP (RUN GENTRN)  **********************/
/**JWX       CLRPFM     FILE(AB#EP41)        **/
/**********************************************/

             ENDDO
     /*---------------------------------------*/
     /*  FORD 830 FORECAST 06/22/2017         */
     /*---------------------------------------*/
             RTVMBRD    FILE(ABAEP10) NBRCURRCD(&REC)
             IF         COND(&REC *GT 0) THEN(DO)
        /* SAVE ABAEP10 TO ABAEP10S */
        /*      ABAEP11 TO ABAEP11S */
             CALL       PGM(EDSR21)

/*** #STOP (RUN GENTRN)  **********************/
/**JWX       CLRPFM     FILE(ABAEP10)        **/
/**          CLRPFM     FILE(ABAEP11)        **/
/**********************************************/

             ENDDO
     /*---------------------------------------*/
     /*  FORD 862 ORDER    06/23/2017         */
     /*---------------------------------------*/
             RTVMBRD    FILE(AB#EP50) NBRCURRCD(&REC)
             IF         COND(&REC *GT 0) THEN(DO)
/* SAVE AB#EP50 TO AB#EP50S */
             CALL       PGM(EDSR50)

/* JW SET BATCH# IN ABF2P01        */
             CALL       PGM(EB#R0F)

/*JW2 CREATE ABF5P01 **/
             CALL       PGM(AB#C0E2)

/* JW3 UNIVERSAL EDI ORDER          */
             CALL       PGM(AB#C12F)

/***JWX      CLRPFM     FILE(AB#EP50)       ***/

             ENDDO
     /*---------------------------------------*/
     /*  FORD 861 ORDER    06/21/2017 (JW)    */
     /*---------------------------------------*/
             RTVMBRD    FILE(AB#EP80) NBRCURRCD(&REC)
             IF         COND(&REC *GT 0) THEN(DO)
        /* SAVE AB#EP80 TO AB#EP80S */
             CALL       PGM(EDSR80)

/*** #STOP TO RUN GENTRN **********************/
/**JWX       CLRPFM     FILE(AB#EP80)        **/
/**********************************************/

             ENDDO
     /*---------------------------------------*/
     /*  FORD XXX INBOUND  XXXXXXXXXXXXX      */
     /*---------------------------------------*/

             ENDPGM

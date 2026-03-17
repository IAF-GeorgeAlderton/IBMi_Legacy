             PGM        PARM(&LIBL &FILE)
             /** EJRC14 *******************************************/
             /* R820FORD (REMITTANCE ADV) CREATE EB#PP6J/6K/6L    */
             /* J.WATANABE  2017.04.21                            */
             /* --------------------------                        */
             /* J.WATANABE  2018.05.10 JW1 COMMENT OUT EJRR15     */
             /* J.WATANABE  2020.11.19 JW2 ADD #STOP              */
             /*---------------------------------------------------*/
             /* WORKFILE -> EB#PP6J--ORIGINAL FILE IS AB#PP6JS    */
             /*          -> EB#PP6K--ORIGINAL FILE IS AB#PP6KS    */
             /*          -> EB#PP6L--ORIGINAL FILE IS AB#PP6LS    */
             /*****************************************************/
             DCL        VAR(&LIBL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

     /*** JW2 #STOP TO RUN GENTRAN ***************/
     /***    GOTO       CMDLBL(ENDP)           ***/
     /********************************************/

     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)


     /*-----------------------------------------------*/
     /* COPY R820 TO EB#PP6A (FLAT DATA)              */
     /*-----------------------------------------------*/
             CLRPFM     FILE(&WLIB/EB#PP6A)
             OVRDBF     FILE(R820) TOFILE(&LIBL/&FILE)
             CALL       PGM(EJRR16)

     /*-----------------------------------------------*/
     /* READ EB#PP6A (FLAT DATA)                      */
     /* CREATE EB#PP6J/K/L                            */
     /*-----------------------------------------------*/
             CLRPFM     FILE(&WLIB/EB#PP6J)
             CLRPFM     FILE(&WLIB/EB#PP6K)
             CLRPFM     FILE(&WLIB/EB#PP6L)
             CALL       PGM(EJRR14)

     /*-----------------------------------------------*/
     /* SAVE EB#PP6J/K/L TO EB#PP6P/Q/R               */
     /*-----------------------------------------------*/
     /*JW1   CALL       PGM(EJRR15)                   */

     /*-----------------------------------------------*/
     /* SAVE EB#PP6J/K/L TO AB#PP6J/K/L               */
     /* (RELEASE AFTER MIGRATION TO B2B)              */
     /*-----------------------------------------------*/
             CALL       PGM(EJRR17)

     /*-----------------------------------------------*/
     /* ACCOUNT PAYABLE PROCESS                       */
     /* (RELEASE AFTER MIGRATION TO B2B)              */
     /*-----------------------------------------------*/
             CALL       PGM(AB#C6L)

             CLRPFM     FILE(&PLIB/AB#PP6J)
             CLRPFM     FILE(&PLIB/AB#PP6K)
             CLRPFM     FILE(&PLIB/AB#PP6L)

             DLTOVR     FILE(*ALL)

     /*---------------------------------------------------------*/
     /* SAVE FORD820 WORK FILE AB#PP6J/6K/6L TO AB#PP6JS/6KS/6LS*/
     /*---------------------------------------------------------*/
     /*      CALL       PGM(EDSR66)                             */

ENDP:        ENDPGM

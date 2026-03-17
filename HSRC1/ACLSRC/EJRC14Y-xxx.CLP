             PGM        PARM(&LIBL &FILE)
             /** EJRC14 *******************************************/
             /* R820FORD (REMITTANCE ADV) CREATE EB#PP6J/6K/6L    */
             /* J.WATANABE  2017.04.21                            */
             /*****************************************************/
             DCL        VAR(&LIBL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

     /*-----------------------------------------------*/
     /* COPY R820 TO EB#PP6A (FLAT DATA)              */
     /*-----------------------------------------------*/
             CLRPFM     FILE(&PLIB/EB#PP6A)
             OVRDBF     FILE(R820) TOFILE(&LIBL/&FILE)
             CALL       PGM(EJRR16)

     /*-----------------------------------------------*/
     /* READ EB#PP6A (FLAT DATA)                      */
     /* CREATE EB#PP6J/K/L                            */
     /*-----------------------------------------------*/
             CLRPFM     FILE(&PLIB/EB#PP6J)
             CLRPFM     FILE(&PLIB/EB#PP6K)
             CLRPFM     FILE(&PLIB/EB#PP6L)
             CALL       PGM(EJRR14)

     /*-----------------------------------------------*/
     /* SAVE EB#PP6J/K/L TO EB#PP6P/Q/R               */
     /*-----------------------------------------------*/
         /** CLRPFM     FILE(&PLIB/EB#PP6P)  **/
         /** CLRPFM     FILE(&PLIB/EB#PP6Q)  **/
         /** CLRPFM     FILE(&PLIB/EB#PP6R)  **/
             CALL       PGM(EJRR15)

     /*-----------------------------------------------*/
     /* SAVE EB#PP6J/K/L TO AB#PP6J/K/L               */
     /*-----------------------------------------------*/
/*TEST       CALL       PGM(EJRR17)                          */

     /*-----------------------------------------------*/
     /* CLEAR EB#PP6J/K/L                             */
     /*-----------------------------------------------*/
 /*TEST      CLRPFM     FILE(&PLIB/EB#PP6J)              */
 /*TEST      CLRPFM     FILE(&PLIB/EB#PP6K)              */
 /*TEST      CLRPFM     FILE(&PLIB/EB#PP6L)              */

             DLTOVR     FILE(*ALL)

     /*-----------------------------------------------*/
     /* ACCOUNT PAYABLE PROCESS                       */
     /* (RELEASE AFTER MIGRATION TO B2B)              */
     /*-----------------------------------------------*/
     /**     CALL       PGM(EB#C6J)        **/

             ENDPGM

             PGM
   /** ABFC41 ******************************************/
   /* PROCESS FORD INCOMING ASN DATA                   */
   /*   FROM GENTRAN                                   */
   /* LEC   01/12/16                                   */
   /* JW1   2020.11.19  ADD #STOP FOR B2B              */
   /******************************** ABFC41 ************/

    /** #STOP TO RUN B2B   ***********************/
             GOTO       CMDLBL(ENDP)
    /*********************************************/

   /*------------------------*/
   /*  ..FORD   EDI(856) ..  */
   /*------------------------*/

   /*  Write Incoming Work File to FORD ASN File - ABFPP41.           */
             CALL       PGM(ABFR41)

   /*  Clear Incoming Work File.                                      */
             CLRPFM     FILE(AB#EP41)
 ENDP:
             ENDPGM

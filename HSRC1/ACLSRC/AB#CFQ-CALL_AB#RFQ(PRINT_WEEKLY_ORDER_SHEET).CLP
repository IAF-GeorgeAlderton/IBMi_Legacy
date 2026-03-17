             PGM
             /** AB#CFQ **************************************/
             /* CALL AB#RFQ(PRINT WEEKLY ORDER SHEET)        */
             /* K.KASHIWAGI 2001.02.23                       */
             /************************************** AB#CFS **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USID)

             CALL       PGM(AB#RFQ) PARM(&USID)

 END:
             ENDPGM

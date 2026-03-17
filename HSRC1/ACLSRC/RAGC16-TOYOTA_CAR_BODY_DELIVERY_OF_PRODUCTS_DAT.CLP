             PGM
             /** RAGC16 *******************************/
             /* ...TOYOTA CAR BODY DELIVERY OF PRODUCTS DATA CREATE ... */
             /*           ORDER RECEIPT DATA INPUT ... */
             /*              DISKETT & ERROR LIST ... */
             /* I-HASADA                83.03.24      */
             /******************************* RAGC16 **/
             DCL        VAR(&KUBN) TYPE(*CHAR) LEN(1)
             CALL       PGM(RAGR17) PARM(&KUBN)
             ENDPGM

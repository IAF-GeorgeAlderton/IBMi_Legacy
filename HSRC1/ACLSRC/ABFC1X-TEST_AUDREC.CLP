             PGM
             /** ABFC1X ********************/
             /* TEST AUDREC                */
             /*  T-SAKAKI      2017.02.01  */
             /******************** ABFC1X **/

             ADDLIBLE   LIB(G3X6DTA)

             CALL       PGM(ABFR1X)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM

             PGM
             /** AB#C12F ***********************************/
             /*  TEST AB#R12F                              */
             /*  JW     2025.03.19                         */
             /**********************************************/

     /****** CLRPFM     FILE(AB#EP12)    ******/
     /****** CLRPFM     FILE(AB#EP13)    ******/

             OVRDBF     FILE(AB#EL50A) TOFILE(TFILE1/AB#EL50A)
             OVRDBF     FILE(AB#PLF1G) TOFILE(TFILE1/AB#PLF1G)

             CALL       PGM(AB#R12F)

 END:        ENDPGM

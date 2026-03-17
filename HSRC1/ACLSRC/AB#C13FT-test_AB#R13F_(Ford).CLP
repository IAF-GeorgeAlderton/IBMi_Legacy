             PGM
             /** AB#C13FT **********************************/
             /*  TEST AB#R13F (FORD)                       */
             /*  JW   2025.05.07                           */
             /**********************************************/

    /***     CLRPFM     FILE(AB#EP14)  ***/

             OVRDBF     FILE(AB#EP66 ) TOFILE(TFILE1/AB#EP66 )

             CALL       PGM(AB#R13F)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM

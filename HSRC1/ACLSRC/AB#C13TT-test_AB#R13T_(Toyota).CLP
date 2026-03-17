             PGM
             /** AB#C13T ***********************************/
             /*  TEST AB#R13T                              */
             /*  JW     2025.05.02                         */
             /**********************************************/

    /*****   CLRPFM     FILE(AB#EP14)   ****/

             OVRDBF     FILE(AB#EP60 ) TOFILE(TFILE1/AB#EP60 )

             CALL       PGM(AB#R13T)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM

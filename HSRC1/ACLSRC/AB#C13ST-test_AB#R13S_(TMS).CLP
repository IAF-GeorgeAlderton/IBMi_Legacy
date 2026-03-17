             PGM
             /** AB#C13S ***********************************/
             /*  TEST AB#R13S                              */
             /*  JW     2025.05.15                         */
             /**********************************************/

    /*****   CLRPFM     FILE(AB#EP14)   ****/

             OVRDBF     FILE(AC#EP70 ) TOFILE(TFILE1/AC#EP70 )

             CALL       PGM(AB#R13S)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM

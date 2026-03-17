             PGM
             /** AB#C12H ***********************************/
             /*  TEST AB#R12H                              */
             /*  JW     2025.03.18                         */
             /**********************************************/

/******      CLRPFM     FILE(AB#EP12)    ****/
/******      CLRPFM     FILE(AB#EP13)    ****/

             OVRDBF     FILE(AB#EL90) TOFILE(TFILE1/AB#EL90)

             CALL       PGM(AB#R12H)

 END:        ENDPGM

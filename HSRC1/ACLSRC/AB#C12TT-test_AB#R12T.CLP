             PGM
             /** AB#C12T ***********************************/
             /*  TEST AB#R12T                              */
             /*  JW     2025.03.20                         */
             /**********************************************/

         /***CLRPFM     FILE(AB#EP12)  **/
         /***CLRPFM     FILE(AB#EP13)  **/

             OVRDBF     FILE(AB#EL40 ) TOFILE(TFILE1/AB#EL40 )

             CALL       PGM(AB#R12T)

 END:        ENDPGM

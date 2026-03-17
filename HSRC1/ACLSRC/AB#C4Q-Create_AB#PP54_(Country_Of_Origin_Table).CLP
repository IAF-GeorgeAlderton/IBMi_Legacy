             PGM
             /** AB#C4Q   *********************************************/
             /*  CREATE AB#PP54 (COUNTRY OF ORIGIN TABLE)             */
             /*  JW   2024.05.08                                      */
             /*********************************************************/

             CLRPFM     FILE(HWFILE1/FBCWP01)

             CALL       AB#R4Q1

             CLRPFM     FILE(HFILE1/AB#PP54)

             CALL       AB#R4Q

             ENDPGM

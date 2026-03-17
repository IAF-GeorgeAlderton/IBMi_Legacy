             PGM
             /** AB#C0GM *********************************************/
             /*  MOVE ABWEP70 TO AB#EP70                             */
             /*  J.WATANABE  2021.07.20                              */
             /********************************************************/

             OVRDBF     FILE(ABWEP70 ) TOFILE(TWFILE2/ABWEP70 )
             OVRDBF     FILE(AB#EL70 ) TOFILE(TFILE3/AB#EL70 )

             CALL       PGM(AB#R0GM)

             ENDPGM

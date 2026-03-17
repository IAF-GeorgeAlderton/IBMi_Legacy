             PGM
             /** CLRC01  *********************************************/
             /*  TEST CLRR01                                         */
             /*  J.WATANABE 2026.01.06                               */
             /********************************************************/

             OVRDBF     FILE(AB#EP66) TOFILE(TFILE1/AB#EP66)
             OVRDBF     FILE(AB#EP63) TOFILE(TFILE1/AB#EP63)
             OVRDBF     FILE(AB#EP64) TOFILE(TFILE1/AB#EP64)
             OVRDBF     FILE(AB#EP65) TOFILE(TFILE1/AB#EP65)

             CALL       PGM(HOBJ1/CLRR01 )

             ENDPGM

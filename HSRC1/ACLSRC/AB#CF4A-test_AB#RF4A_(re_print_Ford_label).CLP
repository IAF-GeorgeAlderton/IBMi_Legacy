             PGM
             /** AB#CF4A ******************************************************/
             /*  TEST AB#RF4A (RE-PRINT FORD LABEL)                           */
             /*****************************************************************/

             CLRPFM     FILE(TWFILE1/ABF7P01)
             CLRPFM     FILE(TWFILE1/ABF7P02)
             CLRPFM     FILE(TWFILE1/ABF7P03)
             CLRPFM     FILE(TFILE1/AB#PP70)
             CLRPFM     FILE(TFILE1/AB#XP01A)

             OVRDBF     FILE(ABF7P01) TOFILE(TWFILE1/ABF7P01)
             OVRDBF     FILE(ABF7P02) TOFILE(TWFILE1/ABF7P02)
             OVRDBF     FILE(ABF7P03) TOFILE(TWFILE1/ABF7P03)
             OVRDBF     FILE(AB#NP30) TOFILE(TFILE1/AB#NP30)
             OVRDBF     FILE(AB#PP70) TOFILE(TFILE1/AB#PP70)
             OVRDBF     FILE(AB#XP01A) TOFILE(TFILE1/AB#XP01A)

             CALL       PGM(AB#RF4A)

             ENDPGM

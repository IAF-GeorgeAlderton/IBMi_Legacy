             PGM
             /** ABTC32T *********************************************/
             /********************************************************/

             CLRPFM     FILE(TWFILE1/ABTWP32)

             OVRDBF     FILE(ABTWP31) TOFILE(HWFILE1/ABTWP31)
             OVRDBF     FILE(ABTWP32) TOFILE(TWFILE1/ABTWP32)

             CALL       PGM(ABTR32 ) PARM('7')

 #END:       ENDPGM

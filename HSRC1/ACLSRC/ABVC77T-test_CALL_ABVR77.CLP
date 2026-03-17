/** ABVC77 ************************************************/
/*  VW SHIPPING VERIFICATION SCAN (FROM-TO)               */
/*  JW   2020.12.08                                       */
/**********************************************************/
 PGM
             OVRDBF AB#PL71
             OVRDBF     FILE(AB#PL71) TOFILE(TFILE1/AB#PL71 )
             OVRDBF     FILE(ABVPP75) TOFILE(TFILE1/ABVPP75 )

             CALL      PGM(ABVR77)

 END:        ENDPGM

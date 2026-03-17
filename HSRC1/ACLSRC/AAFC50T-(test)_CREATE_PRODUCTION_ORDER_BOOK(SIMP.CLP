             PGM

             OVRPRTF    FILE(AAFPR50N) DEVTYPE(*SCS) PAGESIZE(68 +
                          132) LPI(6) CPI(5) RPLUNPRT(*YES) +
                          ALIGN(*YES) OUTQ(LANPRT03) FORMTYPE(@627) +
                          MAXRCDS(*NOMAX) IGCDTA(*NO)

             OVRDBF     FILE(AAFWP49) TOFILE(TWFILE1/AAFWP49)

             CALL       PGM(AAFR50N)

             ENDPGM

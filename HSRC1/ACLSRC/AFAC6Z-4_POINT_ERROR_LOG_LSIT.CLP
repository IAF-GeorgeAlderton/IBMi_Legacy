             PGM
             /** ALAC6Z ************************************/
             /*     4-POINT ERROR LOG LIST                 */
             /*                                            */
             /**********************************************/

             OVRPRTF    FILE(QPRINT) CPI(15) RPLUNPRT(*YES) +
                          OUTQ(LANPRT08) FORMTYPE(K6H1)     +
                          PAGESIZE(*N 198)
             CALL       PGM(AFAR6Z)

             ENDPGM

             PGM
             /** GDIC83 ************************/
             /*  PRINT ORDER  DATA FOR DIE     */
             /*  N.HYOTO 2001.04.26            */
             /**********************************/


             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) +
                          PAGESIZE(66 198) CPI(15) OUTQ(QPRINTB) +
                          HOLD(*NO)

             CALL       PGM(GDIR83)


 END:        ENDPGM

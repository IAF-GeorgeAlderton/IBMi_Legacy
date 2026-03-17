             PGM
             /**** GDIC15 *****************************************/
             /*  RE-PRINT DATA SUMMARY LIST (DIE)                 */
             /*  N.HYOTO    2001/06/20                            */
             /*****************************************************/

             /* PRINT OF KANBAN TOTAL LIST */
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03) FORMTYPE(K6H1)
             OVRDBF     FILE(GWIPL10) TOFILE(GDIPL10)
             CALL GDIR15
             DLTOVR *ALL

 END:        ENDPGM

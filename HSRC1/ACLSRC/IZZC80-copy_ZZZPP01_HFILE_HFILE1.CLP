             PGM
             /** IZZC80 *************************/
             /*  ZZZPP01 HFILE ==> HFILE1 CPYF  */
             /*   I-HASADA           97.04.05   */
             /************************* IZZC80 **/
             OVRDBF     FILE(ZZZPP01) TOFILE(HFILE1/ZZZPP01)
             CALL       PGM(IZZR80)
             DLTOVR     FILE(*ALL)
             ENDPGM

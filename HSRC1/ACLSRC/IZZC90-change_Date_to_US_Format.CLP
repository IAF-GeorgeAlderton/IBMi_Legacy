             PGM
             /** IZZC90 ************************************/
             /*  ..全ファイル西暦年（１９９６）に変更..  */
             /*      I-HASADA                96.12.05      */
             /************************************ IZZC90 **/
             OVRDBF     FILE(ZZZPP01) TOFILE(HFILE1/ZZZPP01)
             CALL       PGM(IZZR90)
             DLTOVR     FILE(*ALL)
             ENDPGM

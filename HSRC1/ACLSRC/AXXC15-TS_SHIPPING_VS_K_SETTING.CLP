             PGM
             /** AXXC15 ********************/
             /* TS SHIPPING VS K.SETTING   */
             /*  T-SAKAKI      2014.08.12  */
             /******************** AXXC15 **/

             OVRDBF     FILE(FILESA1) TOFILE(SAKAKI/QQRYOUT1)
             OVRDBF     FILE(FILESA2) TOFILE(SAKAKI/QQRYOUT2)

             CALL       PGM(AXXR16)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM

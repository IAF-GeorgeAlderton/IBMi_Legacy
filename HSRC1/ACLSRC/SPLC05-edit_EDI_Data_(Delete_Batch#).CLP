             PGM
       /* SPLC05 **********************************************/
       /* EDIT EDI DATA (DELETE BATCH#)                       */
       /* J.WATANABE  2024.03.13                              */
       /*******************************************************/

             CLRPFM     FILE(QTEMP/TXTP200)

             OVRDBF     FILE(TXT200)  TOFILE(QTEMP/TXT200  )
             OVRDBF     FILE(TXTP200) TOFILE(QTEMP/TXTP200)

             CALL SPLR05

             DLTOVR     FILE(*ALL)

             ENDPGM

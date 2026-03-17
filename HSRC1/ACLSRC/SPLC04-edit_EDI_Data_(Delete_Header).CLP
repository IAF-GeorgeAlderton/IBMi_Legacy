             PGM
       /* SPLC04 **********************************************/
       /* EDIT EDI DATA (DELETE HEADER)                       */
       /* J.WATANABE  2021.09.01                              */
       /*******************************************************/

             CLRPFM     FILE(QTEMP/TXTP200)

             OVRDBF     FILE(TXT200)  TOFILE(QTEMP/TXT200  )
             OVRDBF     FILE(TXTP200) TOFILE(QTEMP/TXTP200)

             CALL SPLR04

             DLTOVR     FILE(*ALL)

             ENDPGM

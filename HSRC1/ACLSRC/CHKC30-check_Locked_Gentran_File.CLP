             PGM
             /** CHKC30 *****************************/
             /*  CHECK LOCKED GENTRAN FILE          */
             /*  J.WATANABE 2016.04.25              */
             /***************************************/

             OVRPRTF    FILE(QPDSPOLK) USRDFNOPT('EDI_LOCK')

 /* HONDA ASN */
             WRKOBJLCK  OBJ(HFILE1/AB#EP59) OBJTYPE(*FILE) +
                          OUTPUT(*PRINT)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM

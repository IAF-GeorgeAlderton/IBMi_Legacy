             PGM
             /** ABMC65 ************************/
             /* AUTO SETTING BACKUP作成      */
             /*   Y.MAEDA          2021.07.19  */
             /**********************************/

             /***************************************************/
             /*  SAVE FILES ARE CREATED BY THE PROGRAM ABMC62   */
             /***************************************************/

             SNDNETF    FILE(HFILE1/ABMPPBK) +
                        TOUSRID((QFILE SYSTEM1))

             SBMNETJOB  FILE(HSRC1/ACLSRC)  +
                        TOUSRID((QFILE SYSTEM1)) MBR(ABMT63)

 END:        ENDPGM

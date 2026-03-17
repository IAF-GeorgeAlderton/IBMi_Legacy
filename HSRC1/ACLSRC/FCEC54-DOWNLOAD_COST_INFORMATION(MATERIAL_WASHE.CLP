             PGM
             /** FCEC54 ***************************************/
             /*  DOWNLOAD COST INFORMATION                    */
             /*    TCH                            02.12.02    */
             /*************************************************/


             CLRPFM     FILE(FCEWP54)
             CALL       PGM(FCER54)

             DLTOVR     FILE(*ALL)

              ENDPGM

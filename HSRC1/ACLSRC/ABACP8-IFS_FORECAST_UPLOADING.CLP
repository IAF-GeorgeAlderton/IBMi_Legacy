             PGM
             /** ABACP8 ******************************************/
             /*  IFS FORECAST UPLOADING                          */
             /*  JW     2024.05.28                               */
             /****************************************************/

             OVRDBF     FILE(ABAEP20) TOFILE(HFILE1/ABAEP21)

             CALL ABACP5

             ENDPGM

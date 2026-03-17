             PGM
             /***ABBR03 ******************************************/
             /** PRODUCT DEMAND FORECAST ACCUMULATION DATA       */
             /** DATA CHANGE  THIS MONTH TO NEXT MONTH           */
             /** READ ONPLY ABBFLG='9'                           */
             /****************************************************/

             OVRDBF     FILE(ABBPP01) TOFILE(TFILE1/ABBPP01)
             OVRDBF     FILE(AGDPL12) TOFILE(TFILE1/AGDPL12)
             OVRDBF     FILE(ABAWL15) TOFILE(TWFILE1/ABAWL15)

             CALL       PGM(TOBJ1/ABBR03B) PARM('202305')

             ENDPGM

PGM
             /** CAAC30 **********************************************/
             /* WRITE  A-PICS2 INSTORE-KANBAN ISSUE RESULT           */
             /*      CREATE DATE  :  2021.07.21                      */
             /*      AUTHOR.      :  T.SAKAKI                        */
             /********************************************** CAAC30 **/
             OVRDBF     FILE(INPUT) TOFILE(MEKI_RST24/RESULT)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512)

         /* MEKI_RST24 -> OUTPUT  */
             CALL       PGM(CAAR30)

             OVRDBF     FILE(CAAWP30) TOFILE(QTEMP/OUTPUT)

         /* CAAWP30 -> CAAPP30 */
         /*         -> NZUPP01 */
         /*         -> CA#PP11 */
             CALL       PGM(CAAR31)

ENDPGM

PGM
             /** AJSCD8 **********************************************/
             /* OUTPUT DS 2ND LOADING RESULTS                        */
             /*      CREATE DATE  :  2014/AUG/11                     */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /********************************************** AJHC10 **/
             OVRDBF     FILE(INPUT) TOFILE(MEKI_RST14/RESULT)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512)

             CALL       PGM(AJSRZ9)

             OVRDBF     FILE(INPUT) TOFILE(QTEMP/OUTPUT)

             CALL       PGM(AJSRD8)

ENDPGM

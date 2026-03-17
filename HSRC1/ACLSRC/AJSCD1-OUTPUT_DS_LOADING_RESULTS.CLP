PGM
             /** AJSCD1 **********************************************/
             /* OUTPUT DS LOADING RESULTS                            */
             /*      CREATE DATE  :  2013/JUN/18                     */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /********************************************** AJHC10 **/
             OVRDBF     FILE(INPUT) TOFILE(MEKI_RST05/RESULT)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512)

             CALL       PGM(AJSRZ9)

             OVRDBF     FILE(INPUT) TOFILE(QTEMP/OUTPUT)

             CALL       PGM(AJSRD1)

ENDPGM

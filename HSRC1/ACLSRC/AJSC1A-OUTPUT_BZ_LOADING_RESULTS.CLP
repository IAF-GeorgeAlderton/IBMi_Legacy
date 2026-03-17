PGM
             /** AJSCA1 **********************************************/
             /* OUTPUT BZ LOADING RESULTS                            */
             /*      CREATE DATE  :  2013/MAY/24                     */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /********************************************** AJHC10 **/
             OVRDBF     FILE(INPUT) TOFILE(MEKI_RST01/RESULT)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512)

             CALL       PGM(AJSRZ9)

             OVRDBF     FILE(AJSWP91) TOFILE(QTEMP/OUTPUT)

             CALL       PGM(AJSR1A)

ENDPGM

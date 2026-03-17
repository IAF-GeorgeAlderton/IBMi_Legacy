PGM
             /** AJHC10 **********************************************/
             /* OUTPUT JC LOADING RESULTS                            */
             /*      CREATE DATE  :  2013/MAY/23                     */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /********************************************** AJHC10 **/
             OVRDBF     FILE(INPUT) TOFILE(MEKI_RST08/RESULTFILE)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512)

             CALL       PGM(AJSRZ9)

             OVRDBF     FILE(INPUT) TOFILE(QTEMP/OUTPUT)
             CALL       PGM(AJHR10)
ENDPGM

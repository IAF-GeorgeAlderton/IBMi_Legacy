PGM
             /** AJSCE1 **********************************************/
             /* OUTPUT BZ UNLOADING RESULTS                          */
             /*      CREATE DATE  :  2013/MAY/23                     */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /********************************************** AJHC10 **/
             OVRDBF     FILE(INPUT) TOFILE(MEKI_RST03/RESULTFILE)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512)

             CALL       PGM(AJSRZ9)

             EDTDTA     FILE(QTEMP/OUTPUT)

             OVRDBF     FILE(INPUT) TOFILE(QTEMP/OUTPUT)

ENDPGM

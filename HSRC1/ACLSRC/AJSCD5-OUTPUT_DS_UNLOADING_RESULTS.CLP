PGM
             /** AJSCD5 **********************************************/
             /* OUTPUT DS UNLOADING RESULTS                          */
             /*      CREATE DATE  :  2013/MAY/23                     */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /********************************************** AJHC10 **/
             OVRDBF     FILE(INPUT) TOFILE(MEKI_RST06/RESULTFILE)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512)

             CALL       PGM(AJSRZ9)

             EDTDTA     FILE(QTEMP/OUTPUT)

          /* GOTO       CMDLBL(@END) */

             OVRDBF     FILE(INPUT) TOFILE(QTEMP/OUTPUT)

             CALL       PGM(AJSRD7)
             EDTDTA     FILE(AJSPP60)

             CALL       PGM(AJSRD6)
             EDTDTA     FILE(AJSPP60)

             CALL       PGM(AJSRD5)
             EDTDTA     FILE(AJSPP60)
@END:
ENDPGM

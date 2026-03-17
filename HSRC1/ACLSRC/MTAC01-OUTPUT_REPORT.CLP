PGM
             /** MTAC01 **********************************************/
             /* OUTPUT REPORT                                        */
             /*      CREATE DATE  :  2014.08.14                      */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /********************************************** AJHC10 **/
             OVRDBF     FILE(INPUT) TOFILE(MEKI_RST15/RESULT)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512)

             CALL       PGM(AJSRZ9)

             OVRDBF     FILE(INPUT) TOFILE(QTEMP/OUTPUT)
             CLRPFM     FILE(MTAWP02)

          /* 01:MTAWP02 */
             CALL       PGM(MTAR01)
          /* MTAWP02 -> MTAPP01 */
             CALL       PGM(MTAR02)

ENDPGM

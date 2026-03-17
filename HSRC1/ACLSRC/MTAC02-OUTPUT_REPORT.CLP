PGM
             /** MTAC01 **********************************************/
             /* OUTPUT REPORT                                        */
             /*      CREATE DATE  :  2014.08.14                      */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /********************************************** AJHC10 **/
             OVRDBF     FILE(INPUT) TOFILE(SAKASITA/REPORT)

             CLRPFM     FILE(MTAWP02)

          /* 01:MTAWP02 */
             CALL       PGM(MTAR01)
          /* MTAWP02 -> MTAPP01 */
             CALL       PGM(MTAR02)

ENDPGM

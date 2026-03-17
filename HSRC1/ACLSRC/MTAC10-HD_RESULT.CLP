PGM
             /** MTAC10 **********************************************/
             /* HD RESULT                                            */
             /*      CREATE DATE  :  2014.08.14                      */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /********************************************** AJHC10 **/
             OVRDBF     FILE(INPUT) TOFILE(MEKI_RST16/RESULT)

             CPYF       FROMFILE(MEKI_RST16/RESULT) +
                          TOFILE(WEEKDLT/RESULT) MBROPT(*ADD) +
                          CRTFILE(*YES)

ENDPGM

PGM
             /** AJZC10 **********************************************/
             /*端数統合実績ファイルの作成                          */
             /*      CREATE DATE  :  2014.08.11                      */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /********************************************** AJHC10 **/
             OVRDBF     FILE(INPUT) TOFILE(MEKI_RST11/RESULT)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512)

             CALL       PGM(AJSRZ9)

             OVRDBF     FILE(AJSWP91) TOFILE(QTEMP/OUTPUT)

             CALL       PGM(AJZR10)

         /*  CPYF       FROMFILE(MEKI_RST11/RESULT) +
                          TOFILE(OKUMURA/RESULT) MBROPT(*ADD) +
                          CRTFILE(*YES)   */
         /*  MONMSG     MSGID(CPF0000)    */

ENDPGM

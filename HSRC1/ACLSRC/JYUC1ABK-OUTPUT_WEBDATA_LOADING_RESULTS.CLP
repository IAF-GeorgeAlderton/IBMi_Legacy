PGM
             /** JYUC1A **********************************************/
             /*  OUTPUT WEBDATA LOADING RESULTS                      */
             /*      CREATE DATE  :  2015/05/27                      */
             /*      AUTHOR.      :                                  */
             /********************************************** JYUC1A **/
             OVRDBF     FILE(INPUT) TOFILE(EDI_RST01/RESULT)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512)

             CALL       PGM(JYURZ9)

/**!**!**    OVRDBF     FILE(       ) TOFILE(QTEMP/OUTPUT)    **!**!**/
/**!**!**    CALL       PGM(      )                           **!**!**/

ENDPGM

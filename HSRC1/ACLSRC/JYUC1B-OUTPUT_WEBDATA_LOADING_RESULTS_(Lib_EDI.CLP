PGM
             /** JYUC1B **********************************************/
             /*  OUTPUT WEBDATA LOADING RESULTS  (EDI_RST02)         */
             /*      CREATE DATE  :  2019/02/12                      */
             /*      AUTHOR.      :                                  */
             /********************************************************/
             OVRDBF     FILE(INPUT) TOFILE(EDI_RST02/RESULT)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512) SIZE(1000000)

             CALL       PGM(JYURZ9)

             OVRDBF     FILE(AL#WP01) TOFILE(QTEMP/OUTPUT)

  /* ﾆﾈｹﾄﾎ ｱﾄｴ ｵﾃｱｹﾂ ﾄｵﾑ ﾎﾅﾓﾅﾎｱ ﾍﾏﾆﾆﾂｵﾃｵﾄﾎｱﾂ ﾅﾈｴｵﾈﾍ ﾂｹﾍﾎｹﾄｷ...            */
             CALL       PGM(AL#C01D)

  /* ｳﾈｵｱﾎｵ ﾎﾅﾓﾅﾎｱ ﾍﾏﾆﾆﾂｵﾃｵﾄﾎｱﾂ ﾅﾈｴｵﾈﾍ ｹﾄ AB#PP10...                      */
  /******    CALL       PGM(AL#C01E)                                  *****/

             CALL       PGM(AL#R01C)

ENDPGM

   PGM
   /*** REQC11 *****************/
   /* AOYAMA機　マスター送信要求*/
   /* T.SAKASHITA 2012.07.13   */
   /*-----------------REQC11 --*/

             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('AS400-SYSTEM@IAFI.COM')) +
                          DSTD('START Receiving files from ASJ +
                          PGM:REQC11') LONGMSG('START Receiving +
                          files from ASJ such as HAAPP01 HABPP01 +
                          BBCPP01 BBDPP01') DOCD('START Receiving +
                          files from ASJ PGM:REQC11')

   DLTF       FILE(ASJFILE/TRNC11SAVF)
   MONMSG     MSGID(CPF3261 CPF2105)
   CRTSAVF    FILE(ASJFILE/TRNC11SAVF)

   DLTF       FILE(ASJFILE/TRNC12SAVF)
   MONMSG     MSGID(CPF3261 CPF2105)
   CRTSAVF    FILE(ASJFILE/TRNC12SAVF)

   DLTF       FILE(ASJFILE/TRNC13SAVF)
   MONMSG     MSGID(CPF3261 CPF2105)
   CRTSAVF    FILE(ASJFILE/TRNC13SAVF)

   DLTF       FILE(ASJFILE/TRNC14SAVF)
   MONMSG     MSGID(CPF3261 CPF2105)
   CRTSAVF    FILE(ASJFILE/TRNC14SAVF)

/* AOYAMA機でTRNC11が実行される*/

   OVRDBF     FILE(INPUT) TOFILE(HSRC1/FMTSRC) MBR(REQS11)
   STRTCPFTP  RMTSYS(AOYAMA)

   ENDPGM

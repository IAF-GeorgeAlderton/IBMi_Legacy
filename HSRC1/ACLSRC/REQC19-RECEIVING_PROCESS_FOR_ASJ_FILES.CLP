             PGM        PARM(&TYPE)
       /*** REQC19 *****************/
       /* IAF <-> ASJ PT CONNECTIO TEST */
       /* T.SAKAKI    2019.11.14   */
       /*-----------------REQC19 --*/

       /*-----------------------------------------------*/
       /*  'S'  SEND                                    */
       /*-----------------------------------------------*/
             IF         COND(&TYPE *EQ 'S') THEN(DO)

       /**       TOINTNET(('AS400-SYSTEM@IAFI.COM')) + **/
             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('TAKASHI.SAKAKI@IAFI.COM')) +
                          DSTD('START IAF<->ASJ connection test +
                          PGM:REQC19') LONGMSG('START IAF<->ASJ +
                          connection test') DOCD('START IAF<->ASJ +
                          connection test PGM:REQC19')

             DLTF       FILE(ASJFILE/TRNC19SAVF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(ASJFILE/TRNC19SAVF)

       /* CALL TRNC19 ON ASJ-AS400 */
             OVRDBF     FILE(INPUT) TOFILE(HSRC1/FMTSRC) MBR(REQS19)
             STRTCPFTP  RMTSYS(AOYAMA)
             ENDDO

       /*-----------------------------------------------*/
       /*  'R'  RECEIVE                                 */
       /*-----------------------------------------------*/
             IF         COND(&TYPE *EQ 'R') THEN(DO)

             SNDMSG     MSG('TEST RECEIVE START') +
                          TOMSGQ(V#IS1)

             RSTOBJ     OBJ(GKGPP50) SAVLIB(FILELIB) +
                          DEV(*SAVF) SAVF(ASJFILE/TRNC19SAVF) +
                          RSTLIB(ASJFILE)

             SNDMSG     MSG('RCVC11 ENDED') TOMSGQ(V#IS1)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('AS400-SYSTEM@IAFI.COM')) +
                          DSTD('END Receiving files from ASJ') +
                          LONGMSG('END Receiving files from ASJ +
                          such as HAAPP01 HABPP01 BBCPP01 BBDPP01. +
                          (RCVC11)') DOCD('END Receiving files from +
                          ASJ')

             ENDDO

   ENDPGM

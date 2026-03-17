             PGM
             /*** RCVC19 ********************/
             /* AOYAMA機　マスター送信要求*/
             /* T.SAKAKI   2019.11.14       */
             /*--------------------RCVC19 --*/

             SNDMSG     MSG('RCVC19 CALLED') TOMSGQ(V#IS1)

/*- HFILE ------------------------------------------------*/

             SNDMSG     MSG('TEST RECEIVE START') +
                          TOMSGQ(V#IS1)

             DLTF       FILE(ASJFILE/RCVPP19)
             MONMSG     MSGID(CPF3261 CPF2105)

             RSTOBJ     OBJ(RCVPP19) SAVLIB(ASJFILE) +
                          DEV(*SAVF) SAVF(ASJFILE/TRNC19SAVF) +
                          RSTLIB(ASJFILE)
             MONMSG     MSGID(CPF0000)

             SNDMSG     MSG('HAAPP01 HABPP01 RECEIVE END') +
                          TOMSGQ(V#IS1)
/*- APLIB ------------------------------------------------*/

             SNDMSG     MSG('BBCPP01 BBDPP01 RECEIVE START') +
                          TOMSGQ(V#IS1)

             DLTF       FILE(ASJFILE/BBCPP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(ASJFILE/BBDPP01)
             MONMSG     MSGID(CPF3261 CPF2105)

             RSTOBJ     OBJ(BBCPP01 BBDPP01) SAVLIB(APLIB) +
                          DEV(*SAVF) SAVF(ASJFILE/TRNC13SAVF) +
                          RSTLIB(ASJFILE)
             MONMSG     MSGID(CPF0000)

             SNDMSG     MSG('BBCPP01 BBDPP01 RECEIVE END') +
                          TOMSGQ(V#IS1)

/*- FILELIB ----------------------------------------------*/

             RSTOBJ     OBJ(GKGPP50) SAVLIB(FILELIB) +
                          DEV(*SAVF) SAVF(ASJFILE/TRNC14SAVF) +
                          RSTLIB(ASJFILE)

             SNDMSG     MSG('RCVC11 ENDED') TOMSGQ(HPIS1)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('AS400-SYSTEM@IAFI.COM')) +
                          DSTD('END Receiving files from ASJ') +
                          LONGMSG('END Receiving files from ASJ +
                          such as HAAPP01 HABPP01 BBCPP01 BBDPP01. +
                          (RCVC11)') DOCD('END Receiving files from +
                          ASJ')

             ENDPGM

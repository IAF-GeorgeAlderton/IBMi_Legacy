             PGM
             /** EGBCPL ************************************/
             /* CREATE MENU PROGRAM LIST                   */
             /* T.SAKASHITA  2003.10.03                    */
             /**********************************************/
             DLTF       FILE(EGBWPPL)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/EGBWPPL) RCDLEN(128)

             CALL       PGM(EGBRPL)

 @END:       ENDPGM

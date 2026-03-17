             PGM
             /** ALGCC0 **********************************************/
             /* OQ INPROCESS SCAN RESULT FILE DATA           */
             /*   MAEDA.             2017.08.08                      */
             /********************************************************/

             DLTF       FILE(HWFILE1/ALGWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALGWP01) RCDLEN(256) TEXT('OQ +
                          INPROCESS SCAN RESULT FILE DATA') +
                          OPTION(*NOLIST) SIZE(1000000 3000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(ALGWP01) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             CALL       PGM(ALGRC0)

             ENDPGM

             PGM
             /** ALHCC0 **********************************************/
             /* LOQ INPROCESS SCAN RESULT FILE DATA                  */
             /*   MAEDA.             2017.08.08                      */
             /********************************************************/

             DLTF       FILE(HWFILE1/ALHWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALHWP01) RCDLEN(256) TEXT('LOQ +
                          INPROCESS SCAN RESULT FILE DATA') +
                          OPTION(*NOLIST) SIZE(1000000 3000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(ALHWP01) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             CALL       PGM(ALHRC0)

             ENDPGM

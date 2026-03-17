             PGM
             /** ASBC01 **********************************************/
             /*  CREATE SB-KRO MASTER                                */
             /*                      CREATE DATE  : 2018.12.19       */
             /*                                   : SAKASHITA        */
             /********************************************************/

             CLRPFM     FILE(ASBPP01)

          /* ABHPP01 -> ASBPP01 */
             CALL       PGM(ASBR01)

          /* AAHPP01 -> ASBPP01 */
             CALL       PGM(ASBR02)

          /* CADPP01 -> ASBPP01 */
             CALL       PGM(ASBR03)

             DLTF       FILE(HWFILE1/ASBWP09)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ASBWP09) RCDLEN(145) +
                          TEXT('           M/F DKT OUTPUT') +
                          OPTION(*NOLIST) SIZE(4000 500) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(ASBWP09) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

          /* ASBPP01 -> ASBWP09 */
             CALL       PGM(ASBR09)

             ENDPGM

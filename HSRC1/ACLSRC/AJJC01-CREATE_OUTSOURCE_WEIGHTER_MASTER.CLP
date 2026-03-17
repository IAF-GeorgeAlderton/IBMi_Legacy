             PGM
             /** AJJC01 ******************************/
             /*  ..CREATE OUTSOURCE WEIGHTER MASTER  */
             /*                      2015.09.29      */
             /****************************** AJJC01 **/

             DLTF       FILE(HWFILE1/AJJWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJJWP01) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AJJR01)
             CALL       PGM(AJJR02)
             CALL       PGM(AJJR03)
     /* ADD A-PICS KANBAN KIND */
             CALL       PGM(AJJR04)

             ENDPGM

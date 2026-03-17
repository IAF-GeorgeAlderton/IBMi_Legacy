             PGM
             /** AJZC01 ************************************/
             /* COMBINE PARTIAL MASTER                     */
             /*               CREATE DATE : 2014.06.11     */
             /*               T.SAKASHITA                  */
             /**********************************************/
             DLTF       FILE(HWFILE1/AJZWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJZWP01) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AJZR01)
             CALL       PGM(AJZR02)
             CALL       PGM(AJZR03)

             ENDPGM

             PGM
             /** AJXC01 ************************************/
             /* MATERIAL HD MASTER                         */
             /*               CREATE DATE : 2015.06.04     */
             /*               Y.SAMEJIMA                   */
             /**********************************************/
             DLTF       FILE(HWFILE1/AJXWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJXWP01) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(HWFILE1/AJXWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJXWP02) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)


     /* CREATE FROM IZAPP01(MATERIAL)  */
             CALL       PGM(AJXR01)
     /* CREATE FROM ABHPP01(HD)*/
             CALL       PGM(AJXR02)
     /* CREATE FROM CADPP01(HD)*/
             CALL       PGM(AJXR03)

             ENDPGM

             PGM
             /** GDLC4A ********************/
             /*  ネットワークジョブ復元  */
             /*   ＩＡＦシステムデータ   */
             /*     MSK KUNIUEDA 2000.07.29*/
             /********************* GDLC4A **/
             DCL        VAR(&PMBRN) TYPE(*CHAR) LEN(6)

             DLTF       FILE(HWFILE1/GDHWP40)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GDHWP40) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AJFC40) PARM('GDHWP40' &PMBRN)
             RCVNETF    FROMFILE(GDHWP40) TOFILE(HWFILE1/GDHWP40) +
                          NBR(&PMBRN) USER(QFILE)

             CALL       PGM(GDLR4A)
             DLTF       FILE(HWFILE1/GDHWP40)
             ENDPGM

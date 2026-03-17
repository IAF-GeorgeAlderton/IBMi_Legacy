             PGM
             /** MBDCS2 ********************/
             /*  RETURN OF THE NETWORK JOB */
             /*  T.SAKASHITA   2005.04.10  */
             /******************** GLOC97 **/
             DCL        VAR(&PMBRN) TYPE(*CHAR) LEN(6)
             CALL       PGM(AJFC40) PARM('MBDWPS2IAF' &PMBRN)

             DLTF       FILE(HWFILE1/MBDWPIA)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWPIA) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             RCVNETF    FROMFILE(MBDWPS2IAF) +
                          TOFILE(HWFILE1/MBDWPIA) TOMBR(*FIRST) +
                          NBR(&PMBRN) USER(QFILE)

             DLTF       FILE(HWFILE1/MBDWPS3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWPS3) RCDLEN(1) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             ENDPGM

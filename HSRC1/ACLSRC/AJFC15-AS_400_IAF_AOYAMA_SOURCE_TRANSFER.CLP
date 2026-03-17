             PGM
             /** AJFC15 ****************************************/
             /*  ..AS/400 IAF ATC<-->AOYAMA SOURCE TRANSFER..  */
             /*  ..SRCMBR SRCFILE LIBRARY                      */
             /*    I-HASADA                      2001.04.20    */
             /**************************************** AJFC15 **/
             DLTF       FILE(HWFILE1/AJFWP15)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJFWP16)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/AJFWP16) RCDLEN(112) +
                          OPTION(*NOLIST) SIZE(100 10 3) +
                          LVLCHK(*NO) AUT(*ALL)

             WRKNETF    USER(TFILE) OUTPUT(*OUTFILE) +
                          OUTFILE(HWFILE1/AJFWP15)

             FMTDTA     INFILE((HWFILE1/AJFWP15)) +
                          OUTFILE(HWFILE1/AJFWP16) SRCFILE(FMTSRC) +
                          SRCMBR(AJFS12) OPTION(*NOPRT)
             DLTF       FILE(HWFILE1/AJFWP15)

             CALL       PGM(AJFR15)
             DLTF       FILE(HWFILE1/AJFWP16)

             ENDPGM

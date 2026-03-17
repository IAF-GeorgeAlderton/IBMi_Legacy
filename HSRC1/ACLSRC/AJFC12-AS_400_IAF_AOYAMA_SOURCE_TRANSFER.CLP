             PGM
             /** AJFC12 ************************************/
             /*  ..AS/400 IAF<-->AOYAMA SOURCE TRANSFER..  */
             /*    I-HASADA                    97.09.19    */
             /************************************ AJFC12 **/
             DLTF       FILE(HWFILE1/AJFWP12)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJFWP13)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/AJFWP13) RCDLEN(112) +
                          OPTION(*NOLIST) SIZE(100 10 3) +
                          LVLCHK(*NO) AUT(*ALL)

             WRKNETF    USER(TFILE) OUTPUT(*OUTFILE) +
                          OUTFILE(HWFILE1/AJFWP12)

             FMTDTA     INFILE((HWFILE1/AJFWP12)) +
                          OUTFILE(HWFILE1/AJFWP13) SRCFILE(FMTSRC) +
                          SRCMBR(AJFS12) OPTION(*NOPRT)
             DLTF       FILE(HWFILE1/AJFWP12)

             CALL       PGM(AJFR12)
             DLTF       FILE(HWFILE1/AJFWP13)

             ENDPGM

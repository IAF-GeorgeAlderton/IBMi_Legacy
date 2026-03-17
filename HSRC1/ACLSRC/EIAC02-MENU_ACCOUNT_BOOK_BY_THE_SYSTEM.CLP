             PGM
             /** EIAC02 ******************************/
             /* MENU ACCOUNT BOOK BY THE SYSTEM */
             /* I-HASADA                95.10.31     */
             /****************************** EIAC02 **/
             DLTF       FILE(EIAWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/EIAWP02) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(15000 1000 3) +
                          LVLCHK(*NO)

             CALL       PGM(EIAR02)

             DLTF       FILE(EIAWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/EIAWP03) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(15000 1000 3) +
                          LVLCHK(*NO)

             DLTF       FILE(EIAWP04)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/EIAWP04) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(15000 1000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((EIAWP02)) OUTFILE(EIAWP03) +
                          SRCFILE(FMTSRC) SRCMBR(EIAS03) OPTION(*NOPRT)

             FMTDTA     INFILE((EIAWP02)) OUTFILE(EIAWP04) +
                          SRCFILE(FMTSRC) SRCMBR(EIAS04) OPTION(*NOPRT)
             DLTF       FILE(EIAWP02)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6S1)
             OVRDBF     FILE(EGBPL13) TOFILE(DDM40/EGBPL13)
             CALL       PGM(EIAR03)
             DLTF       FILE(EIAWP03)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6S1)
             CALL       PGM(EIAR04)
             DLTF       FILE(EIAWP04)
             DLTOVR     FILE(*ALL)

             ENDPGM

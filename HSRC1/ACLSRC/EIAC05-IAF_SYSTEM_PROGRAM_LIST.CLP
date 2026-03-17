             PGM
             /** EIAC05 **********************************/
             /* || IAF SYSTEM PROGRAM LIST */
             /* I-HASADA                    96.07.23     */
             /********************************** EIAC05 **/
             DLTF       FILE(HWFILE/EIAWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/EIAWP02) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(15000 1000 3) +
                          LVLCHK(*NO)

             OVRDBF     FILE(EIAPP01) TOFILE(HFILE/EIAPP01)
             OVRDBF     FILE(EIAWP02) TOFILE(HWFILE/EIAWP02)
             CALL       PGM(HOBJ/EIAR02)

             DLTF       FILE(HWFILE/EIAWP04)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/EIAWP04) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(15000 1000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE/EIAWP02)) +
                          OUTFILE(HWFILE/EIAWP04) +
                          SRCFILE(HSRC/FMTSRC) SRCMBR(EIAS04) +
                          OPTION(*NOPRT)
             DLTF       FILE(HWFILE/EIAWP02)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1)
             OVRDBF     FILE(EIAWP04) TOFILE(HWFILE/EIAWP04)
             OVRDBF     FILE(EGBPL13) TOFILE(DDM40/EGBPL13)
             CALL       PGM(HOBJ/EIAR05)
             DLTF       FILE(HWFILE/EIAWP04)
             DLTOVR     FILE(*ALL)

             ENDPGM

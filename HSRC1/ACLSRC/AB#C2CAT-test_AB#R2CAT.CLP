             PGM        PARM(&SERL)
             /** AB#C2CAT *********************************************/
             /*  TEST AB#R2CAT                                        */
             /*********************************************************/
             DCL        VAR(&SERL ) TYPE(*CHAR) LEN(9)

             CLRPFM     FILE(TWFILE1/AB#WP2EM)
             CLRPFM     FILE(TWFILE1/SV#WP2EM)
             CLRPFM     FILE(TFILE1/AB#XP01A)

             OVRDBF     FILE(AB#WP2EM) TOFILE(TWFILE1/AB#WP2EM)
             OVRDBF     FILE(SV#WP2EM) TOFILE(TWFILE1/SV#WP2EM)
             OVRDBF     FILE(AB#XP01A) TOFILE(TFILE1/AB#XP01A)

             CALL       PGM(AB#R2CAT) PARM(&SERL)

             DLTOVR     FILE(*ALL)

             ENDPGM

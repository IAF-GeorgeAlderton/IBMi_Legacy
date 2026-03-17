             PGM

             CLRPFM     FILE(HWFILE1/AZBWP01)

             OVRDBF     FILE(AZBWP01) TOFILE(HWFILE1/AZBWP01)

             OVRDBF     FILE(AB#PL72)  TOFILE(HFILE1/AB#PL72)
             OVRDBF     FILE(FCEPL01)  TOFILE(HFILE1/FCEPL01)
             OVRDBF     FILE(AGDPL12)  TOFILE(HFILE1/A@DPL12)
             OVRDBF     FILE(GADPL11)  TOFILE(HFILE1/GADPL11)

             CALL       PGM(HOBJ1/AZBR01)


             DLTF       FILE(HWFILE1/AZBWP02)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/AZBWP02) RCDLEN(1100) +
                          TEXT('3 POINT SCAN DATA') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AZBWP02)  TOFILE(HWFILE1/AZBWP02)

             CALL       PGM(HOBJ1/AZBR02)
END:
             DLTOVR     FILE(*ALL)

             ENDPGM

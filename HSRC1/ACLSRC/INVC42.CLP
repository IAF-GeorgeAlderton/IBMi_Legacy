             PGM
             CLRPFM     FILE(INVWP42)

             OVRDBF     FILE(INPUT) TOFILE(INVWP41S)
             OVRDBF     FILE(OUTPUT) TOFILE(INVWP42)
             CALL       PGM(INVR46)

             ADDLIBLE   LIB(MAI)
             MONMSG     MSGID(CPF2103)

             MAI/DBTOMAIL TO('T-SAKASHITA@ASJ-FASTENERS.CO.JP' +
                          'ATSUO.MAMIYA@IAFI.COM') SUBJECT('TEST +
                          DATA') FILE(HWFILE1/INVWP42) +
                          FROM('INVC42@IAF') SERVER('172.16.4.13')
@END:
             ENDPGM

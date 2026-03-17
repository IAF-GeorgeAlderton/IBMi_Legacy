             PGM
             /** AJCC18 ******************************************************/
             /*  EXECUTE SAVLIB                                              */
             /****************************************************************/

/* DELETE APICS DATA AREA */
             DLTDTAARA  DTAARA(AIAACT)
             MONMSG     MSGID(CPF2105)

             INZTAP     DEV(TAP01) NEWVOL(DBACK) CHECK(*NO) +
                          DENSITY(*ULTRIUM6)
             MONMSG     MSGID(CPF0000)

             SAVLIB     LIB(HFILE1 HWFILE1 HSRC1 +
                          G3X6DTA G3X6PGM G3X1CUSOBJ +
                          ZMCDINSLIB ZMODLIB10 ZMODLIB10X ZMODFTP20) +
                          DEV(TAP01) VOL(DBACK) +
                          ENDOPT(*UNLOAD) SAVACT(*SYSDFN)
             MONMSG     MSGID(CPF0000)

 END:        ENDPGM

             PGM        PARM(&JIKN)
             /** AJCC08 ******************************************************/
             /*  EXECUTE SAVLIB                                              */
             /*                                                              */
             /*  TCH 00.08.28                                                */
             /*  TCH 00.09.14                                                */
             /*  TCHK1 11.20.06 CHG SAVLIB                                   */
             /*  TCHK2 07.27.07 CHG G3X1TST TO G3X4TST                       */
             /*  TCHK3 04.22.13 CHG G3X4??? TO G3X6???                       */
             /*                 CHG TAP04 TO TAP01                           */
             /*                 ADD ZMODLIB                                  */
             /*  JW1   12.22.17 REMOVE ZMODLIBS                              */
             /*  LEC   02.24.20 ADD TLA LIBRARIES                            */
             /****************************************************** AJCC08 **/
             DCL        VAR(&JIKN) TYPE(*CHAR) LEN(6)

             CALL       PGM(AJCCCK) PARM(&JIKN)

             DLYJOB     RSMTIME(&JIKN)

/* DLETE APICS DATA AREA */
             DLTDTAARA  DTAARA(AIAACT)
             MONMSG     MSGID(CPF2105)

/* TCHK3 */  INZTAP     DEV(TAP01) NEWVOL(DBACK) CHECK(*NO) +
                          DENSITY(*ULTRIUM6)
             MONMSG     MSGID(CPF0000)

         /*JW1 SAVLIB     LIB(HFILE1 HWFILE1 HSRC1 +                    */
         /*               G3X6DTA G3X6PGM G3X1CUSOBJ +                  */
         /*               ZMCDINSLIB ZMODLIB10 ZMODLIB10X ZMODFTP20) +  */
         /*               DEV(TAP01) VOL(DBACK) +                       */
         /*               ENDOPT(*UNLOAD) SAVACT(*SYSDFN)               */

             SAVLIB     LIB(G3X6DTA HFILE1 G3X6PGM G3X1CUSOBJ HSRC1 +
                          TLABARCODE TLAFORM TLAOVERLAY) DEV(TAP01) +
                          VOL(DBACK) ENDOPT(*UNLOAD) SAVACT(*SYSDFN)

             MONMSG     MSGID(CPF0000)

 END:        ENDPGM

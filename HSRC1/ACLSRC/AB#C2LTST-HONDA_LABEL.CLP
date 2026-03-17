             PGM
             /** AB#C2L ***********************************************/
             /*  ..HONDA LABEL                                        */
             /*                                                       */
             /*                                                       */
             /***************************** AB#C2C ********************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

         /*  CHKOBJ     OBJ(AB#WP2F) OBJTYPE(*FILE) MBR(&WKSID) */
         /*  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2F) +
                          MBR(&WKSID)) */
             CHKOBJ     OBJ(AB#WP2U) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2U) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2V) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2V) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2X) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2X) +
                          MBR(&WKSID))

        /*   CLRPFM     FILE(AB#WP2F) MBR(&WKSID)  */
             CLRPFM     FILE(AB#WP2U) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2V) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2X) MBR(&WKSID)

        /*   OVRDBF     FILE(AB#WP2F) TOFILE(AB#WP2F) MBR(&WKSID) */
   /* OUT */ OVRDBF     FILE(AB#WP2U) TOFILE(AB#WP2U) MBR(&WKSID)
   /* OUT */ OVRDBF     FILE(AB#WP2V) TOFILE(AB#WP2V) MBR(&WKSID)
   /* OUT */ OVRDBF     FILE(AB#WP2X) TOFILE(AB#WP2X) MBR(&WKSID)

   /* IN  */ OVRDBF     FILE(FCEPL01) TOFILE(TFILE1/FCEPL01)
   /* IN  */ OVRDBF     FILE(FCEPL30) TOFILE(TFILE1/FCEPL30)

   /* IN  */ OVRDBF     FILE(AB#PL90) TOFILE(TFILE1/AB#PL90)
   /* IN  */ OVRDBF     FILE(AGDPL12) TOFILE(TFILE1/AGDPL12)
   /* IN  */ OVRDBF     FILE(AB#PL25) TOFILE(TFILE1/AB#PL25)
   /* IN  */ OVRDBF     FILE(AB#PL13) TOFILE(TFILE1/AB#PL13)
   /* IN  */ OVRDBF     FILE(AB#PL55) TOFILE(TFILE1/AB#PL55)

   /* I-A */ OVRDBF     FILE(AB#PL2A) TOFILE(TFILE1/AB#PL2A)
   /* OUT */ OVRDBF     FILE(AB#PP70) TOFILE(TFILE1/AB#PP70)
   /* UPD */ OVRDBF     FILE(AB#PL70) TOFILE(TFILE1/AB#PL70)
   /* U-A */ OVRDBF     FILE(AB#NP30) TOFILE(TFILE1/AB#NP30)
   /* UPD */ OVRDBF     FILE(AB#PL76) TOFILE(TFILE1/AB#PL76)
   /* OUT */ OVRDBF     FILE(AB#PP2F) TOFILE(TFILE1/AB#PP2F)

             CALL       PGM(TOBJ1/AB#R2L)


             ENDPGM

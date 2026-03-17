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
             DCL        VAR(&SPFLG)   TYPE(*CHAR) LEN(1)

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

             CHKOBJ     OBJ(AB#WPUF) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WPUF) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WPVF) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WPVF) +
                          MBR(&WKSID))

        /*   CLRPFM     FILE(AB#WP2F) MBR(&WKSID)  */
             CLRPFM     FILE(AB#WP2U) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2V) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2X) MBR(&WKSID)
             CLRPFM     FILE(AB#WPUF) MBR(&WKSID)
             CLRPFM     FILE(AB#WPVF) MBR(&WKSID)

        /*   OVRDBF     FILE(AB#WP2F) TOFILE(AB#WP2F) MBR(&WKSID) */
             OVRDBF     FILE(AB#WP2U) TOFILE(AB#WP2U) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2V) TOFILE(AB#WP2V) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2X) TOFILE(AB#WP2X) MBR(&WKSID)

             ALCOBJ     OBJ((*LIBL/AB#WP2U *FILE *EXCL &WKSID))

             CALL       PGM(AB#R2L)

 /* check for service parts in workfile...if found then don't sort */
             CALL       PGM(AB#R2L4) PARM(&SPFLG)
             IF         COND(&SPFLG *EQ 'Y') THEN(GOTO CMDLBL(#END))

 /* process label wf --- sort sequence   create ab#wpuf, ab#wpvf */
             CALL       PGM(AB#R2L2)


 /*  clear original workfiles...                                 */
             CLRPFM     FILE(AB#WP2U) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2V) MBR(&WKSID)


 /*  copy location sequence workfiles into original workfiles... */
 /*       insert blank record between locations...               */
             OVRDBF     FILE(AB#WPUF) TOFILE(AB#WPUF) MBR(&WKSID)
             CALL       PGM(AB#R2L5)

 /*          CPYF       FROMFILE(AB#WPUF) TOFILE(AB#WP2U) +      */
 /*                       FROMMBR(&WKSID) TOMBR(&WKSID) +        */
 /*                       MBROPT(*ADD) FMTOPT(*MAP *DROP)        */

             CPYF       FROMFILE(AB#WPVF) TOFILE(AB#WP2V) +
                          FROMMBR(&WKSID) TOMBR(&WKSID) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

 #END:
             DLCOBJ     OBJ((*LIBL/AB#WP2U *FILE *EXCL &WKSID))

             ENDPGM

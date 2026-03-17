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

             CHKOBJ     OBJ(AB#WP2U) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2U) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2V) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2V) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2X) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2X) +
                          MBR(&WKSID))

             CLRPFM     FILE(AB#WP2U) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2V) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2X) MBR(&WKSID)

             OVRDBF     FILE(AB#WP2U) TOFILE(AB#WP2U) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2V) TOFILE(AB#WP2V) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2X) TOFILE(AB#WP2X) MBR(&WKSID)

             CALL       PGM(AB#REB)


             ENDPGM

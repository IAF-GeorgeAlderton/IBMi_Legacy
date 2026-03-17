             PGM
             /** AB#C2M ***********************************************/
             /*  ..HINO SKID LABEL                                    */
             /*                                                       */
             /*                                                       */
             /***************************** AB#C2M ********************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(AB#WP2D) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2D) +
                          MBR(&WKSID))

             CLRPFM     FILE(AB#WP2D) MBR(&WKSID)
             CRTDUPOBJ  OBJ(AB#WP2C) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP2C
             OVRDBF     FILE(AB#WP2C) TOFILE(QTEMP/AB#WP2C)
             OVRDBF     FILE(AB#WP2D) TOFILE(&WLIB/AB#WP2D) MBR(&WKSID)

             CALL       PGM(AB#R2M)
             DLTOVR     FILE(*ALL)


             ENDPGM

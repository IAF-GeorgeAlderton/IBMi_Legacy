             PGM        PARM(&SERL)
             /** AB#C2CA **********************************************/
             /*  MASTER LABEL (AB#WP2EM)                              */
             /***************************** AB#C2L3 *******************/
             DCL        VAR(&SERL ) TYPE(*CHAR) LEN(9)

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))
             CHKOBJ     OBJ(*LIBL/AB#WP2EM) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(*LIBL/AB#WP2EM) MBR(&WKSID))
             CLRPFM     FILE(*LIBL/AB#WP2EM) MBR(&WKSID)
             MONMSG     MSGID(CPF3130)


             OVRDBF     FILE(AB#WP2EM) TOFILE(*LIBL/AB#WP2EM) MBR(&WKSID)
             CALL       PGM(AB#R2CA) PARM(&SERL)

             DLTOVR     FILE(*ALL)

             ENDPGM

             PGM        PARM(&SERL)
             /** AB#C2C4 **********************************************/
             /*  MIXED LABEL BY AB#PP71                               */
             /***************************** AB#C2L3 *******************/
             DCL        VAR(&SERL )    TYPE(*CHAR) LEN(9)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))
             CHKOBJ     OBJ(*LIBL/AB#WP2O) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(*LIBL/AB#WP2O) MBR(&WKSID))
             CLRPFM     FILE(*LIBL/AB#WP2O) MBR(&WKSID)
             MONMSG     MSGID(CPF3130)


             OVRDBF     FILE(AB#WP2O) TOFILE(*LIBL/AB#WP2O) MBR(&WKSID)
             CALL       PGM(AB#R2C8) PARM(&SERL)

             DLTOVR     FILE(*ALL)

             ENDPGM

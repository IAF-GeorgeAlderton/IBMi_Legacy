             PGM
             /** AB#C2Q ********************************/
             /*  ..CREATE ARVIN SANGO MANIFEST DATA    */
             /*     TCH 2001.03.14 ADD ARVIN SANGO     */
             /***************************** AB#C2Q *****/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)   TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHKOBJ     OBJ(AB#WP2R) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2R) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2S) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2S) +
                          MBR(&WKSID))

             CLRPFM     FILE(AB#WP2R) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2S) MBR(&WKSID)

             OVRDBF     FILE(AB#WP2R) TOFILE(AB#WP2R) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2S) TOFILE(AB#WP2S) MBR(&WKSID)

             CALL       PGM(AB#R2Q)

  END:
             ENDPGM

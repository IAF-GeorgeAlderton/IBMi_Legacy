             PGM
             /** UAFC01 ************************************/
             /*  UPDATE KANBAN MASTER (AAFPP01) - TEMP     */
             /*  JW   2020.04.15                           */
             /**********************************************/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEQ1) TYPE(*DEC)  LEN(2 0) VALUE(0)
             DCL        VAR(&SEQ2) TYPE(*CHAR) LEN(2)
AGAIN:
             CHGVAR     VAR(&SEQ1) VALUE(&SEQ1 + 1)
             CHGVAR     VAR(&SEQ2) VALUE(&SEQ1)
             CHGVAR     VAR(&FILE) VALUE('AAFPP01' *CAT &SEQ2)
             CHKOBJ     OBJ(*LIBL/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(SAVE))
             GOTO       CMDLBL(AGAIN)
SAVE:
             CPYF       FROMFILE(*LIBL/AAFPP01) TOFILE(BACKUP/&FILE) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)

             CALL       PGM(UAFR01)

             ENDPGM

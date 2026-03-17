             PGM        PARM(&PFILE &PPST01 &PPST02 &PPST03 &PPST04 +
                          &PPST05)
             /** IZZC91 ************************************/
             /*  ..全ファイル西暦年（１９９６）に変更..  */
             /*      I-HASADA                96.12.05      */
             /************************************ IZZC91 **/
             DCL        VAR(&PFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPST01) TYPE(*CHAR) LEN(40)
             DCL        VAR(&PPST02) TYPE(*CHAR) LEN(40)
             DCL        VAR(&PPST03) TYPE(*CHAR) LEN(40)
             DCL        VAR(&PPST04) TYPE(*CHAR) LEN(40)
             DCL        VAR(&PPST05) TYPE(*CHAR) LEN(40)

             CHKOBJ     OBJ(HFILE1/&PFILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(END))

             OVRDBF     FILE(INPUT) TOFILE(HFILE1/&PFILE)
             CALL       PGM(IZZR91) PARM(&PPST01 &PPST02 &PPST03 +
                          &PPST04 &PPST05)
             MONMSG     MSGID(CPF4101)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM

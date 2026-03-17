             PGM
             /** ADAC99 **************************************/
             /*    CREATE APICS KANBAN FILE FROM AH#PP11     */
             /************************************** ADAC99 **/

             DCL        VAR(&END) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PBIN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             DLTF       FILE(QTEMP/OUTF1)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/OUTF1) RCDLEN(256)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AH#WP98) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AH#WP98

             OVRDBF     FILE(AH#WP98) TOFILE(QTEMP/AH#WP98)

             CALL       PGM(ADAR98) PARM(&END &PDAT &PBIN)
             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))

             CALL       PGM(ADAR99) PARM(&PDAT &PBIN)

             CALL       PGM(QUILNGTX) PARM('Data has been created in +
                          QTEMP/OUTF1. Please copy it to your FILE +
                          for processing.' X'00000052' '       ' +
                          '                    ' X'00000000')

  @END:
             DLTOVR *ALL


             ENDPGM

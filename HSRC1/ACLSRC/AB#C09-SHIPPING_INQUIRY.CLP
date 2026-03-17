             PGM
             /** AB#C09 ***************************/
             /*   SHIPPING INQUIRY                */
             /*           NOV/21/01         TCH   */
             /* -------------------               */
             /* JW1  2022.11.29  DELETED AGAR00   */
             /*************************************/

             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4) VALUE('0000')
             DCL        VAR(&FROM) TYPE(*CHAR) LEN(8) VALUE('00000000')
             DCL        VAR(&TO  ) TYPE(*CHAR) LEN(8) VALUE('00000000')
             DCL        VAR(&NOBN) TYPE(*CHAR) LEN(2) VALUE('00')
             DCL        VAR(&NKOJ) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(4) VALUE('    ')

             DLTF       FILE(QTEMP/AB#WP09)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WP09) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WP09)

             OVRDBF     FILE(AB#WP09) TOFILE(QTEMP/AB#WP09)

  /*JW*****  CALL  PGM(AB#R09)                                           *****/
  /*JW*****  CALL  PGM(AB#R09B) PARM(&NONY &FROM &TO &NOBN &NKOJ &NUKE)  *****/

             CALL  PGM(AB#R09D) PARM(&NONY &FROM &TO &NOBN &NKOJ &NUKE)



             ENDPGM

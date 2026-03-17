             PGM
             /** ABBC97 ********************************/
             /*  TRANSFER INVENTORY DATA TO IFS.CSV    */
             /*  JW1      2021.09.07                   */
             /******************************************/

             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&CSV )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ADDR)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SIRE)  TYPE(*CHAR) LEN(4)

             CHKOBJ     OBJ(QTEMP/ABBWP97) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(ABBWP97) +
                          FROMLIB(*LIBL) OBJTYPE(*FILE) TOLIB(QTEMP))
             CHKOBJ     OBJ(QTEMP/ABBWP97B) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(ABBWP97B) +
                          FROMLIB(*LIBL) OBJTYPE(*FILE) TOLIB(QTEMP))

             CLRPFM     FILE(QTEMP/ABBWP97)
             CLRPFM     FILE(QTEMP/ABBWP97B)

             OVRDBF     FILE(ABBWP90 ) TOFILE(*LIBL/ABBWP90 )
             OVRDBF     FILE(ABBWP97 ) TOFILE(QTEMP/ABBWP97 )
             OVRDBF     FILE(ABBWP97B) TOFILE(QTEMP/ABBWP97B)

             CALL       PGM(ABBR97)

      /****  GOTO ENDP ****/

             CHGVAR     VAR(&TYPE) VALUE('2')
      /**    CHGVAR     VAR(&FILE) VALUE('ABBWP97 ')  **/
/*JW*/       CHGVAR     VAR(&FILE) VALUE('ABBWP97B')
             CHGVAR     VAR(&LIBL) VALUE('QTEMP')
             CHGVAR     VAR(&FNAM) VALUE('DAYINV')
             CHGVAR     VAR(&CSV ) VALUE('Y')
             CHGVAR     VAR(&ADDR) VALUE(' ')
             CHGVAR     VAR(&MSG ) VALUE('Y')

             CALL   PGM(APLC94) PARM(&TYPE &FILE &LIBL &FNAM &CSV &ADDR &MSG)

 ENDP:       DLTOVR     FILE(*ALL)

             ENDPGM

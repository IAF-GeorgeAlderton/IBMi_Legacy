             PGM

  /** ACMC001   **********************************/
  /* AUTO COMPILE PROGRAMS USING SPECIFIC FILE   */
  /*    LEC       2022.10.06                     */
  /***********************************************/

             DCLF       FILE(ACMPW00)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO ENDP

             IF         COND((&FILNAM *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER FILE NAME')
             GOTO       STP1
             ENDDO

             CHKOBJ     OBJ(&FILNAM) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('INVALID FILE NAME')
             GOTO       STP1
             ENDDO

             IF         COND((&TOLIB *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER LIBRARY NAME')
             GOTO       STP1
             ENDDO

             CHKOBJ     OBJ(&TOLIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('INVALID LIBRARY NAME')
             GOTO       STP1
             ENDDO

  /*******************************************************************/
  /* press F5 to process auto-compile...                             */

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(STP1))

             ADDLIBLE   LIB(BACKUP)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

  /*******************************************************************/
  /* process list of programs using the specified file...            */
             CALL       PGM(ACMR001) PARM(&FILNAM &TOLIB)

  /*******************************************************************/
             RMVLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)


 ENDP:       ENDPGM

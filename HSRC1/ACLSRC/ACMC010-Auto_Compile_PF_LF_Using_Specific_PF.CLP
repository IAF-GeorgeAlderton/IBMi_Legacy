             PGM
  /**ACMC010   **********************************/
  /* AUTO COMPILE PF/LF USING SPECIFIC PF       */
  /* JW   2022.10.11                            */
  /**********************************************/
             DCLF       FILE(ACMPW10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)

             CALL       PGM(UTLR07D) PARM('ACMC010' 'START ACMC010')

             RTVJOBA    JOB(&WSID)
/* DEFAULT */
             CHGVAR     VAR(&PF )    VALUE('AB#PP10')
             CHGVAR     VAR(&OBJLIB) VALUE('TFILE1 ')
             CHGVAR     VAR(&DDSF  ) VALUE('ADDSSRC')
             CHGVAR     VAR(&SRCLIB) VALUE('HSRC1  ')

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')
             CHGVAR     VAR(&IN43) VALUE('0')
             CHGVAR     VAR(&IN44) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO ENDP
 /*PF*/
             IF         COND((&PF *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER FILE NAME')
             GOTO       STP1
             ENDDO

             CHKOBJ     OBJ(&PF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('INVALID FILE NAME')
             GOTO       STP1
             ENDDO
 /*OBJLIB*/
             IF         COND((&OBJLIB *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER LIBRARY NAME')
             GOTO       STP1
             ENDDO

             CHKOBJ     OBJ(&OBJLIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('INVALID LIBRARY NAME')
             GOTO       STP1
             ENDDO
 /*DDSF*/
             IF         COND((&DDSF *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN43) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER DDS FILE NAME')
             GOTO       STP1
             ENDDO

             CHKOBJ     OBJ(&DDSF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&IN43) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('INVALID DDS FILE NAME')
             GOTO       STP1
             ENDDO
 /*SRCLIB*/
             IF         COND((&SRCLIB *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN44) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER SOURCE LIBRARY')
             GOTO       STP1
             ENDDO

             CHKOBJ     OBJ(&SRCLIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&IN44) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('INVALID SOURCE LIBRARY')
             GOTO       STP1
             ENDDO

             CHGVAR     VAR(&XMSG) VALUE('PRESS F5 TO CONTINUE...')

  /*******************************************************************/
  /* Press F5 To Process Auto-Compile...                             */

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(STP1))

  /*******************************************************************/
  /* Save &OBJLIB/&PF to BACKUP/&PF                                 */

             CHGLIBL    CURLIB(&OBJLIB)

             MONMSG     MSGID(CPF0000)

             DLTF       FILE(BACKUP/&PF)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(&OBJLIB/&PF) TOFILE(BACKUP/&PF) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

  /*******************************************************************/
  /* Delete &OBJLIB/LF                                                */
             CALL       PGM(ACMR011 ) PARM(&PF &OBJLIB)

             DLTF       FILE(&OBJLIB/&PF)

  /*******************************************************************/
  /* Compile &OBJLIB/&PF and &OBJLIB/LF                                */

/* FOR TEST */
     /**     RMVLIBLE   LIB(HFILE1)        **/
     /**     MONMSG     MSGID(CPF0000)     **/

             ADDLIBLE   LIB(&OBJLIB)
             MONMSG     MSGID(CPF0000)


             CRTPF      FILE(&OBJLIB/&PF) SRCFILE(&SRCLIB/&DDSF) +
                          SIZE(999999999 10000)

             CALL       PGM(ACMR012 ) PARM(&PF &OBJLIB &DDSF &SRCLIB)

/* FOR TEST */
             RMVLIBLE   LIB(&OBJLIB)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(HFILE1)
             MONMSG     MSGID(CPF0000)

  /*******************************************************************/
  /* restore &OBJLIB/&PF from BACKUP/&PF                            */

             CPYF       FROMFILE(BACKUP/&PF) TOFILE(&OBJLIB/&PF) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*MAP +
                          *DROP)
             MONMSG     MSGID(CPF2869 CPF2817)

             CALL       PGM(UTLR07D) PARM('ACMC010' 'END   ACMC010')

  /*******************************************************************/

 ENDP:       ENDPGM

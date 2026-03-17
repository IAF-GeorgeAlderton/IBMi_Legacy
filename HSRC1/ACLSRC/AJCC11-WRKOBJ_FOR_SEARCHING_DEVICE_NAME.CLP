             PGM
             /** AJCC11 ***********************/
             /*  ..WRKOBJ                     */
             /*     T-SAKAKI     15.07.16     */
             /*********************** AJCC11 **/
              DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
              DCL        VAR(&DEVNA) TYPE(*CHAR) LEN(5)
              DCL        VAR(&DEVNB) TYPE(*CHAR) LEN(5)
              DCLF       FILE(AJCPW11)
              RTVJOBA    JOB(&WSID)

  STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AJCPW111)

              IF         (&IN01 = '1') GOTO END
              CHGVAR     VAR(&@ERR) VALUE(' ')
              CHGVAR     VAR(&IN99) VALUE('0')

              IF         (&@DEVN = ' ') GOTO STP1

             CHGVAR     VAR(&DEVNA) VALUE(&@DEVN *TCAT 'SS1')
             CHKOBJ     OBJ(QSYS/&DEVNA) OBJTYPE(*DEVD)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&@ERR) VALUE('YOU CAN USE THE NAME')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO STP1
             ENDDO

             CHGVAR     VAR(&DEVNB) VALUE(&@DEVN *TCAT 'SS*')
             WRKOBJ     OBJ(QSYS/&DEVNB) OBJTYPE(*DEVD)
             MONMSG     MSGID(CPF0000)
             GOTO       STP1
  END:
             ENDPGM

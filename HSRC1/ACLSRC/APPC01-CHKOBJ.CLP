             PGM        PARM(&LIBL &FILE &MBR &FLG)
             /** YA610C ************************************/
             /* CHKOBJ                                   */
             /*      T.SAKASHITA           2014.03.07      */
             /************************************ YA004C **/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)

             DCL        VAR(&FLG) TYPE(*CHAR) LEN(2)

             CHGVAR     VAR(&FLG) VALUE('  ')

             IF         COND(&LIBL *EQ ' ') THEN(DO)
             CHGVAR     VAR(&FLG) VALUE('NG')
             GOTO       CMDLBL(@END)
             ENDDO

             IF         COND(&FILE *EQ ' ') THEN(DO)
             CHGVAR     VAR(&FLG) VALUE('NG')
             GOTO       CMDLBL(@END)
             ENDDO

             IF         COND(&MBR *EQ ' ') THEN(DO)
             CHGVAR     VAR(&FLG) VALUE('NG')
             GOTO       CMDLBL(@END)
             ENDDO

             CHKOBJ     OBJ(&LIBL/&FILE) OBJTYPE(*FILE) MBR(&MBR)
             MONMSG     MSGID(CPF9810) EXEC(DO)
             CHGVAR     VAR(&FLG) VALUE('NG')
             ENDDO
             MONMSG     MSGID(CPF9815) EXEC(DO)
             CHGVAR     VAR(&FLG) VALUE('NG')
             ENDDO
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&FLG) VALUE('NG')
             ENDDO
@END:
             ENDPGM

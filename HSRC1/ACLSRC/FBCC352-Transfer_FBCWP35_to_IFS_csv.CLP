             PGM
             /** FBCC352 ***********************************/
             /*  DOWNLOAD FBCWP35 TO CSV                   */
             /*  JW     2020.06.23                       */
             /**********************************************/

             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&CSV )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ADDR)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG )  TYPE(*CHAR) LEN(1)

             CHKOBJ     OBJ(HWFILE1/FBCWP35) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO ENDP)

             CHGVAR     VAR(&TYPE) VALUE('2')
             CHGVAR     VAR(&FILE) VALUE('FBCWP35')
             CHGVAR     VAR(&LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&FNAM) VALUE('SALES EXPANSION MASTER')
             CHGVAR     VAR(&CSV ) VALUE('Y')
             CHGVAR     VAR(&ADDR) VALUE(' ')
             CHGVAR     VAR(&MSG ) VALUE('Y')

             CALL   PGM(APLC94) PARM(&TYPE &FILE &LIBL &FNAM &CSV &ADDR &MSG)

ENDP:
             ENDPGM

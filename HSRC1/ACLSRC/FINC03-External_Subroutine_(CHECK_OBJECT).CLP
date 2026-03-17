             PGM        PARM(&LIBL &FILE &TYPE &CHEK)
             /** FINC03 ****************************************/
             /*   ..文字列検索ＰＧＭ..                       */
             /*       A.MAMIYA                2001.05.09       */
             /**************************************** FINC03 **/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CHEK) TYPE(*CHAR) LEN(1)

             CHKOBJ     OBJ(&LIBL/&FILE) OBJTYPE(&TYPE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&CHEK) +
                          VALUE('*'))

             ENDPGM

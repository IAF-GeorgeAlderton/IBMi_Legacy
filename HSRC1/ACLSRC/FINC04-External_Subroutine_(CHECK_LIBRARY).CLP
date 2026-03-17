             PGM        PARM(&LIBL  &CHEK)
             /** FINC04 ****************************************/
             /*   ..文字列検索ＰＧＭ..                       */
             /*       A.MAMIYA                2001.05.09       */
             /**************************************** FINC04 **/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHEK) TYPE(*CHAR) LEN(1)

             RTVLIBD    LIB(&LIBL) TYPE(&TYPE)
             MONMSG     MSGID(CPF9810) EXEC(CHGVAR VAR(&CHEK) +
                          VALUE('*'))

             ENDPGM

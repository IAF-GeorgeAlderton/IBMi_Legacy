             PGM        PARM(&LIBL &OBJ &SRCDATE)
             /** VVVCY3 **********************************/
             /*ソースレベルアンマッチ表示              */
             /* T.SAKASHITA 2012.06.01                   */
             /********************************************/

             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ) TYPE(*CHAR) LEN(10)

             DCL        VAR(&SRCDATE) TYPE(*CHAR) LEN(13)

             DCL        VAR(&SRCDATE) TYPE(*CHAR) LEN(13)

             RTVOBJD    OBJ(&LIBL/&OBJ) OBJTYPE(*PGM) SRCDATE(&SRCDATE)
             MONMSG     MSGID(CPF9999)

             ENDPGM

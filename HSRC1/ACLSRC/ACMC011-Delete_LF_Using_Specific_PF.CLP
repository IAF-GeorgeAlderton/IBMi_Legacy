             PGM        PARM(&LF &OBJLIB)
             /********************************/
             /* DELETE LF USING SPECIFIC PF  */
             /* JW   2022.10.11              */
             /********************************/
             DCL        VAR(&LF)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJLIB) TYPE(*CHAR) LEN(10)

             DLTF       FILE(&OBJLIB/&LF)
             MONMSG     MSGID(CPF0000)

             ENDPGM

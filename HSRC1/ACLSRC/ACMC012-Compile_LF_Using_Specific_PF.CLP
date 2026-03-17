             PGM        PARM(&LF &OBJLIB &DDSF &SRCLIB &STS)
             /********************************/
             /* COMPILE LF USING SPECIFIC PF */
             /* JW   2022.10.11              */
             /********************************/
             DCL        VAR(&LF)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDSF  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STS)    TYPE(*CHAR) LEN(1)

             CRTLF      FILE(&OBJLIB/&LF) SRCFILE(&SRCLIB/&DDSF)
             MONMSG     MSGID(CPF0000)

             ENDPGM

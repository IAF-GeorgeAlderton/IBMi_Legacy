             PGM        PARM(&PSIRE &PDELY &PFACT &PDOCK &PNODT +
                          &PORD# &PBIN)
             /** AB#C2H *******************************/
             /*  CONTROL OF CREATE AGAI LABEL PROGRAM */
             /*  TCH 2000.07.20                       */
             /*  TCH 2000.09.28 ADD ORDER #           */
             /***************************** AB#C2H ****/
             DCL        VAR(&PSIRE)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDELY)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFACT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDOCK)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNODT)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PORD#)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PBIN)    TYPE(*DEC)  LEN(2 0)

             IF         (&PDELY *EQ '3892') THEN(DO)

             CLRPFM     FILE(AB#WP2H)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(AB#WP2K)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(AB#R2H) PARM(&PSIRE &PDELY &PFACT &PDOCK +
                          &PNODT)
             GOTO       END
             ENDDO


             IF         (&PDELY *EQ '1431') THEN(DO)
             CLRPFM     FILE(AB#WP2M)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(AB#R2M) PARM(&PSIRE &PDELY &PFACT &PDOCK +
                          &PNODT)
             GOTO       END
             ENDDO


             CLRPFM     FILE(AB#WP2I)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(AB#R2I) PARM(&PSIRE &PDELY &PFACT &PDOCK +
                          &PNODT &PORD# &PBIN)

 END:
             ENDPGM

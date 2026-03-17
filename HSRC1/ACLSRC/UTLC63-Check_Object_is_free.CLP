             PGM              PARM(&OBJ &RTN)
             /** UTLC63 ******************************************/
             /*  UTILITY- CHECK OBJECT                           */
             /*  JW1: J-WATANABE             2019.10.11          */
             /****************************************************/
             DCL        VAR(&OBJ ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&RTN) VALUE(' ')
             ALCOBJ     OBJ((HFILE1/&OBJ *FILE *EXCLRD)) WAIT(1)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&RTN) VALUE('N')
             GOTO ENDP
             ENDDO

             DLCOBJ     OBJ((HFILE1/&OBJ *FILE *EXCLRD))

             CALL       PGM(UTLR63) PARM(&OBJ &RTN)

ENDP:        ENDPGM

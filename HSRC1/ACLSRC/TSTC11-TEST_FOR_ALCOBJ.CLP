 PGM
             ALCOBJ     OBJ((TFILE1/EDIPP42 *FILE *EXCLRD)) WAIT(1)

             MONMSG     MSGID(CPF0000) EXEC(DO)
             CALL       PGM(QUILNGTX) PARM('JOE IS WORKING NOW. +
             PLEASE TRY IT AGAIN IN ONE MINUTE. THANK +
             YOU. ' X'00000046' '       ' +
              '                    ' X'00000000')
             GOTO ENDP
             ENDDO


             DLYJOB     DLY(30)


             DLCOBJ OBJ((TFILE1/EDIPP42 *FILE *EXCLRD))

ENDP:
             ENDPGM

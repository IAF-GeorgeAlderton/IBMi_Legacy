 PGM
             DLCOBJ OBJ((TFILE1/EDIPP42 *FILE *EXCLRD))

             MONMSG     MSGID(CPF0000) EXEC(DO)
             CALL       PGM(QUILNGTX) PARM('JOE IS WORKING NOW. +
             PLEASE TRY IT AGAIN IN ONE MINUTE. THANK +
             YOU. ' X'00000046' '       ' +
              '                    ' X'00000000')
             ENDDO

             ENDPGM

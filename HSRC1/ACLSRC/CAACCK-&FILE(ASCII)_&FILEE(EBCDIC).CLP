             PGM        PARM(&FILE &DTBN)

             DCL        VAR(&ATCWFILE) TYPE(*CHAR) LEN(10)

             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILEE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTBN)  TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&ATCWFILE) VALUE('HWFILE1')

             CHGVAR     VAR(&FILEE) VALUE(&FILE *TCAT 'E')

             CHKOBJ     OBJ(&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&DTBN) VALUE('CPF9801')
             GOTO       CMDLBL(@END)
             ENDDO

             DLTF       FILE(&FILEE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&ATCWFILE/&FILEE) RCDLEN(3072)

             /* &FILE(ASCII) -> &FILEE(EBCDIC) */
             OVRDBF     FILE(INPUT) TOFILE(&FILE)
             OVRDBF     FILE(OUTPUT) TOFILE(&FILEE)
             CALL       PGM(CAAR82)

             OVRDBF     FILE(INPUT) TOFILE(&FILEE)
             CALL       PGM(CAARCK) PARM(&DTBN)
             DLTOVR     FILE(INPUT)
@END:
             ENDPGM

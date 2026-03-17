             PGM        PARM(&ODOBNM &ODOBAT &WSRCF)
             DCL        VAR(&ODOBNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ODOBAT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSRCF) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PTYP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PTX) TYPE(*CHAR) LEN(50)

             CHGVAR     VAR(&PTYP) VALUE(%SST(&ODOBAT 1 5))

             OVRDBF     FILE(SRCFILE) TOFILE(HSRC1/&WSRCF) MBR(&ODOBNM)
             CALL       PGM(AJFR06) PARM(&PTYP &PTX)
             DLTOVR     FILE(SRCFILE)

             IF         (&ODOBAT *EQ 'DSPF') DO
             CHGDSPF    FILE(&ODOBNM) TEXT(&PTX)
             MONMSG     MSGID(CPF9812 CPF7304)
             ENDDO

             IF         (&ODOBAT *EQ 'PRTF') DO
             CHGPRTF    FILE(&ODOBNM) TEXT(&PTX)
             MONMSG     MSGID(CPF9812 CPF7304)
             ENDDO

             ENDPGM

             PGM        PARM(&J1PGMN &LIB &LIBN)
             /** AJBC05 **************************/
             /* DATA BASE REFERENCE PROGRAM LIST */
             /*   I-HASADA            87.05.21   */
             /************************** AJBC05 **/
             DCL        VAR(&J1PGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(7)

             IF         (&LIB *EQ 'A') GOTO STP1
             IF         (&LIB *EQ 'D') GOTO STP1
             IF         (&LIB *EQ 'M') GOTO STP1
             IF         (&LIB *EQ 'R') GOTO STP1
             IF         (&LIB *EQ 'F') GOTO STP1
             IF         (&LIB *EQ 'T') GOTO STP1
             IF         (&LIB *EQ 'U') GOTO STP1
             IF         (&LIB *EQ 'B') GOTO STP1
             IF         (&LIB *EQ 'E') GOTO STP1
             IF         (&LIB *EQ 'N') GOTO STP1
             IF         (&LIB *EQ 'K') GOTO STP1
             IF         (&LIB *EQ 'G') GOTO STP1
             IF         (&LIB *EQ 'S') GOTO STP1
             IF         (&LIB *EQ 'V') GOTO STP1
             IF         (&LIB *EQ 'O') GOTO STP1
             IF         (&LIB *EQ 'I') GOTO STP1
             IF         (&LIB *EQ 'C') GOTO STP1
             IF         (&LIB *EQ 'J') GOTO STP1
             GOTO       END

 STP1:       CHGVAR     VAR(&WLIB) VALUE('HSRC1   ')

             CHGVAR     VAR(&SRCF) VALUE(&LIB *CAT 'RPGSRC')

             ALCOBJ     OBJ((&WLIB/&SRCF *FILE *SHRUPD &J1PGMN))
             MONMSG     MSGID(CPF0948 CPF1085 CPF1002) EXEC(GOTO +
                          CMDLBL(END))
             DLCOBJ     OBJ((&WLIB/&SRCF *FILE *SHRUPD &J1PGMN))

             OVRDBF     FILE(SOURCE) TOFILE(&WLIB/&SRCF) +
                          MBR(&J1PGMN) POSITION(*START)
             CALL       PGM(AJBR05) PARM(&LIBN &J1PGMN)
             MONMSG     MSGID(RPG0000 RPG0202 CPF4102 RPG1216)
             DLTOVR     FILE(SOURCE)

 END:        RETURN

             ENDPGM

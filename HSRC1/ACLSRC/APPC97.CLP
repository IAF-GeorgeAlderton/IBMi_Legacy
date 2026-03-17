             PGM        PARM(&FILE)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHGDATE) TYPE(*CHAR) LEN(13)

             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10) VALUE('WEEKDLT')

             DCL        VAR(&FILES) TYPE(*CHAR) LEN(9) VALUE(' ')

             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILE4) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILE5) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILE6) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILE7) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILE8) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILE9) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEA) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEB) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEC) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILED) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEE) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEF) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEG) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEH) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEI) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEJ) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEK) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEL) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEM) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FILEN) TYPE(*CHAR) LEN(10) VALUE(' ')

             CHGVAR     VAR(&FILES) VALUE(%SST(&FILE 1 9))

             CHGVAR     VAR(&FILE1) VALUE('A' *CAT &FILES)
             CHGVAR     VAR(&FILE2) VALUE('B' *CAT &FILES)
             CHGVAR     VAR(&FILE3) VALUE('C' *CAT &FILES)
             CHGVAR     VAR(&FILE4) VALUE('D' *CAT &FILES)
             CHGVAR     VAR(&FILE5) VALUE('E' *CAT &FILES)
             CHGVAR     VAR(&FILE6) VALUE('F' *CAT &FILES)
             CHGVAR     VAR(&FILE7) VALUE('G' *CAT &FILES)
             CHGVAR     VAR(&FILE8) VALUE('H' *CAT &FILES)
             CHGVAR     VAR(&FILE9) VALUE('I' *CAT &FILES)

             CHGVAR     VAR(&FILEA) VALUE('J' *CAT &FILES)
             CHGVAR     VAR(&FILEB) VALUE('K' *CAT &FILES)
             CHGVAR     VAR(&FILEC) VALUE('L' *CAT &FILES)
             CHGVAR     VAR(&FILED) VALUE('M' *CAT &FILES)
             CHGVAR     VAR(&FILEE) VALUE('N' *CAT &FILES)
             CHGVAR     VAR(&FILEF) VALUE('O' *CAT &FILES)
             CHGVAR     VAR(&FILEG) VALUE('P' *CAT &FILES)
             CHGVAR     VAR(&FILEH) VALUE('Q' *CAT &FILES)
             CHGVAR     VAR(&FILEI) VALUE('R' *CAT &FILES)
             CHGVAR     VAR(&FILEJ) VALUE('S' *CAT &FILES)
             CHGVAR     VAR(&FILEK) VALUE('T' *CAT &FILES)
             CHGVAR     VAR(&FILEL) VALUE('U' *CAT &FILES)
             CHGVAR     VAR(&FILEM) VALUE('V' *CAT &FILES)
             CHGVAR     VAR(&FILEN) VALUE('W' *CAT &FILES)
FILE8:
             CHKOBJ     OBJ(&LIBL/&FILE8) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(FILE7))
             DLTF       FILE(&LIBL/&FILE9)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(&LIBL/&FILE8) TOFILE(&LIBL/&FILE9) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2869 CPF2817)
FILE7:
             CHKOBJ     OBJ(&LIBL/&FILE7) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(FILE6))
             DLTF       FILE(&LIBL/&FILE8)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(&LIBL/&FILE7) TOFILE(&LIBL/&FILE8) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2869 CPF2817)
FILE6:
             CHKOBJ     OBJ(&LIBL/&FILE6) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(FILE5))
             DLTF       FILE(&LIBL/&FILE7)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(&LIBL/&FILE6) TOFILE(&LIBL/&FILE7) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2869 CPF2817)
FILE5:
             CHKOBJ     OBJ(&LIBL/&FILE5) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(FILE4))
             DLTF       FILE(&LIBL/&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(&LIBL/&FILE5) TOFILE(&LIBL/&FILE6) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2869 CPF2817)
FILE4:
             CHKOBJ     OBJ(&LIBL/&FILE4) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(FILE3))
             DLTF       FILE(&LIBL/&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(&LIBL/&FILE4) TOFILE(&LIBL/&FILE5) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2869 CPF2817)
FILE3:
             CHKOBJ     OBJ(&LIBL/&FILE3) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(FILE2))
             DLTF       FILE(&LIBL/&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(&LIBL/&FILE3) TOFILE(&LIBL/&FILE4) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2869 CPF2817)
FILE2:
             CHKOBJ     OBJ(&LIBL/&FILE2) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(FILE1))
             DLTF       FILE(&LIBL/&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(&LIBL/&FILE2) TOFILE(&LIBL/&FILE3) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2869 CPF2817)
FILE1:
             CHKOBJ     OBJ(&LIBL/&FILE1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@END))
             DLTF       FILE(&LIBL/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(&LIBL/&FILE1) TOFILE(&LIBL/&FILE2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2869 CPF2817)
@END:
             DLTF       FILE(&LIBL/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(&FILE) TOFILE(&LIBL/&FILE1) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2869 CPF2817)

             RTVMBRD    FILE(&FILE) CHGDATE(&CHGDATE)
             CHGOBJD    OBJ(&LIBL/&FILE1) OBJTYPE(*FILE) TEXT(&CHGDATE)

             ENDPGM

             PGM        PARM(&MSG0 &MSG1)
             /** IBKC13 *****************************/
             /*  .RECEIVE FILES FROM ASJ        ..  */
             /*     T-SAKAKI         2023.01.18     */
             /***************************** IBKC13 **/
             DCL        VAR(&MSG0) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(50)

             DCL        VAR(&NULL) TYPE(*CHAR) LEN(1) VALUE(X'00')

             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RLIB) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&LIBL) VALUE(&MSG0 *TCAT &NULL)
             CHGVAR     VAR(&FILE) VALUE(&MSG1 *TCAT &NULL)
             CHGVAR     VAR(&RLIB) VALUE('HWFILE1   ')

             CLRPFM     FILE(&RLIB/&FILE)
             MONMSG     MSGID(CPF3142)

             RSTOBJ     OBJ(&FILE) SAVLIB(&LIBL) DEV(*SAVF) +
                          OBJTYPE(*FILE) SAVF(WEEKDLT/&FILE) +
                          MBROPT(*ALL) ALWOBJDIF(*ALL) +
                          FRCOBJCVN(*YES) RSTLIB(&RLIB)
             MONMSG     MSGID(CPF3773)

   /* TEST */
             CPYF       FROMFILE(&RLIB/&FILE) TOFILE(SAKAKI/&FILE) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FROMRCD(1) +
                          TORCD(1) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
             CHGPF      FILE(SAKAKI/&FILE) SIZE(1000000)
             CPYF       FROMFILE(&RLIB/&FILE) TOFILE(SAKAKI/&FILE) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)

   /* TEST */
             IF         COND(&FILE = 'FCQWP11   ') THEN(GOTO STP01)
             IF         COND(&FILE = 'FCQWP21   ') THEN(GOTO STP02)
             IF         COND(&FILE = 'FCQWP31   ') THEN(GOTO STP03)
             IF         COND(&FILE = 'FCGPP51   ') THEN(GOTO STP04)
             IF         COND(&FILE = 'FOAWP01   ') THEN(GOTO STP05)
             IF         COND(&FILE = 'FOAWP02   ') THEN(GOTO STP06)
             IF         COND(&FILE = 'FOAWP03   ') THEN(GOTO STP07)

      /* RECEIVE 3 FILES,THEN UPDATE */
             IF         COND(&FILE = 'GCQWP3Y   ') THEN(GOTO END2)
             IF         COND(&FILE = 'CCQWP4Y   ') THEN(GOTO END2)
             IF         COND(&FILE = 'CCQWP4Z   ') THEN(GOTO STP08)

         /**********************/
         /* FCQWP11 -> FCQPP11 */
         /**********************/
 STP01:      CALL       PGM(IBKR01)
             GOTO CMDLBL(END)

         /**********************/
         /* FCQWP21 -> FCQPP21 */
         /**********************/
 STP02:      CALL       PGM(IBKR02)
             GOTO CMDLBL(END)

         /**********************/
         /* FCQWP31 -> FCQPP31 */
         /**********************/
 STP03:      CALL       PGM(IBKR04)
             GOTO CMDLBL(END)

         /**********************/
         /* FCGPP51   CPYF     */
         /**********************/
 STP04:      CPYF       FROMFILE(&RLIB/FCGPP51) +
                          TOFILE(HFILE1/FCGPP51) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             GOTO CMDLBL(END)

         /**********************/
         /* FOAWP01 -> FOAPP01 */
         /**********************/
 STP05:      CALL       PGM(IBKR06)
             GOTO CMDLBL(END)

         /**********************/
         /* FOAWP02 -> FOAPP02 */
         /**********************/
 STP06:      CALL       PGM(IBKR07)
             GOTO CMDLBL(END)

         /**********************/
         /* FOAWP03 -> FOAPP03 */
         /**********************/
 STP07:      CALL       PGM(IBKR08)
             GOTO CMDLBL(END)

         /**********************/
         /* GCQWP3Y -> GCQWP3Z  &  (CCQWP4Y,Z -> WK400P0,WK420P0) */
         /**********************/
 STP08:      CALL       PGM(GCQR3W)
             RGZPFM     FILE(WK400P0)
             MONMSG     MSGID(CPF0000)
             RGZPFM     FILE(WK420P0)
             MONMSG     MSGID(CPF0000)
             GOTO CMDLBL(END)

 END:
             CLRPFM     FILE(&RLIB/&FILE)

 END2:
             ENDPGM

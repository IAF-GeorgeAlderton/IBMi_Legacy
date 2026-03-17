             /** UTLC91 *************************************************/
             /*  UTILITY - REMOVE FILE MEMBERS BY DATE                  */
             /*  JW1: J.WATANABE       2018.09.24                       */
             /*  REMOVE MEMBER IF CREATE DATE IS LESS THAN TARGET DATE  */
             /*---------------------------------------------------------*/
             /*  CALLING SEQ.                                           */
             /*                    CALL 'UTLC91'                        */
             /*                    PARM           $DATE   8             */
             /*                    PARM           $FILE  10             */
             /*                    PARM           $LIB   10             */
             /*   IN  $DATE:  8A TARGET DATE (YYYYMMDD)                 */
             /*       $FILE  10A TARGET FILE                            */
             /*       $LIB   10A TARGET LIBRARY                         */
             /***********************************************************/

 CLRARCHMBR: PGM        PARM(&DATE &FILE &LIB)

             DCLF       FILE(HWFILE1/DSPFD)
             DCL        VAR(&DATE)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&DAT6)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB )    TYPE(*CHAR) LEN(10)

             DCL        VAR(&MM)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&DD)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&BADDATE) TYPE(*CHAR) LEN(40)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL7)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&FILX)    TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER) TYPE(&TYPE)

             CHGVAR     VAR(&FIL7) VALUE(%SST(&FILE 1 7))
             CHGVAR     VAR(&FILX) VALUE(&FIL7)
             CHGVAR     VAR(&DAT6) VALUE(%SST(&DATE 3 6))
             CHGVAR     VAR(&MM)   VALUE(%SST(&DAT6 3 2))
             CHGVAR     VAR(&DD)   VALUE(%SST(&DAT6 5 2))

             IF         COND(&MM < '01' *OR &MM > '12' +
                        *OR &DD < '01' *OR &DD > '31') +
                        THEN(DO)

             CHGVAR     VAR(&BADDATE) VALUE('CLRARCMBR: ' *CAT &DAT6 +
                          *CAT ' IS NOT A VALID DATE')

             IF         COND(&TYPE *EQ '1') THEN(DO)
             CALL       PGM(QUILNGTX) PARM(&BADDATE X'00000030' +
                          '       ' '                    ' X'00000000')
             GOTO       CMDLBL(END)
             ENDDO

             IF         (&TYPE *EQ '0') THEN(DO)
             SNDMSG     MSG(&BADDATE) TOUSR(&USER)
             GOTO       CMDLBL(END)
             ENDDO

             ENDDO

             DLTF       FILE(HWFILE1/DSPFD)
             MONMSG     MSGID(CPF0000)

             DSPFD      FILE(&LIB/&FILE) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(HWFILE1/DSPFD)

 READ:       RCVF       DEV(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))

       /***  IF         COND(&MLCDAT *GE &DAT6) THEN(DO)  ***/
       /***  GOTO       CMDLBL(END)                       ***/
       /***  ENDDO                                        ***/

             IF         COND(&MLNAME *NE &FILX) THEN(DO)
             IF         COND(&MLCDAT *LT &DAT6) THEN(DO)
             RMVM       FILE(&LIB/&FILE) MBR(&MLNAME)
             MONMSG     MSGID(CPF0000)
             ENDDO
             ENDDO

             GOTO       CMDLBL(READ)

 END:        ENDPGM

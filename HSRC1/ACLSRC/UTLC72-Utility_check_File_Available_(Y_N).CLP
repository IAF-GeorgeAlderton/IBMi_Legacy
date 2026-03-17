             PGM        PARM(&FILE &LIB &RTN)
             /** UTLC72 *********************************************/
             /*  UTILITY - CHECK FILE AVAILABLE (Y/N)               */
             /*  JW1: J-WATANABE             2019.03.25             */
             /*  PARAMETER:                                         */
             /*         IN: &FILE (10A) FILE NAME                   */
             /*             &LIB  (10A) LIBRARY                     */
             /*        OUT: &RTN  (1A ) Y=AVAILAVE, N=NOT AVAILABE  */
             /*******************************************************/
             DCL        VAR(&FILE ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1 )

             ALCOBJ     OBJ((&LIB/&FILE *FILE *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(DO)
             CHGVAR     VAR(&RTN) VALUE('N')
             GOTO       CMDLBL(ENDP)
             ENDDO

             CHGVAR     VAR(&RTN) VALUE('Y')

             DLCOBJ     OBJ((&LIB/&FILE *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
ENDP:
             ENDPGM

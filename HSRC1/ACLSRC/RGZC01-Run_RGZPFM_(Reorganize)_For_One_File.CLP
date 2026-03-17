             PGM        PARM(&FILE &LIB &PGM)
             /** RGZC01 ***********************************/
             /*  RUN RGZPFM (REORGANIZE)                  */
             /*  J.WATANAE  2019.03.25                    */
             /*  ==========                               */
             /*  PARAMETER:                               */
             /*    &FILE  10A  FILE TO BE REORGANIZED     */
             /*    &LIB   10A  LIBRARY                    */
             /*    &PGM   10A  PROGRAM NAME FOR LOF FILE  */
             /*********************************************/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1 )


/* CHECK FILE AVAILABLE */
             CALL       PGM(UTLC72) PARM(&FILE &LIB &RTN)

             IF         COND(&RTN *NE 'Y') THEN(DO)
             CALL       PGM(CHKR72) PARM(&FILE &LIB &PGM 'NRG')
             GOTO       CMDLBL(ENDP)
             ENDDO

             IF         COND(&RTN *EQ 'Y') THEN(DO)
             RGZPFM     FILE(&LIB/&FILE)
             CALL       PGM(CHKR72) PARM(&FILE &LIB &PGM 'RGZ')
             ENDDO

ENDP:
             ENDPGM

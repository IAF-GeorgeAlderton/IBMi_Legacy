             PGM        PARM(&LIB1 &OUT1 &DATE &LIB2 &OUT2)
             /*****************************************************/
             /*  PROGRAM: REMOVE OUTQ BY DATE                     */
             /*         : MOVE EACH SPOOL FILES FROM OUT1 TO OUT2 */
             /*         : BY DATE                                 */
             /*---------------------------------------------------*/
             /*  CALLING SEQ.                                     */
             /*                    CALL 'UTLC71'                  */
             /*                    PARM           $LIB1  10       */
             /*                    PARM           $OUT1  10       */
             /*                    PARM           $DATE   8       */
             /*                    PARM           $LIB2  10       */
             /*                    PARM           $OUT2  10       */
             /*   IN  $LIB1 : 10A LIBRARY OF OUTQ1 (EX. QUSRSYS ) */
             /*       $OUT1 : 10A MOVE FRO   OUTQ1 (EX. EPRINT1 ) */
             /*       $DATE :  8A TARGET DATE      (EX. 20190201) */
             /*       $LIB2 : 10A LIBRARY OF OUTQ2 (EX. QUSRSYS ) */
             /*       $OUT2 : 10A MOVE TO    OUTQ2 (EX. CLROUTQ ) */
             /*       ** IF $OUT2=BLANK, THEN CLROUTQ             */
             /*****************************************************/

             DCL        VAR(&LIB1 ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUT1 ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&LIB2 ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUT2 ) TYPE(*CHAR) LEN(10)

             DCL        VAR(&MSG )  TYPE(*CHAR) LEN(20)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

/* VALIDATE DATE */
             IF         COND(&DATE < '00000000') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('INVALID DATE!')
             GOTO       CMDLBL(ERROR)
             ENDDO

             IF         COND(&DATE > '21001231') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('INVALID DATE!')
             GOTO       CMDLBL(ERROR)
             ENDDO

/* SET LIBRARY   */
             IF         COND(&LIB1 = '          ') THEN(DO)
             CHGVAR     VAR(&LIB1) VALUE('*LIBL')
             ENDDO

/* PRINT OUTQ   */
             WRKOUTQ    OUTQ(&LIB1/&OUT1) OUTPUT(*PRINT)

             CPYSPLF    FILE(QPRTSPLQ) TOFILE(*LIBL/TXT132) +
                          SPLNBR(*LAST) CRTDATE(*LAST)
             MONMSG     MSGID(CPF3340) EXEC(DO)
             CHGVAR     VAR(&MSG) VALUE('INVALID SPOOL FILE!')
             GOTO       CMDLBL(ERROR)
             ENDDO

/* SET DEFAULT  */
             IF         COND(&OUT2 = '          ') THEN(DO)
             CHGVAR     VAR(&LIB2) VALUE('QUSRSYS')
             CHGVAR     VAR(&OUT2) VALUE('CLROUTQ')
             ENDDO

             CALL       PGM(UTLR71) PARM(&DATE &LIB2 &OUT2)
             GOTO       CMDLBL(ENDPGM)

 ERROR:      SNDPGMMSG  MSG(&MSG) TOMSGQ(&WSID) MSGTYPE(*INFO)

ENDPGM:      ENDPGM

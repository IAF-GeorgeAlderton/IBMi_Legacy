             PGM
             /** AIAC17 **********************/
             /*  DAILY MASTER DATA TRANSFER  */
             /*   I-HASADA      1997.04.16   */
             /********************** AIAC17 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PBMON) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKUBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PEROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDATE) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID)

             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&PBMON) VALUE('0111')
             CALL       PGM(AIAR18) PARM(&PBMON &PKUBN &PEROR &PDATE)

             IF         (%SWITCH(1XXXXXXX)) DO
             GOTO       END
             ENDDO

             CALL       PGM(AIAR17) PARM(&PEROR &PDATE)

             IF         (%SWITCH(X1XXXXXX)) DO
             GOTO       END
             ENDDO

             CHGVAR     VAR(&PKUBN) VALUE('*')
             CALL       PGM(AIAR18) PARM(&PBMON &PKUBN &PEROR &PDATE)

 END:        ENDPGM

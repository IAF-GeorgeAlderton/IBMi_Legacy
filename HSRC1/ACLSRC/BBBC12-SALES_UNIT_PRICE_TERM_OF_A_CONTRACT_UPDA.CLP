             PGM        PARM(&KUBN &TOKU &KOJO &ENHZ)
             /**BBBC12*************************************/
             /* SALES UNIT PRICE TERM OF A CONTRACT UPDATE LIST HANDLING */
             /*            POSTPONE EXIT DATE */
             /* PROGRAM ID. : BBBC12                      */
             /* CREATE DATE. : OCT.09,'90. */
             /* AUTHOR.              : K.NAKAMURA         */
             /*************************************BBBC12**/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KUBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TOKU) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOJO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&GALL) TYPE(*CHAR) LEN(6)
             DCL        VAR(&GDLT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&GUPD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RALL) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RDLT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RUPD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&US)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(BBBR12) PARM(&US &KUBN &TOKU &KOJO &ENHZ +
                          &GALL &GDLT &GUPD &RALL &RDLT &RUPD)

             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       END
             ENDDO

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)

             CALL       PGM(BBBR1B) PARM(&US &KUBN &TOKU &KOJO &ENHZ +
                          &GALL &GDLT &GUPD &RALL &RDLT &RUPD)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM

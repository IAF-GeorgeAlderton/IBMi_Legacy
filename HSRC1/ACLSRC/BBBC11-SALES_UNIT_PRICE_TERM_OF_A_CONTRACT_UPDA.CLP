             PGM        PARM(&KUBN &TOKU &KOJO &STHZ &ENHZ &RIRN)
             /**BBBC11*************************************/
             /* SALES UNIT PRICE TERM OF A CONTRACT UPDATE LIST HANDLING */
             /*         ONLY CHANGE TERM OF A CONTRACT  */
             /* PROGRAM ID. : BBBC11                      */
             /* CREATE DATE. : OCT.05,'90. */
             /* AUTHOR.              : K.NAKAMURA         */
             /*************************************BBBC11**/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KUBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TOKU) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOJO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ENHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RIRN) TYPE(*CHAR) LEN(1)
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

             CPYF       FROMFILE(BBCPP01) TOFILE(BBCNP02) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

             CPYF       FROMFILE(BBDPP01) TOFILE(BBDNP02) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

             IF         (&RIRN *EQ '0') DO
             CALL       PGM(BBBR11) PARM(&US &KUBN &TOKU &KOJO &STHZ +
                          &ENHZ &GALL &GDLT &GUPD &RALL &RDLT &RUPD)
             ENDDO
             ELSE       DO

             CALL       PGM(BBBR13) PARM(&US &KUBN &TOKU &KOJO &STHZ +
                          &ENHZ &GALL &GDLT &GUPD &RALL &RDLT &RUPD)
             ENDDO

             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       END
             ENDDO

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)

             CALL       PGM(BBBR1A) PARM(&US &KUBN &TOKU &KOJO &STHZ +
                          &ENHZ &GALL &GDLT &GUPD &RALL &RDLT &RUPD)

             DLTOVR     FILE(*ALL)

 END:        CLRPFM     FILE(BBCNP02)
             CLRPFM     FILE(BBDNP02)

             ENDPGM

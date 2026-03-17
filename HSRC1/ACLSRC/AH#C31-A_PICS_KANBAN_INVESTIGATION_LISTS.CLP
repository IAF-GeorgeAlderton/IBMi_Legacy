             PGM        PARM(&PSKJY &PSKHZ &PKOHZ &PTIME &PKOME +
                          &PHHIN &PHYMD &PHBIN)
             /** AH#C31 ********************************/
             /*  A-PICS KANBAN INVESTIGATION LISTS    */
             /* I-HASADA                88.10.05       */
             /* TCH 2000.06.14 CHANGE OUTQ TO QPRINTB  */
             /******************************** AH#C31 **/
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&PSKJY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSKHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PKOHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PTIME) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKOME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHHIN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&PHYMD) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PHBIN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PYMD1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PYMD2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL5) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL6) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL7) TYPE(*CHAR) LEN(9)

             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WS) USER(&USER)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABADS1 1 6))

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WSID) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FIL2) VALUE(AH#WP32 *CAT &WSID)
             CHGVAR     VAR(&FIL3) VALUE(AH#WP33 *CAT &WSID)
             CHGVAR     VAR(&FIL4) VALUE(AH#WP3A *CAT &WSID)
             CHGVAR     VAR(&FIL5) VALUE(AH#WP34 *CAT &WSID)
             CHGVAR     VAR(&FIL6) VALUE(AH#WP3B *CAT &WSID)
             CHGVAR     VAR(&FIL7) VALUE(AH#WP36 *CAT &WSID)

             CLRPFM     FILE(&FIL5)

             OVRDBF     FILE(AH#WP34) TOFILE(&FIL5)
             CALL       PGM(AH#R34) PARM(&PSKJY &PSKHZ &PKOHZ &PTIME +
                          &PKOME &PHHIN &PHYMD &PHBIN)

             CLRPFM     FILE(&FIL6)
             OVRDBF     FILE(AH#WP3B) TOFILE(&FIL6)
             CALL       PGM(AH#R36)

             CLRPFM     FILE(&FIL7)

             FMTDTA     INFILE((&WLIB/&FIL6)) OUTFILE(&WLIB/&FIL7) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S36) +
                          OPTION(*NOPRT)

             CLRPFM     FILE(&FIL4)

 /*          OVRPRTF    FILE(AH#PR31) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) FORMTYPE(K6H1) */
             OVRPRTF    FILE(AH#PR31) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTB) FORMTYPE(K6H1)
             OVRDBF     FILE(AH#WP36) TOFILE(&FIL7)
             OVRDBF     FILE(AH#WP3A) TOFILE(&FIL4)
             CALL       PGM(AH#R31) PARM(&USER &PKYM &PYMD1 &PYMD2)
             DLTOVR     FILE(AH#PR31)

             CLRPFM     FILE(&FIL2)
             OVRDBF     FILE(AH#WP32) TOFILE(&FIL2)
             CALL       PGM(AH#R32)

             IF         (%SWITCH(X0XXXXXX)) DO
                DLTOVR     FILE(*ALL)
                GOTO       END
             ENDDO

             CLRPFM     FILE(&FIL3)

             FMTDTA     INFILE((&WLIB/&FIL2)) OUTFILE(&WLIB/&FIL3) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S32) +
                          OPTION(*NOPRT)

/*           OVRPRTF    FILE(AH#PR33) DEVTYPE(*AFPDS) LPI(6) +
                          OVRFLW(56) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1)                */
             OVRPRTF    FILE(AH#PR33) DEVTYPE(*AFPDS) LPI(6) +
                          OVRFLW(56) RPLUNPRT(*YES) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1)
             OVRDBF     FILE(AH#WP33) TOFILE(&FIL3)
             OVRDBF     FILE(AH#WP3A) TOFILE(&FIL4)
             CALL       PGM(AH#R33) PARM(&USER &PYMD1 &PYMD2)
             DLTOVR     FILE(*ALL)

 END:        RETURN
             ENDPGM

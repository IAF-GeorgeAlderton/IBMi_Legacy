             PGM
             /** AB#C4Y *******************************/
             /*  ..EDI(830) FRS RE-PRINT         .    */
             /***************************** AB#C20 ****/
             DCLF       FILE(AB#PW4Y)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&PSIRE *EQ '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. SUPPLIER')
             GOTO       STP1
             ENDDO

             IF         (&PSIRK *EQ ' ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. SUPPLIER')
             GOTO       STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

/* TMMC */
             IF         (&PSIRE *EQ '3503') DO
             CHGVAR     VAR(&SR) VALUE('TC')
             ENDDO

/* NUMMI */
             IF         (&PSIRE *EQ '0541') DO
             CHGVAR     VAR(&SR) VALUE('NU')
             ENDDO

/* TMMK */
             IF         (&PSIRE *EQ '3347') DO
             CHGVAR     VAR(&SR) VALUE('TK')
             ENDDO

/* TMMI */
             IF         (&PSIRE *EQ '3804') DO
             CHGVAR     VAR(&SR) VALUE('TI')
             ENDDO

/* TMMWV */
             IF         (&PSIRE *EQ '3931') DO
             CHGVAR     VAR(&SR) VALUE('TW')
             ENDDO

/* SIA & DMAX */
             IF        ((&PSIRE *EQ '0437') *OR +
                        (&PSIRE *EQ '0590')) DO
             CHGVAR     VAR(&SR) VALUE('IS')
             ENDDO

/* HCM & MAP */
             IF        ((&PSIRE *EQ '0295') *OR  +
                        (&PSIRE *EQ '4126')) DO
             CHGVAR     VAR(&SR) VALUE('HC')
             ENDDO

/* ARVIN SANGO */
             IF         (&PSIRE *EQ '0873') DO
             CHGVAR     VAR(&SR) VALUE('AS')
             ENDDO
/* AWNC        */
             IF         (&PSIRE *EQ '0492') DO
             CHGVAR     VAR(&SR) VALUE('AW')
             ENDDO
/* HMA         */
             IF         (&PSIRE *EQ '0390') DO
             CHGVAR     VAR(&SR) VALUE('HM')
             ENDDO

/* TAKATA */
             IF         COND(&PSIRE *EQ '3712') THEN(DO)

             CHGVAR     VAR(&SR) VALUE('T1')
             ENDDO

             CHGVAR     VAR(&FILE) VALUE(AB#WP202 *CAT &SR)
             OVRDBF     FILE(AB#WP202) TOFILE(&WLIB/&FILE)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)

             CALL       PGM(AB#R4Y) PARM(&PSIRE)

 END:        ENDPGM

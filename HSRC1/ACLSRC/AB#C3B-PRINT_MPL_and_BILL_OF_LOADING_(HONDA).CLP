             PGM
             /** AB#C3B******************************************************/
             /*  PRINT MPL AND B/L (HONDA)                                  */
             /*  JW          2023.04.03                                     */
             /***************************************************************/

             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&XPL)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&P3S)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&P3T)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&P3U)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&P3V)  TYPE(*CHAR) LEN(1)

             CALL       PGM(AB#R3SA) PARM(&PRT &NONY &P3S &P3T &P3U &P3V)

/* PDF */
             IF         COND(&PRT = 'Y') THEN(DO)
             IF COND(&P3T = 'Y') THEN(DO)
             CHGVAR     VAR(&XPL) VALUE('AB#PR3T')
             CALL PGM(SPLC15) PARM(&NONY &XPL 'Y')
             ENDDO
             IF COND(&P3U = 'Y') THEN(DO)
             CHGVAR     VAR(&XPL) VALUE('AB#PR3U')
             CALL PGM(SPLC15) PARM(&NONY &XPL 'Y')
             ENDDO
             IF COND(&P3V = 'Y') THEN(DO)
             CHGVAR     VAR(&XPL) VALUE('AB#PR3V')
             CALL PGM(SPLC15) PARM(&NONY &XPL 'Y')
             ENDDO
             IF COND(&P3S = 'Y') THEN(DO)
             CHGVAR     VAR(&XPL) VALUE('AB#PR3S')
             CALL PGM(SPLC14) PARM(&NONY &XPL 'N')
             ENDDO
             ENDDO

ENDP:        ENDPGM

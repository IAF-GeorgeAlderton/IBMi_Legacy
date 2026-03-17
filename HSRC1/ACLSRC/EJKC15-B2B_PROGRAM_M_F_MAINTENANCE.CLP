             PGM
             /*** EJKC15 ***********************************/
             /* B2B PROGRAM M/F MAINTENANCE                */
             /* J.WATANABE         2016.11.02              */
             /**********************************************/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&FLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)
             DCL        VAR(&PDEVT)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)   TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             OVRDBF     FILE(EJKPP10) TOFILE(&FLIB/EJKPP10)
             CALL       PGM(EJKR15)
             DLTOVR     FILE(*ALL)

 END:
             ENDPGM

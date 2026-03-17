             PGM
             /*** EJKC10 ***********************************/
             /* B2B_R  GET MAIN PROGRAM BY JYKBN           */
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

             DCL        VAR(&JYKB)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&SNRV)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&DKBN)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&PROG)    TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             OVRDBF     FILE(EJKPP10) TOFILE(&FLIB/EJKPP10)
             CALL       PGM(EJKR10) PARM(&JYKB &SNRV &DKBN &PROG)
             DLTOVR     FILE(*ALL)

 END:
             ENDPGM

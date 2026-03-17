             PGM
             /*** MRHC51 ***********************************/
             /* STOP DATE / STOP REASON INPUT              */
             /*  A.SHIBATA         2015.05.19              */
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

             DCL        VAR(&P1THI1)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&P1THI2)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1GRHZ)  TYPE(*DEC)  LEN(8 0)
             DCL        VAR(&P1GRTM)  TYPE(*DEC)  LEN(6 0)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

 #STP10:
             CHGVAR     VAR(&P1THI1) VALUE('    ')
             CHGVAR     VAR(&P1THI2) VALUE('   ')
             CHGVAR     VAR(&P1GRHZ) VALUE(0)
             CHGVAR     VAR(&P1GRTM) VALUE(0)
             CALL       PGM(MRHRB1) PARM(&P1THI1 &P1THI2 &P1GRHZ &P1GRTM)
 #STP20:

 END:
             ENDPGM

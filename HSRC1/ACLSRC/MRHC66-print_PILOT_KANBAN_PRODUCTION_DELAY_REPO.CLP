             PGM PARM(&OUTQ)
             /*** MRHC66 ***********************************/
             /*生産遅れリスト　印刷                      */
             /*  TR-ITS            2014.01.22              */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&PRTG) VALUE(&OUTQ)
             CHGJOB     OUTQ(&PRTG)
             MONMSG     MSGID(CPF1336)

 #STP10:
             OVRPRTF    FILE(MRHPR66) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(MRHR66)
             DLTOVR     FILE(MRHPR66)
 #STP20:

 END:
             ENDPGM

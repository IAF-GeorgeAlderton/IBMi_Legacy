             PGM        PARM(&PERR)
             /*** BTBC87 *******************************/
             /* WIRE ORDER ADJUST PLAN BATCH UPDATE    */
             /*      MAEDA.         2018.03.26         */
             /******************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P9ER1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P9ER2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(23)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HWFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TWFILE1  ')
             ENDDO

STEP0:
             DLTF       FILE(&WLIB/BTBWP87)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/BTBWP87) RCDLEN(0512) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(BTBR87)
             RTVMBRD    FILE(BTBWP87) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             CHGVAR     VAR(&PERR) VALUE('9')
             CHGVAR     VAR(&MSGTXT) VALUE('THERE ARE ERROR DATAS. +
                          SEND ERROR DATAS TO CSV. RETRY +
                          AFTER CHECK. (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             CHGVAR     VAR(&TYPE) VALUE('1')
             CHGVAR     VAR(&FILE) VALUE('BTBWP87   ')
             CHGVAR     VAR(&LIBL) VALUE(&WLIB)
             CHGVAR     VAR(&FNAM) VALUE('BTBWP87')
             CALL       PGM(APLC94) PARM(&TYPE &FILE &LIBL &FNAM ' ' ' ' 'Y')
             ENDDO

@END:
             ENDPGM

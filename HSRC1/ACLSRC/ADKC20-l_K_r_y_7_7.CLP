             PGM        PARM(&HHMM)
             /*** ADKC20 ***********************************/
             /*つるべ生産指示   直接入力分の出力       */
             /*                    2020.07.14              */
             /**********************************************/
             DCL        VAR(&HHMM)   TYPE(*CHAR) LEN(4)

             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&FLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)


             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGJOB     OUTQ(&PRTG)
 #STP10:


          /*直接入力分を出力する        */
          /*ＡＧＡＰＰ４１→ＡＤＫＰＰ１５*/
             CALL       PGM(ADKR21) PARM(&HHMM)

 END:
             ENDPGM

             PGM
             /*** ADKC31 ***********************************/
             /*臨時かんばん割振り                        */
             /*     KATOGI.        2015.12.21              */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
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

        /*------------------------------*/
        /*ＡＤＡＰＰ６０抜出          */
        /*------------------------------*/
             CLRPFM     FILE(ADKWP31)
             CALL       PGM(ADKR31)

             CLRPFM     FILE(ADKWP32)
             CALL       PGM(ADKR32)

        /*ＡＤＫＰＰ３１作成          */
             CALL       PGM(ADKR33)

 END:
             ENDPGM

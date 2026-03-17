             PGM
             /** ABFC80 ****************************************/
             /*  PRINT FORECAST VS SALES (%) REPORT            */
             /*  JW     2018.07.06                             */
             /**************************************************/

             DCLF       FILE(ABFPW80)
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&QDATE)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&XDATE0)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&XDATE8)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&TRUE  )   TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN1  )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN2  )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRNT  )   TYPE(*CHAR) LEN(1)

             DCL        VAR(&DT25  )   TYPE(*CHAR) LEN(6)
             DCL        VAR(&SI25  )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MO25  )   TYPE(*CHAR) LEN(2)
             DCL        VAR(&TG25  )   TYPE(*CHAR) LEN(6)
             DCL        VAR(&RT25  )   TYPE(*CHAR) LEN(1)

/* CHECK OTHER USER IS USING  ======================================*/
             CALL       PGM(CHKC45) PARM('ABFC80' 'ABFC80' 'Y' 'CHK' &RTN2)
             IF         COND(&RTN2 *NE ' ') THEN(GOTO @ENDP)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

/* set DEFAULT DATE (TODAY)  */
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CHGVAR     VAR(&DT25) VALUE('20' *CAT &QDATE)
             CHGVAR     VAR(&SI25) VALUE('-')
             CHGVAR     VAR(&MO25) VALUE('01')
             CALL UTLR25 (&DT25 &SI25 &MO25 &TG25 &RT25)

             CHGVAR     VAR(&XDATE ) VALUE(&TG25)
@DSP00:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE('   ')
             CHGVAR     VAR(&IN63) VALUE('0')

       /* F1: EXIT  */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@ENDP1))

       /* CHECK DATE  */
             CHGVAR     VAR(&XDATE8) VALUE(&XDATE *CAT '01')
             CALL       PGM(UTLC01) PARM(&XDATE8 &TRUE &RTN1)

             IF         COND(&RTN1 *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN63) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('Date is invalid!')
             GOTO @DSP00
             ENDDO

       /* F5: RUN  */
             IF         COND(&IN05 *EQ '0') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('Date is valid. Press F5 to +
                          Run...')
             GOTO       CMDLBL(@DSP00)
             ENDDO

             CHGVAR     VAR(&PRNT) VALUE('Y')
             CALL       PGM(ABFC81) PARM(&XDATE &PRNT)
@ENDP1:
             CALL       PGM(CHKC45) PARM('ABFC80' 'ABFC80' 'N' '' '')
@ENDP:
             ENDPGM

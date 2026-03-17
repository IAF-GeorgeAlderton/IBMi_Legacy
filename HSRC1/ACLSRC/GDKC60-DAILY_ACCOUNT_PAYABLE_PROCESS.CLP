             PGM
             /** GDKC60 ***************************/
             /*  DAILY ACCOUNT PAYABLE PROCESS    */
             /*  A.MAMIYA      2000.11.06         */
             /*************************** GDKC60 **/
             DCLF       FILE(GDKPW60)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WREHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGVAR     VAR(&@CODE) VALUE(' ')
             CHGVAR     VAR(&@REHZ) VALUE(0)
             CHGVAR     VAR(&@VEND) VALUE('8990')
 @STP1:      SNDRCVF    DEV(&WSID) RCDFMT(GDKPW601)
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             CHGVAR     VAR(&IN13) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO @END

             IF         COND(&@CODE *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('INPUT PROCESS TYPE.')
             GOTO       @STP1
             ENDDO

             IF         COND((&@CODE *EQ '1') *OR (&@CODE *EQ '2')) +
                          THEN(GOTO CMDLBL(@STP2))
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('PROCESS TYPE IS WRONG.')
             GOTO       @STP1

 @STP2:      CHGVAR     VAR(&WREHZ) VALUE(&@REHZ)
             IF         (%SUBSTRING(&WREHZ 1 4) *LT '2000') GOTO @STP3
             IF         (%SUBSTRING(&WREHZ 5 2) *GT '12') GOTO @STP3
             IF         (%SUBSTRING(&WREHZ 5 2) *LT '01') GOTO @STP3
             IF         (%SUBSTRING(&WREHZ 7 2) *GT '31') GOTO @STP3
             IF         (%SUBSTRING(&WREHZ 7 2) *LT '01') GOTO @STP3
             GOTO       @STP4

 @STP3:      CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('RECEIVING DATE IS WRONG.')
             GOTO       @STP1

 @STP4:      IF         COND(&@VEND *EQ '    ') THEN(DO)
             CHGVAR     VAR(&IN13) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('INPUT VENDOR.')
             GOTO       @STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO @STP1

             /**********************************/
             /*  TRANSFER IMPORT PURCHASE M/F  */
             /**********************************/
             IF         COND(&@CODE *EQ '1') THEN(DO)
             CLRPFM     FILE(GDKWP60)

             CALL       PGM(GDKR60) PARM(&@VEND &@REHZ)

             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(GDKWP60) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('NO DATA.')
             GOTO       @STP1
             ENDDO

             ENDDO
             /**********************************/
             /*  IMPORT PURCHASE M/F LIST      */
             /**********************************/
             IF         COND(&@CODE *EQ '2') THEN(DO)

             OVRPRTF    FILE(QPRINT) OVRFLW(62) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)
             CALL       PGM(GDKR61) PARM(&@VEND &@REHZ &FLG)

             IF         COND(&FLG *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('NO DATA.')
             GOTO       @STP1
             ENDDO

             DLTOVR     FILE(QPRINT)
             ENDDO

 @END:       ENDPGM

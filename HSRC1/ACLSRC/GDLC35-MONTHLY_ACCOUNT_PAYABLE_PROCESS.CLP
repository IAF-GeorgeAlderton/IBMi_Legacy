             PGM
             /** GDLC35 ***************************/
             /*  MONTHLY ACCOUNT PAYABLE PROCESS    */
             /*  A.MAMIYA      2000.11.08         */
             /* TCHK1 01/01/08 CHG 0002 TO 8990   */
             /*************************** GDLC35 **/
             DCLF       FILE(GDLPW35)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSIHZ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGVAR     VAR(&@CODE) VALUE(' ')
             CHGVAR     VAR(&@SIHZ) VALUE(0)
/* TCHK1     CHGVAR     VAR(&@SIRE) VALUE('0002') */
/* TCHK1 */  CHGVAR     VAR(&@SIRE) VALUE('8990')
             CHGVAR     VAR(&@NUKE) VALUE('0111')
 @STP1:      SNDRCVF    DEV(&WSID) RCDFMT(GDLPW351)
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             CHGVAR     VAR(&IN13) VALUE('0')
             CHGVAR     VAR(&IN14) VALUE('0')
             CHGVAR     VAR(&IN15) VALUE('0')
             CHGVAR     VAR(&IN16) VALUE('0')
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

 @STP2:      CHGVAR     VAR(&WSIHZ) VALUE(&@SIHZ)
             IF         (%SUBSTRING(&WSIHZ 1 4) *LT '2000') GOTO @STP3
             IF         (%SUBSTRING(&WSIHZ 5 2) *GT '12') GOTO @STP3
             IF         (%SUBSTRING(&WSIHZ 5 2) *LT '01') GOTO @STP3
             GOTO       @STP4

 @STP3:      CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('PAYMENT DATE IS WRONG.')
             GOTO       @STP1

 @STP4:      IF         COND(&@SIRE *EQ '    ') THEN(DO)
             CHGVAR     VAR(&IN13) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('INPUT SUPPLIER CODE')
             GOTO       @STP1
             ENDDO


             IF         COND(&@NUKE *EQ '    ') THEN(DO)
             CHGVAR     VAR(&IN15) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('INPUT RECEIVER CODE')
             GOTO       @STP1
             ENDDO


             IF         (&IN05 *EQ '0') GOTO @STP1

             /**********************************/
             /*  TRANSFER IMPORT PURCHASE M/F  */
             /**********************************/
             IF         COND(&@CODE *EQ '1') THEN(DO)
             CLRPFM     FILE(GDLWP41)

             CALL       PGM(GDLR35) PARM(&@SIRE &@SKOJ &@NUKE &@NKOJ +
                          &@SIHZ)

             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(GDLWP41) NBRCURRCD(&REC)
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
             CALL       PGM(GDLR36) PARM(&@SIRE &@SKOJ &@NUKE &@NKOJ +
                          &@SIHZ &FLG)

             IF         COND(&FLG *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('NO DATA.')
             GOTO       @STP1
             ENDDO

             DLTOVR     FILE(QPRINT)
             ENDDO

 @END:       ENDPGM

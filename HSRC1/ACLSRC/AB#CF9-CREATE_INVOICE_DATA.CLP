             PGM
             /** AB#CF9 *****************************************************/
             /*  RE-CREATE INVOICE DATA                                     */
             /*                                                             */
             /*  TCH 2000.02.03                                             */
             /*  TCH 2000.02.03 ADD BIN, SELECT 9999                        */
             /*  TCH 2001.03.08 TEMPLATE VERSION-UP                         */
             /*  TCH 2001.09.14 RETRIEVE FORD CODE FROM ABF9P01(AB#RF0)     */
             /*  TCH 2002.04.03 CHECK SCANNING                              */
             /******************************************COPY FROM   AB#CF5 **/
             DCLF       FILE(AB#PWF4)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&QDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WNOHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WREHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FDID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CFLG) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

  STP0:
             CHGVAR     VAR(&FLAG) VALUE(' ')
             CALL       PGM(AB#RFZ) PARM(&PSIRE &PSIRK &PDOCK &PNOHZ +
                          &PNOBN &PREHZ &PPSCAC &PTRIL &PCSCAC +
                          &PCMOD &PPPCD &PSPCD &FLAG)

             IF         COND(&FLAG *EQ '9') THEN(GOTO CMDLBL(END))
             IF         COND(&FLAG *EQ '1') THEN(GOTO CMDLBL(SKP1))

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CVTDAT     DATE(&QDATE) TOVAR(&SDATE) FROMFMT(*SYSVAL) +
                          TOFMT(*YYMD) TOSEP(*NONE)
             CHGVAR     VAR(&PNOHZ) VALUE(&SDATE)
             CHGVAR     VAR(&PREHZ) VALUE(&SDATE)
             CHGVAR     VAR(&PNOBN) VALUE(1)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PWF41)

             CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN08) VALUE('0')
             CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN20 *EQ '1') GOTO END

             IF         (&IN22 *EQ '1') GOTO STP0

             IF         (&PSIRE *EQ '    ') DO
             CHGVAR     VAR(&IN01) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. SUPPLIER')
             GOTO       STP1
             ENDDO

             IF         (&PSIRK *EQ ' ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. SUPPLIER')
             GOTO       STP1
             ENDDO

             IF         (&PDOCK *EQ '    ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. DOCK')
             GOTO       STP1
             ENDDO

             CHGVAR     VAR(&WNOHZ) VALUE(&PNOHZ)
             IF         (%SUBSTRING(&WNOHZ 1 4) *LT '2000') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 5 2) *GT '12') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 5 2) *LT '01') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 7 2) *GT '31') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 7 2) *LT '01') GOTO STP2
             GOTO       STP3

 STP2:       CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE (YYMMDD) IS NOT RIGHT')
             GOTO       STP1

 STP3:
             IF         (&PNOBN *EQ 0) DO
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. BIN')
             GOTO       STP1
             ENDDO

             CHGVAR     VAR(&WREHZ) VALUE(&PREHZ)
             IF         (%SUBSTRING(&WREHZ 1 4) *LT '2000') GOTO STP4
             IF         (%SUBSTRING(&WREHZ 5 2) *GT '12') GOTO STP4
             IF         (%SUBSTRING(&WREHZ 5 2) *LT '01') GOTO STP4
             IF         (%SUBSTRING(&WREHZ 7 2) *GT '31') GOTO STP4
             IF         (%SUBSTRING(&WREHZ 7 2) *LT '01') GOTO STP4
             GOTO       STP5

 STP4:       CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE (YYMMDD) IS NOT RIGHT')
             GOTO       STP1

 STP5:
             IF         (&PPSCAC *EQ '     ') DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT PICK-UP SCAC CODE')
             GOTO       STP1
             ENDDO


             IF         (&PTRIL *EQ '       ') DO
             CHGVAR     VAR(&IN08) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. TRAILER')
             GOTO       STP1
             ENDDO

             IF         (&PCSCAC *EQ '    ') DO
             CHGVAR     VAR(&IN09) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT CARRIER SCAC CODE')
             GOTO       STP1
             ENDDO

             IF         (&PCMOD  *EQ '  ') DO
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT CONVEYANCE MODE')
             GOTO       STP1
             ENDDO

             IF        ((&PPPCD  *NE '     ') *AND +
                        (&PSPCD  *NE '     '))  DO
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('AN INPUT ONLY CODE')
             GOTO       STP1
             ENDDO

             CALL       PGM(AB#RF0) PARM(&PSIRE &FDID)
             IF         COND(&FDID *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN01) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DELIVERY CODE IS NOT FORD')
             GOTO       STP1
             ENDDO


             IF         (&IN21 *EQ '0') GOTO STP1



 /* FORD EDI856(ASN)  */
             IF         COND(&FDID *EQ '1') THEN(DO)

 SKP1:
 /* SCAN CHECK  */

             CALL       PGM(AB#RA6) PARM(&PSIRE &PSIRK &PDOCK &PNOHZ +
                          &PNOBN &PREHZ &CFLG)
             IF         COND(&CFLG *EQ '1') THEN(GOTO CMDLBL(END))

             CLRPFM     FILE(EDI856FD)

             CALL       PGM(AB#RFL) PARM(&PSIRE &PSIRK &PDOCK &PNOHZ +
                          &PNOBN &PREHZ &PPSCAC &PTRIL &PFLG +
                          &PCSCAC &PCMOD &PPPCD &PSPCD)
             GOTO       CMDLBL(STP6)
             ENDDO

 STP6:
             IF         (&PFLG *EQ '*') DO
             SNDPGMMSG  MSG('PLEASE REGISTER UNIT PRICE BEFORE +
                          ISSUING EDI INVOICE DATA') +
                        TOMSGQ(&WSID)
     /*      CLRPFM     FILE(EDI856FD)   */
             ENDDO


             IF         (&PFLG *EQ 'A') DO
             SNDPGMMSG  MSG('THERE IS NO DATA') +
                        TOMSGQ(&WSID)
             ENDDO


             IF         (&PFLG *EQ 'B') DO
             SNDPGMMSG  MSG('FORD ADDRESS MASTER NOT EXIST') +
                        TOMSGQ(&WSID)
             ENDDO

 END:        ENDPGM

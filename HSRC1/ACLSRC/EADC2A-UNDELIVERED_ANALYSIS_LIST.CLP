             PGM
             /** EADC2A ************************/
             /* UNDELIVERED ANALYSIS LIST|| */
             /* I-HASADA            89.03.08   */
             /************************ EADC2A **/
             DCLF       FILE(EADPW2A)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WNHZ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWST) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WKAI) TYPE(*CHAR) LEN(3)

             RTVJOBA    JOB(&WS)

  /*         CALL       PGM(KZZR00) PARM(&WS &PRT &TYPE &PRTG)    */
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CHGVAR     VAR(&PWST) VALUE(0)
             CHGVAR     VAR(&PKAI) VALUE(0)

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(EADPW2A1)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&PKBN *EQ ' ') DO
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('NO.IS NOT INPUT')
             GOTO       STP1
             ENDDO

             IF         ((&PKBN *NE '1') *AND (&PKBN *NE '2') *AND +
                          (&PKBN *NE '3')) DO
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('NO. IS 1,2,3')
             GOTO       STP1
             ENDDO

             IF         (&PKBN *EQ '1') DO
 STP2:       SNDRCVF    DEV(&WS) RCDFMT(EADPW2A2)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN21) VALUE('0')
             CHGVAR     VAR(&IN22) VALUE('0')
             CHGVAR     VAR(&IN23) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN02 *EQ '1') CHGVAR VAR(&PKBN) VALUE(' ')
             IF         (&IN02 *EQ '1') GOTO STP1

             IF         ((&PNO2 *NE '1') *AND (&PNO2 *NE '2')) DO
             CHGVAR     VAR(&IN23) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('NO. IS <1 2>.')
             GOTO       STP2
             ENDDO

             IF         (&PHZ11 *EQ '        ') DO
             CHGVAR     VAR(&IN21) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF FIRST PERIOD IS NOT INPUT')
             GOTO       STP2
             ENDDO

             IF         (&PHZ12 *EQ '        ') DO
             CHGVAR     VAR(&IN22) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF LAST PERIOD IS NOT INPUT')
             GOTO       STP2
             ENDDO

             IF         (%SST(&PHZ11 1 4) *LT '1989') GOTO STP21
             IF         (%SST(&PHZ11 5 2) *LT '01') GOTO STP21
             IF         (%SST(&PHZ11 5 2) *GT '12') GOTO STP21
             IF         (%SST(&PHZ11 7 2) *LT '01') GOTO STP21
             IF         (%SST(&PHZ11 7 2) *GT '31') GOTO STP21
             GOTO       STP22
 STP21:      CHGVAR     VAR(&IN21) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF FIRST PERIOD IS NOT RIGHT')
             GOTO       STP2

 STP22:      IF         (%SST(&PHZ12 1 4) *LT '1989') GOTO STP23
             IF         (%SST(&PHZ12 5 2) *LT '01') GOTO STP23
             IF         (%SST(&PHZ12 5 2) *GT '12') GOTO STP23
             IF         (%SST(&PHZ12 7 2) *LT '01') GOTO STP23
             IF         (%SST(&PHZ12 7 2) *GT '31') GOTO STP23
             GOTO       STP24
 STP23:      CHGVAR     VAR(&IN22) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF LAST PERIOD IS NOT RIGHT')
             GOTO       STP2

 STP24:      IF         (&IN05 *EQ '0') GOTO STP2

             CALL       PGM(EADC21) PARM(&PHZ11 &PHZ12 &PNO2)
             GOTO       END
             ENDDO

             IF         (&PKBN *EQ '2') DO
 STP3:       SNDRCVF    DEV(&WS) RCDFMT(EADPW2A3)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN31) VALUE('0')
             CHGVAR     VAR(&IN32) VALUE('0')
             CHGVAR     VAR(&IN33) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN02 *EQ '1') CHGVAR VAR(&PKBN) VALUE(' ')
             IF         (&IN02 *EQ '1') GOTO STP1

             IF         (&PNONY *EQ '    ') DO
             CHGVAR     VAR(&IN31) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('RECEIVING CO. IS NOT INPUT')
             GOTO       STP3
             ENDDO

             IF         (&PHZ21 *EQ '        ') DO
             CHGVAR     VAR(&IN32) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF FIRST PERIOD IS NOT INPUT')
             GOTO       STP3
             ENDDO

             IF         (&PHZ22 *EQ '        ') DO
             CHGVAR     VAR(&IN33) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF LAST PERIOD IS NOT INPUT')
             GOTO       STP3
             ENDDO

             IF         (%SST(&PHZ21 1 4) *LT '1989') GOTO STP31
             IF         (%SST(&PHZ21 5 2) *LT '01') GOTO STP31
             IF         (%SST(&PHZ21 5 2) *GT '12') GOTO STP31
             IF         (%SST(&PHZ21 7 2) *LT '01') GOTO STP31
             IF         (%SST(&PHZ21 7 2) *GT '31') GOTO STP31
             GOTO       STP32
 STP31:      CHGVAR     VAR(&IN32) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF FIRST PERIOD IS NOT RIGHT')
             GOTO       STP3

 STP32:      IF         (%SST(&PHZ22 1 4) *LT '1989') GOTO STP33
             IF         (%SST(&PHZ22 5 2) *LT '01') GOTO STP33
             IF         (%SST(&PHZ22 5 2) *GT '12') GOTO STP33
             IF         (%SST(&PHZ22 7 2) *LT '01') GOTO STP33
             IF         (%SST(&PHZ22 7 2) *GT '31') GOTO STP33
             GOTO       STP34
 STP33:      CHGVAR     VAR(&IN33) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF LAST PERIOD IS NOT RIGHT')
             GOTO       STP3

 STP34:      IF         (&IN05 *EQ '0') GOTO STP3

             CHGVAR     VAR(&WNHZ) VALUE(%SST(&PHZ21 1 6))
             CALL       PGM(EADC24) PARM(&PNONY &PHZ21 &PHZ22 &WNHZ)
             GOTO       END
             ENDDO

             IF         (&PKBN *EQ '3') DO
 STP4:       SNDRCVF    DEV(&WS) RCDFMT(EADPW2A4)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')
             CHGVAR     VAR(&IN43) VALUE('0')
             CHGVAR     VAR(&IN44) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN02 *EQ '1') CHGVAR VAR(&PKBN) VALUE(' ')
             IF         (&IN02 *EQ '1') GOTO STP1

             IF         ((&PWST *EQ 0) *AND (&PKAI *EQ 0)) DO
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT 1 OR 2')
             GOTO       STP4
             ENDDO

             IF         (&PWST *NE 0) DO
             IF         (&PKAI *NE 0) DO
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT 1 OR 2')
             GOTO       STP4
             ENDDO
             ENDDO

             IF         (&PHZ31 *EQ '        ') DO
             CHGVAR     VAR(&IN43) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF FIRST PERIOD IS NOT INPUT')
             GOTO       STP4
             ENDDO

             IF         (&PHZ32 *EQ '        ') DO
             CHGVAR     VAR(&IN44) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF LAST PERIOD IS NOT INPUT')
             GOTO       STP4
             ENDDO

             IF         (%SST(&PHZ31 1 4) *LT '1989') GOTO STP41
             IF         (%SST(&PHZ31 5 2) *LT '01') GOTO STP41
             IF         (%SST(&PHZ31 5 2) *GT '12') GOTO STP41
             IF         (%SST(&PHZ31 7 2) *LT '01') GOTO STP41
             IF         (%SST(&PHZ31 7 2) *GT '31') GOTO STP41
             GOTO       STP42
 STP41:      CHGVAR     VAR(&IN43) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF FIRST PERIOD IS NOT RIGHT')
             GOTO       STP4

 STP42:      IF         (%SST(&PHZ32 1 4) *LT '1989') GOTO STP43
             IF         (%SST(&PHZ32 5 2) *LT '01') GOTO STP43
             IF         (%SST(&PHZ32 5 2) *GT '12') GOTO STP43
             IF         (%SST(&PHZ32 7 2) *LT '01') GOTO STP43
             IF         (%SST(&PHZ32 7 2) *GT '31') GOTO STP43
             GOTO       STP44
 STP43:      CHGVAR     VAR(&IN44) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF LAST PERIOD IS NOT RIGHT')
             GOTO       STP4

 STP44:      IF         (&IN05 *EQ '0') GOTO STP4

             CHGVAR     VAR(&WWST) VALUE(&PWST)
             CHGVAR     VAR(&WKAI) VALUE(&PKAI)
             CALL       PGM(EADC26) PARM(&WWST &WKAI &PHZ31 &PHZ32)
             ENDDO

 END:        ENDPGM

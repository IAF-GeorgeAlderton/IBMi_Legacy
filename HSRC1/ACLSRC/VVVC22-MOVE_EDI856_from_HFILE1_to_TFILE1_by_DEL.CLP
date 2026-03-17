             PGM
             /** VVVC22 ************************************************/
             /*  MOVE EDI856 FROM HFILE1 TO TFILE1 BY DELIVERY#        */
             /*  JW   2024.02.19                                       */
             /**********************************************************/

             DCLF       FILE(VVVPW22 )
             DCL        VAR(&CNT1)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&CNT2)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&CNT3)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&CNT4)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&CNT5)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&CNT6)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&CNT7)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&CNT8)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&CNT9)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&CNT10) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CNT11) TYPE(*CHAR) LEN(5)

             CHGVAR     VAR(&IN61) VALUE('0')
             CHGVAR     VAR(&IN62) VALUE('0')
             CHGVAR     VAR(&IN63) VALUE('0')
             CHGVAR     VAR(&XADD) VALUE('N')
             CHGVAR     VAR(&XREP) VALUE('Y')

/* DISPLAY*/
  STP1:      SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&IN61) VALUE('0')
             CHGVAR     VAR(&IN62) VALUE('0')
             CHGVAR     VAR(&IN63) VALUE('0')

/* END */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(ENDP))
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(ENDP))
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(ENDP))

/* NONY ERROR */
             IF         COND(&XNONY = ' ') THEN(DO)
             CHGVAR     VAR(&IN61) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ENTRER DELIVERY# !')
             GOTO CMDLBL(STP1)
             ENDDO

/* CHECK *ADD ERROR */
             IF         COND((&XADD *NE 'Y') *AND (&XADD *NE 'N')) THEN(DO)
             CHGVAR     VAR(&IN62) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('OPTION FLAG SHOULD BE Y OR N !')
             GOTO CMDLBL(STP1)
             ENDDO

/* CHECK *REP ERROR */
             IF         COND((&XREP *NE 'Y') *AND (&XREP *NE 'N')) THEN(DO)
             CHGVAR     VAR(&IN63) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('OPTION FLAG SHOULD BE Y OR N !')
             GOTO CMDLBL(STP1)
             ENDDO

/* Y AND Y ERROR */
             IF         COND((&XADD *EQ 'Y') *AND (&XREP *EQ 'Y')) THEN(DO)
             CHGVAR     VAR(&IN62) VALUE('1')
             CHGVAR     VAR(&IN63) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INVALID CONDITION !')
             GOTO CMDLBL(STP1)
             ENDDO

/* N AND N ERROR */
             IF         COND((&XADD *EQ 'N') *AND (&XREP *EQ 'N')) THEN(DO)
             CHGVAR     VAR(&IN62) VALUE('1')
             CHGVAR     VAR(&IN63) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INVALID CONDITION !')
             GOTO CMDLBL(STP1)
             ENDDO

/* OVRDBF */
             OVRDBF     FILE(AB#EL60 ) TOFILE(HFILE1/AB#EL60 )
             OVRDBF     FILE(AB#EP60 ) TOFILE(TFILE1/AB#EP60 )
             OVRDBF     FILE(AB#EL61B) TOFILE(HFILE1/AB#EL61B)
             OVRDBF     FILE(AB#EP61 ) TOFILE(TFILE1/AB#EP61 )
             OVRDBF     FILE(AB#EL62 ) TOFILE(HFILE1/AB#EL62 )
             OVRDBF     FILE(AB#EP62 ) TOFILE(TFILE1/AB#EP62 )
             OVRDBF     FILE(AB#EL77 ) TOFILE(HFILE1/AB#EL77 )
             OVRDBF     FILE(AB#EP77 ) TOFILE(TFILE1/AB#EP77 )
             OVRDBF     FILE(AB#EL53 ) TOFILE(HFILE1/AB#EL53 )
             OVRDBF     FILE(AB#EP53 ) TOFILE(TFILE1/AB#EP53 )
             OVRDBF     FILE(AB#EL54 ) TOFILE(HFILE1/AB#EL54 )
             OVRDBF     FILE(AB#EP54 ) TOFILE(TFILE1/AB#EP54 )
             OVRDBF     FILE(AB#EL55 ) TOFILE(HFILE1/AB#EL55 )
             OVRDBF     FILE(AB#EP55 ) TOFILE(TFILE1/AB#EP55 )
             OVRDBF     FILE(AB#EL56 ) TOFILE(HFILE1/AB#EL56 )
             OVRDBF     FILE(AB#EP56 ) TOFILE(TFILE1/AB#EP56 )
             OVRDBF     FILE(AB#EL571) TOFILE(HFILE1/AB#EL571)
             OVRDBF     FILE(AB#EP57 ) TOFILE(TFILE1/AB#EP57 )
             OVRDBF     FILE(AB#EL58 ) TOFILE(HFILE1/AB#EL58 )
             OVRDBF     FILE(AB#EP58 ) TOFILE(TFILE1/AB#EP58 )
             OVRDBF     FILE(AB#EL72 ) TOFILE(HFILE1/AB#EL72 )
             OVRDBF     FILE(AB#EP72 ) TOFILE(TFILE1/AB#EP72 )

 /* MSG: PRESS F5.. */
             IF         COND(&IN05 *EQ '0') THEN(DO)
             CALL       PGM(VVVR22) PARM((&XNONY) ('N') (&CNT1) +
                          (&CNT2) (&CNT3) (&CNT4) (&CNT5) (&CNT6) +
                          (&CNT7) (&CNT8) (&CNT9) (&CNT10) (&CNT11))

             CHGVAR     VAR(&C01)  VALUE(&CNT1)
             CHGVAR     VAR(&C02)  VALUE(&CNT2)
             CHGVAR     VAR(&C03)  VALUE(&CNT3)
             CHGVAR     VAR(&C04)  VALUE(&CNT4)
             CHGVAR     VAR(&C05)  VALUE(&CNT5)
             CHGVAR     VAR(&C06)  VALUE(&CNT6)
             CHGVAR     VAR(&C07)  VALUE(&CNT7)
             CHGVAR     VAR(&C08)  VALUE(&CNT8)
             CHGVAR     VAR(&C09)  VALUE(&CNT9)
             CHGVAR     VAR(&C10)  VALUE(&CNT10)
             CHGVAR     VAR(&C11)  VALUE(&CNT11)

             IF         COND((&C01 *EQ 0) *AND (&C05 *EQ 0)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('NO DATA FOUND!')
             GOTO CMDLBL(STP1)
             ENDDO

             IF         COND((&C01 *NE 0) *OR (&C05 *NE 0)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('PRESS F5 TO PROCESS...')
             GOTO CMDLBL(STP1)
             ENDDO

             ENDDO

/*  IF DATA EXISTS, THEN CLEAR TFILE1  */
             IF         COND(&XREP *EQ 'Y') THEN(DO)
             IF         COND((&C01 *NE 0) *OR (&C05 *NE 0)) THEN(DO)
             CLRPFM     FILE(TFILE1/AB#EP60)
             CLRPFM     FILE(TFILE1/AB#EP61)
             CLRPFM     FILE(TFILE1/AB#EP62)
             CLRPFM     FILE(TFILE1/AB#EP77)
             CLRPFM     FILE(TFILE1/AB#EP53)
             CLRPFM     FILE(TFILE1/AB#EP54)
             CLRPFM     FILE(TFILE1/AB#EP55)
             CLRPFM     FILE(TFILE1/AB#EP56)
             CLRPFM     FILE(TFILE1/AB#EP57)
             CLRPFM     FILE(TFILE1/AB#EP58)
             CLRPFM     FILE(TFILE1/AB#EP72)
             ENDDO
             ENDDO

             CALL       PGM(VVVR22) PARM((&XNONY) ('Y') (&CNT1) +
                          (&CNT2) (&CNT3) (&CNT4) (&CNT5) (&CNT6) +
                          (&CNT7) (&CNT8) (&CNT9) (&CNT10) (&CNT11))

             CHGVAR     VAR(&C01) VALUE(&CNT1)
             CHGVAR     VAR(&C02) VALUE(&CNT2)
             CHGVAR     VAR(&C03) VALUE(&CNT3)
             CHGVAR     VAR(&C04) VALUE(&CNT4)
             CHGVAR     VAR(&C05) VALUE(&CNT5)
             CHGVAR     VAR(&C06) VALUE(&CNT6)
             CHGVAR     VAR(&C07) VALUE(&CNT7)
             CHGVAR     VAR(&C08) VALUE(&CNT8)
             CHGVAR     VAR(&C09) VALUE(&CNT9)
             CHGVAR     VAR(&C10) VALUE(&CNT10)
             CHGVAR     VAR(&C11) VALUE(&CNT11)

             IF         COND((&C01 *EQ 0) *AND (&C05 *EQ 0)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('NO DATA FOUND!')
             GOTO CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&MSG) VALUE('Move completed...')
             GOTO CMDLBL(STP1)

 ENDP:       ENDPGM

             PGM
             /** VVVC21 ************************************************/
             /*  COPY PF FROM HFILE1 TO TFILE1 BY SHIP DATE            */
             /*  JW   2024.02.19                                       */
             /**********************************************************/

             DCLF       FILE(VVVPW21 )
             DCL        VAR(&CNT ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)


  STP1:      SNDRCVF    RCDFMT(DSP01)

/* END */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(END))
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(END))

             IF         COND(&IN05 *EQ '0') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE(' ')
             GOTO CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&MSG) VALUE('Program is copying data... +
                          Please wait for a moment...')

/*  COPY AB#PP10  */
             OVRDBF     FILE(AB#PL19C) TOFILE(HFILE1/AB#PL19C)
             OVRDBF     FILE(AB#PL14 ) TOFILE(TFILE1/AB#PL14 )
             CALL       PGM(VB#R10  ) PARM(&XDATE &CNT &RTN)

             CHGVAR     VAR(&X01) VALUE('x')
             CHGVAR     VAR(&C01) VALUE(&CNT)
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)

/*  COPY AB#PP2A  */
             OVRDBF     FILE(AB#PL2P ) TOFILE(HFILE1/AB#PL2P )
             OVRDBF     FILE(AB#PL2Q ) TOFILE(TFILE1/AB#PL2Q )
             CALL       PGM(VB#R2A) PARM(&XDATE &CNT &RTN)

             CHGVAR     VAR(&X02) VALUE('x')
             CHGVAR     VAR(&C02) VALUE(&CNT)
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)

/*  COPY AB#PP70  */
             OVRDBF     FILE(AB#PL73 ) TOFILE(HFILE1/AB#PL73 )
             OVRDBF     FILE(AB#PL73A) TOFILE(TFILE1/AB#PL73A)
             CALL       PGM(VB#R70 ) PARM(&XDATE &CNT &RTN)

             CHGVAR     VAR(&X03) VALUE('x')
             CHGVAR     VAR(&C03) VALUE(&CNT)
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)

/*  COPY AB#PP75  */
             OVRDBF     FILE(AB#PL75 ) TOFILE(HFILE1/AB#PL75 )
             OVRDBF     FILE(AB#PL75C) TOFILE(TFILE1/AB#PL75C)
             CALL       PGM(VB#R75 ) PARM(&XDATE &CNT &RTN)

             CHGVAR     VAR(&X04) VALUE('x')
             CHGVAR     VAR(&C04) VALUE(&CNT)
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)

/*  COPY AB#PP78  */
             OVRDBF     FILE(AB#PL78 ) TOFILE(HFILE1/AB#PL78 )
             OVRDBF     FILE(AB#PL83 ) TOFILE(TFILE1/AB#PL83 )
             CALL       PGM(VB#R78 ) PARM(&XDATE &CNT &RTN)

             CHGVAR     VAR(&X05) VALUE('x')
             CHGVAR     VAR(&C05) VALUE(&CNT)
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)

/*  COPY AB#PP2B  */
             OVRDBF     FILE(AB#PL2B1) TOFILE(HFILE1/AB#PL2B1)
             OVRDBF     FILE(AB#PL2B2) TOFILE(TFILE1/AB#PL2B2)
             CALL       PGM(VB#R2B ) PARM(&XDATE &CNT &RTN)

             CHGVAR     VAR(&X06) VALUE('x')
             CHGVAR     VAR(&C06) VALUE(&CNT)
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)

/*  COPY AB#PP2F  */

             OVRDBF     FILE(AB#PL2F2) TOFILE(TFILE1/AB#PL2F2)
             CALL       PGM(VB#R2F ) PARM(&XDATE &CNT &RTN)

             CHGVAR     VAR(&X07) VALUE('x')
             CHGVAR     VAR(&C07) VALUE(&CNT)
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)

/*  COPY AB#PPA1  */
             OVRDBF     FILE(AB#PLAA ) TOFILE(HFILE1/AB#PLAA )
             OVRDBF     FILE(AB#PLAN ) TOFILE(TFILE1/AB#PLAN )
             CALL       PGM(VB#RA1 ) PARM(&XDATE &CNT &RTN)

             CHGVAR     VAR(&X08) VALUE('x')
             CHGVAR     VAR(&C08) VALUE(&CNT)
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)

/*  COPY AB#PP01  */
             OVRDBF     FILE(AB#PL0B ) TOFILE(HFILE1/AB#PL0B )
             OVRDBF     FILE(AB#PL0M ) TOFILE(TFILE1/AB#PL0M )
             CALL       PGM(VB#R01 ) PARM(&XDATE &CNT &RTN)

             CHGVAR     VAR(&X09) VALUE('x')
             CHGVAR     VAR(&C09) VALUE(&CNT)
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)

             CHGVAR     VAR(&MSG) VALUE('Copy completed... Enter +
                          next Date or press F1 to exit...')

             GOTO CMDLBL(STP1)

 END:        ENDPGM

             PGM
             /** VVVC23 ************************************************/
             /*   COPY PFS TO TFILE1 BY SHIP DATE                      */
             /*  JW   2024.02.20                                       */
             /**********************************************************/

             DCLF       FILE(VVVPW23 )
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TRUE) TYPE(*CHAR) LEN(8 )
             DCL        VAR(&RTN1) TYPE(*CHAR) LEN(1 )

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&XGEFLG)  VALUE('N')

             ADDLIBLE   LIB(WATALIB)
             MONMSG     MSGID(CPF0000)


  STP1:      SNDRCVF    RCDFMT(DSP01)

  /* END */
             CHGVAR     VAR(&MSG)  VALUE('                  ')
             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(END))
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(END))

             IF         COND(&XDATE *EQ '   ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('ENTER SHIP DATE !')
             CHGVAR     VAR(&IN41) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

  /* CHECK SHIP DATE */
             CHGVAR     VAR(&SRC  ) VALUE(&XDATE)
             CALL       UTLR01 (&SRC &TRUE &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(DO)
             CHGVAR     VAR(&MSG)  VALUE('SHIP DATE IS INVALID !')
             CHGVAR     VAR(&IN41) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO
 /* CHECK FLAG */
             IF         COND((&XGEFLG *NE 'Y') *AND (&XGEFLG *NE +
                          'N')) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('ENTER Y OR N !')
             CHGVAR     VAR(&IN42) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&XDATE) VALUE(&TRUE)
             CHGVAR     VAR(&MSG) VALUE('PRESS F5 TO RUN,..')

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(STP1))

  /* 1. COPY AB#PP10  */
             CHGVAR     VAR(&MSG) VALUE('COPYING #1 AB#PP10...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL19C) TOFILE(HFILE1/AB#PL19C)
             OVRDBF     FILE(AB#PL14 ) TOFILE(TFILE1/AB#PL14 )
             CALL       PGM($AB#PP10) PARM(&XDATE &XGEFLG &RTN)

  /* 2. COPY AB#PP2A  */
             CHGVAR     VAR(&MSG) VALUE('COPYING  #2 AB#PP2A...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL2P ) TOFILE(HFILE1/AB#PL2P )
             OVRDBF     FILE(AB#PL2Q ) TOFILE(TFILE1/AB#PL2Q )
             CALL       PGM($AB#PP2A) PARM(&XDATE &XGEFLG &RTN)

  /* 3. COPY AB#PP2F  */
             CHGVAR     VAR(&MSG) VALUE('COPYING  #3 AB#PP2F...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL2F1) TOFILE(HFILE1/AB#PL2F1)
             OVRDBF     FILE(AB#PL2F2) TOFILE(TFILE1/AB#PL2F2)
             CALL       PGM($AB#PP2F) PARM(&XDATE &XGEFLG &RTN)

  /* 4. COPY AB#PP70  */
             CHGVAR     VAR(&MSG) VALUE('COPYING   #4 AB#PP70...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL73 ) TOFILE(HFILE1/AB#PL73 )
             OVRDBF     FILE(AB#PL73A) TOFILE(TFILE1/AB#PL73A)
             CALL       PGM($AB#PP70) PARM(&XDATE &XGEFLG &RTN)

  /* 5. COPY AB#PP75  */
             CHGVAR     VAR(&MSG) VALUE('COPYING    #5 AB#PP75...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL75 ) TOFILE(HFILE1/AB#PL75 )
             OVRDBF     FILE(AB#PL75C) TOFILE(TFILE1/AB#PL75C)
             CALL       PGM($AB#PP75) PARM(&XDATE &XGEFLG &RTN)

  /* 6. COPY AB#PP78  */
             CHGVAR     VAR(&MSG) VALUE('COPYING     #6 AB#PP78...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL78 ) TOFILE(HFILE1/AB#PL78 )
             OVRDBF     FILE(AB#PL83 ) TOFILE(TFILE1/AB#PL83 )
             CALL       PGM($AB#PP78) PARM(&XDATE &XGEFLG &RTN)

  /* 7. COPY AB#PPA1  */
             CHGVAR     VAR(&MSG) VALUE('COPYING      #7 AB#PPA1...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PLAA ) TOFILE(HFILE1/AB#PLAA )
             OVRDBF     FILE(AB#PLAN ) TOFILE(TFILE1/AB#PLAN )
             CALL       PGM($AB#PPA1) PARM(&XDATE &XGEFLG &RTN)

  /* 8. COPY ABF4P01 */
             CHGVAR     VAR(&MSG) VALUE('COPYING       #8 ABF4P01...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(ABF4L02 ) TOFILE(HFILE1/ABF4L02 )
             OVRDBF     FILE(ABF4L03 ) TOFILE(TFILE1/ABF4L03 )
             CALL       PGM($ABF4P01) PARM(&XDATE &XGEFLG &RTN)

  /* 9. COPY ABF6P01 */
             CHGVAR     VAR(&MSG) VALUE('COPYING        #9 ABF6P01...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(ABF6L08 ) TOFILE(HFILE1/ABF6L08 )
             OVRDBF     FILE(ABF6L09 ) TOFILE(TFILE1/ABF6L09 )
             CALL       PGM($ABF6P01) PARM(&XDATE &XGEFLG &RTN)

  /* 10.COPY AB#PP40 */
             CHGVAR     VAR(&MSG) VALUE('COPYING        #10 AB#PP40...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL40A) TOFILE(HFILE1/AB#PL40A)
             OVRDBF     FILE(AB#PL40B) TOFILE(TFILE1/AB#PL40B)
             CALL       PGM($AB#PP40) PARM(&XDATE &XGEFLG &RTN)

  /* 11.COPY AB#PP41 */
             CHGVAR     VAR(&MSG) VALUE('COPYING        #11 AB#PP41...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL41A) TOFILE(HFILE1/AB#PL41A)
             OVRDBF     FILE(AB#PL41B) TOFILE(TFILE1/AB#PL41B)
             CALL       PGM($AB#PP41) PARM(&XDATE &XGEFLG &RTN)

  /* 12.COPY AB#PP42 */
             CHGVAR     VAR(&MSG) VALUE('COPYING        #12 AB#PP42...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL42A) TOFILE(HFILE1/AB#PL42A)
             OVRDBF     FILE(AB#PL42B) TOFILE(TFILE1/AB#PL42B)
             CALL       PGM($AB#PP42) PARM(&XDATE &XGEFLG &RTN)

  /* 13.COPY AB#PP43 */
             CHGVAR     VAR(&MSG) VALUE('COPYING        #13 AB#PP43...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL43A) TOFILE(HFILE1/AB#PL43A)
             OVRDBF     FILE(AB#PL43B) TOFILE(TFILE1/AB#PL43B)
             CALL       PGM($AB#PP43) PARM(&XDATE &XGEFLG &RTN)

  /* 14.COPY AB#PP44 */
             CHGVAR     VAR(&MSG) VALUE('COPYING        #14 AB#PP44...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL44A) TOFILE(HFILE1/AB#PL44A)
             OVRDBF     FILE(AB#PL44B) TOFILE(TFILE1/AB#PL44B)
             CALL       PGM($AB#PP44) PARM(&XDATE &XGEFLG &RTN)

  /* 15.COPY AB#PP47 */
             CHGVAR     VAR(&MSG) VALUE('COPYING        #15 AB#PP47...')
             SNDRCVF    RCDFMT(DSP01) WAIT(*NO)
             OVRDBF     FILE(AB#PL47A) TOFILE(HFILE1/AB#PL47A)
             OVRDBF     FILE(AB#PL47B) TOFILE(TFILE1/AB#PL47B)
             CALL       PGM($AB#PP47) PARM(&XDATE &XGEFLG &RTN)

  /*  COPY OTHERS  */

      CPYF FROMFILE(HFILE1/AB#PPCT) TOFILE(TFILE1/AB#PPCT) MBROPT(*REPLACE) +
                                                           FMTOPT(*NOCHK)
      CPYF FROMFILE(HFILE1/AB#PP85) TOFILE(TFILE1/AB#PP85) MBROPT(*REPLACE) +
                                                           FMTOPT(*NOCHK)
      CPYF FROMFILE(HFILE1/FCCPP11) TOFILE(TFILE1/FCCPP11) MBROPT(*REPLACE) +
                                                           FMTOPT(*NOCHK)
      CPYF FROMFILE(HFILE1/AB#EP00) TOFILE(TFILE1/AB#EP00) MBROPT(*REPLACE) +
                                                           FMTOPT(*NOCHK)
      CPYF FROMFILE(HFILE1/AGDPP11) TOFILE(TFILE1/AGDPP11) MBROPT(*REPLACE) +
                                                           FMTOPT(*NOCHK)
      CPYF FROMFILE(HFILE1/EDIPP45) TOFILE(TFILE1/EDIPP45) MBROPT(*REPLACE) +
                                                           FMTOPT(*NOCHK)

 END:        ENDPGM

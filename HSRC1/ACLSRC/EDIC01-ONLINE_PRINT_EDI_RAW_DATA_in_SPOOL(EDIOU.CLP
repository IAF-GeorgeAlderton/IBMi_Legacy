             PGM
             /** EDIC01 ************************************/
             /* RETRIEVE EDI RAW DATA                      */
             /* CREATE DATE : 05/18/2017                   */
             /* AUTHOR      : J.WATANABE                   */
             /* COMPILE     : NEED LIBRARY G3X1PGM         */
             /**********************************************/

             DCL        VAR(&BCH)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRF)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)   TYPE(*CHAR) LEN(1)

             DCLF       FILE(EDIPW03)
             CHGVAR     VAR(&#PGM ) VALUE('EDIC01')
             CHGVAR     VAR(&XTYP ) VALUE('I')
 /* DISPLAY */
 AGAIN:
             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE(' ')
             CHGVAR     VAR(&IN61) VALUE('0')
             CHGVAR     VAR(&IN62) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO ENDP

 /* CHECK PARAMETER */
             IF         COND(&XTYP *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN61) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER TYPE...')
             GOTO       CMDLBL(AGAIN)
             ENDDO

             IF         COND((&XTYP *NE 'I') *AND (&XTYP *NE 'O')) +
                          THEN(DO)
             CHGVAR     VAR(&IN61) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER I or O for TYPE...')
             GOTO       CMDLBL(AGAIN)
             ENDDO

             IF         COND(&XBATCH *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN62) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER BATCH#...')
             GOTO       CMDLBL(AGAIN)
             ENDDO

/* ADD LIBRARY LIST */
             ADDLIBLE   LIB(G3X6PGM) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(G3X6DTA) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(G3X1CUSOBJ) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

/* GET PROFILE ID */
             CHGVAR     VAR(&BCH) VALUE(&XBATCH)
             CALL       UTGR01 (&XTYP &BCH &PRF &RTN)

             IF         COND(&RTN *NE ' ') THEN(DO)
             CALL       PGM(EDIC02B) PARM(&XTYP &XBATCH)
             GOTO       CMDLBL(ENDP)
             ENDDO

             IF         COND((&XTYP *EQ 'O') *OR (&XTYP *EQ 'o')) THEN(DO)
/* OUTBOUND: */
             OVRPRTF    FILE(QPRINT) USRDTA(&PRF)
             PRTEDIDTA  COMPRF(&PRF) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*YES) INOUT(*O) STRBAT(&XBATCH) +
                          ENDBAT(&XBATCH) INT(*NO)
             ENDDO

             IF         COND((&XTYP *EQ 'I') *OR (&XTYP *EQ 'i')) THEN(DO)
/* INBOUND: */
             OVRPRTF    FILE(QPRINT) USRDTA(&PRF)
             PRTEDIDTA  COMPRF(&PRF) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*YES) INOUT(*I) STRBAT(&XBATCH) +
                          ENDBAT(&XBATCH) INT(*NO)
             ENDDO
ENDP:
             ENDPGM

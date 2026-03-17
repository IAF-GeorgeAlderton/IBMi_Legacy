             PGM        PARM(&TYP &BATCH &RTN)
             /** EDIC04 *******************************************/
             /* RETRIEVE EDI RAW DATA                             */
             /* J.WATANABE   2023.10.17                           */
             /* COMPILE:     NEED LIBRARY G3X1PGM                 */
             /* ---------------------------------                 */
             /* (PARAMETERS)                                      */
             /* &TYP    1A  I:INBOUND, O:OUTBOUND                 */
             /* &BATCH  7A  EDI BATCH#                            */
             /* &RTN    1A  RETURN CODE (BLANK:OK, NOT-B:ERROR    */
             /*****************************************************/
             DCL        VAR(&TYP)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&BATCH) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RTN)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PRF)   TYPE(*CHAR) LEN(8) VALUE(' ')

 /* CHECK PARAMETER */
             IF  COND((&TYP *NE 'I') *AND (&TYP *NE 'O')) THEN(DO)
             CHGVAR     VAR(&RTN ) VALUE('*')
             GOTO       CMDLBL(ENDP )
             ENDDO

             IF         COND(&BATCH *EQ ' ') THEN(DO)
             CHGVAR     VAR(&RTN ) VALUE('*')
             GOTO       CMDLBL(ENDP )
             ENDDO

/* ADD LIBRARY LIST */
             ADDLIBLE   LIB(G3X6PGM) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(G3X6DTA) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(G3X1CUSOBJ) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

/* GET PROFILE ID */
             CALL       UTGR01 (&TYP &BATCH &PRF &RTN)

             IF         COND(&RTN *NE ' ') THEN(DO)
             GOTO       CMDLBL(ENDP)
             ENDDO

/* OUTBOUND: */
             IF         COND((&TYP *EQ 'O') *OR (&TYP *EQ 'o')) THEN(DO)
             OVRPRTF    FILE(QPRINT) USRDTA(&PRF)
             PRTEDIDTA  COMPRF(&PRF) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*YES) INOUT(*O) STRBAT(&BATCH) +
                          ENDBAT(&BATCH) INT(*NO)
             ENDDO

/* INBOUND: */
             IF         COND((&TYP *EQ 'I') *OR (&TYP *EQ 'i')) THEN(DO)
             OVRPRTF    FILE(QPRINT) USRDTA(&PRF)
             PRTEDIDTA  COMPRF(&PRF) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*YES) INOUT(*I) STRBAT(&BATCH) +
                          ENDBAT(&BATCH) INT(*NO)
             ENDDO
ENDP:
             ENDPGM

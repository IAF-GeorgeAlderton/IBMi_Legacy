             PGM        PARM(&XTYP &XBATCH)
             /** EDIC02B ***********************************/
             /* RETRIEVE EDI RAW DATA                      */
             /* CREATE DATE : 02/14/2020                   */
             /* AUTHOR      : J.WATANABE                   */
             /* COMPILE     : NEED LIBRARY G3X1PGM         */
             /**********************************************/
             DCL        VAR(&XTYP)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&XBATCH) TYPE(*CHAR) LEN(6)

/* ADD LIBRARY LIST */
             ADDLIBLE   LIB(G3X6PGM) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(G3X6DTA) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(G3X1CUSOBJ) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             IF         COND((&XTYP *EQ 'O') *OR (&XTYP *EQ 'o')) THEN(DO)
/* 1.OUTBOUND: PROFILE=ZMOD */
             OVRPRTF    FILE(QPRINT) USRDTA('ZMOD')
             PRTEDIDTA  COMPRF(ZMOD) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*YES) INOUT(*O) STRBAT(&XBATCH) +
                          ENDBAT(&XBATCH) INT(*NO)

/* 2.OUTBOUND: PROFILE=CNFTP*/
             OVRPRTF    FILE(QPRINT) USRDTA('CFFTP')
             PRTEDIDTA  COMPRF(CNFTP) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*NO) INOUT(*O) STRBAT(&XBATCH) +
                          ENDBAT(&XBATCH) INT(*NO)
/* 3.OUTBOUND: PROFILE=ZMODV*/
             OVRPRTF    FILE(QPRINT) USRDTA('ZMODV')
             PRTEDIDTA  COMPRF(ZMODV) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*NO) INOUT(*O) STRBAT(&XBATCH) +
                          ENDBAT(&XBATCH) INT(*NO)

/* 4.OUTBOUND: PROFILE=ZMODD*/
             OVRPRTF    FILE(QPRINT) USRDTA('ZMODD')
             PRTEDIDTA  COMPRF(ZMODD) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*NO) INOUT(*O) STRBAT(&XBATCH) +
                          ENDBAT(&XBATCH) INT(*NO)
             ENDDO

             IF         COND((&XTYP *EQ 'I') *OR (&XTYP *EQ 'i')) THEN(DO)
/* 1.INBOUND: PROFILE=ZMOD */
             OVRPRTF    FILE(QPRINT) USRDTA('ZMOD')
             PRTEDIDTA  COMPRF(ZMOD) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*NO) INOUT(*I) STRBAT(&XBATCH) +
                          ENDBAT(&XBATCH) INT(*NO)

/* 2.INBOUND: PROFILE=CNFTP*/
             OVRPRTF    FILE(QPRINT) USRDTA('CNFTP')
             PRTEDIDTA  COMPRF(CNFTP) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*NO) INOUT(*I) STRBAT(&XBATCH) +
                          ENDBAT(&XBATCH) INT(*NO)

/* 3.INBOUND: PROFILE=ZMODV*/
             OVRPRTF    FILE(QPRINT) USRDTA('ZMODV')
             PRTEDIDTA  COMPRF(ZMODV) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*NO) INOUT(*I) STRBAT(&XBATCH) +
                          ENDBAT(&XBATCH) INT(*NO)

/* 4.INBOUND: PROFILE=ZMODD*/
             OVRPRTF    FILE(QPRINT) USRDTA('ZMODD')
             PRTEDIDTA  COMPRF(ZMODD) OUTTYP(*PRINT) OUTFILE(' ') +
                          LIBRARY(*LIBL) OUTOPT(' ' *REPLACE) +
                          CREATE(*NO) INOUT(*I) STRBAT(&XBATCH) +
                          ENDBAT(&XBATCH) INT(*NO)
             ENDDO

ENDP:
             ENDPGM

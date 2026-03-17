             PGM        PARM(&BATCH &RTN)
             /** EDIC06A ******************************************/
             /* RETRIEVE EDI RAW DATA  (OUTBOUND)                 */
             /* J.WATANABE   2025.04.29                           */
             /* COMPILE:     NEED LIBRARY G3X1PGM                 */
             /* ---------------------------------                 */
             /* (PARAMETERS)                                      */
             /* &BATCH  7A  EDI BATCH#                            */
             /* &RTN    1A  RETURN CODE (BLANK:OK, NOT-B:ERROR    */
             /*****************************************************/
             DCL        VAR(&BATCH) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RTN)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRF)   TYPE(*CHAR) LEN(8)

             CHGVAR     VAR(&RTN)  VALUE(' ')
             CHGVAR     VAR(&PRF)  VALUE(' ')

 /* CLEAR WP01      */
             CLRPFM     FILE(HWFILE1/EDIWP01)

             DLTF       FILE(QTEMP/EDIWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(EDIWP01) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/EDIWP01)

 /* CHECK PARAMETER */
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
             CALL       UTGR01 ('O' &BATCH &PRF &RTN)

             IF         COND(&RTN *NE ' ') THEN(DO)
             GOTO       CMDLBL(ENDP)
             ENDDO

             OVRPRTF    FILE(QPRINT) USRDTA(&PRF)
             PRTEDIDTA  COMPRF(&PRF) OUTTYP(*OUTFILE) +
                          OUTFILE(EDIWP01) LIBRARY(HWFILE1) +
                          OUTOPT(' ' *ADD) CREATE(*NO) INOUT(*O) +
                          STRBAT(&BATCH) ENDBAT(&BATCH) INT(*NO)

 /** DELAY 1 SEC **/
             DLYJOB     DLY(1)

 /** TRANSFER DATA TO QTEMP **/
             CPYF       FROMFILE(HWFILE1/EDIWP01) +
                          TOFILE(QTEMP/EDIWP01) MBROPT(*ADD)

ENDP:
             ENDPGM

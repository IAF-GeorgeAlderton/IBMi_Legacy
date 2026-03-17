             PGM
 /** ASNC00 ****************************************************/
 /*  UNIVERSAL ASN - BARCODE ENTRY                             */
 /*  JW        2022.12.06                                      */
 /**************************************************************/
             DCL        VAR(&UPD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERR)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEN)   TYPE(*DEC)  LEN(10 0)

 /* &UPD=N : TEST RUN */
             CHGVAR     VAR(&UPD)  VALUE('N')

             CHGVAR     VAR(&LIB)  VALUE('HFILE1')
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

 /* BARCODE ENTRY   */
             CRTDUPOBJ  OBJ(ASNPP10) FROMLIB(&LIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ASNPP10)

             OVRDBF     FILE(ASNPP10) TOFILE(QTEMP/ASNPP10)

             CALL       PGM(ASNR00) PARM(&UPD &ERR)

             IF         COND(&ERR *EQ '9') THEN(GOTO CMDLBL(ENDP))

             RTVMBRD    FILE(QTEMP/ASNPP10) NBRCURRCD(&KEN)
             IF         COND(&KEN *EQ 0) THEN(GOTO END0)

 /* POSTING */
             CALL       PGM(ASNC70) PARM(&UPD)

 /* HONDA ASN */
             CALL       PGM(ASNC30) PARM(&UPD)

 /* END WITH 0 RECORD */
 END0:

 ENDP:
             DLTOVR     FILE(*ALL)
             ENDPGM

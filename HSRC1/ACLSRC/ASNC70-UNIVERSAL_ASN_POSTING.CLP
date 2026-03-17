             PGM
 /** ASNC70 ****************************************************/
 /*  UNIVERSAL ASN - POSTING                                   */
 /*  JW        2022.12.08                                      */
 /**************************************************************/
             DCL        VAR(&LIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&LIB)  VALUE('HFILE1')
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

             CRTDUPOBJ  OBJ(ASNWP70) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ASNWP70)

 /* CREATE WORK FILE */
             OVRDBF     FILE(ASNWP70) TOFILE(QTEMP/ASNWP70)
             CALL       PGM(ASNR70)

 /* POSTING */
             CALL       PGM(ASNR72)

 /* ERROR REPORT */
             CALL       PGM(ASNR74)

ENDP:
             DLTOVR     FILE(*ALL)
             ENDPGM

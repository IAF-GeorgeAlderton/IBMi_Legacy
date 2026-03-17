             PGM
             /** ADKCA2D *********************************************/
             /*  DOWNLOAD ADKWPA0 (HIGH LIMIT DATA) TO CSV           */
             /*  JW       2025.02.05                                 */
             /********************************************************/
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM)    TYPE(*CHAR) LEN(30)
             DCL        VAR(&ADKWPA0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&ADKWPA0) VALUE('ADKWPA0' *CAT &WS3)

             DLTF       FILE(QTEMP/ADKWPA1)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ADKWPA1) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ADKWPA1)

             OVRDBF     FILE(ADKWPA0) TOFILE(HWFILE1/&ADKWPA0)
             OVRDBF     FILE(ADKWPA1) TOFILE(QTEMP/ADKWPA1)

             CALL       PGM(ADKRA2D)

             CHGVAR     VAR(&FNAM) VALUE('HIGH LIMIT')
             CALL       PGM(APLC94) PARM('2' 'ADKWPA1' 'QTEMP' &FNAM +
                          'Y' ' ' 'Y')

 ENDP:       ENDPGM

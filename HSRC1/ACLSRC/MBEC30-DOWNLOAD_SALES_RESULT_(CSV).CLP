             PGM
/** MBEC30 ************************************************/
/*  DOWNLOAD SALES RESULT (CSV)                           */
/*  J.WATANABE  2026.03.05                                */
/**********************************************************/
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)
             DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)

             CHGVAR     VAR(&FNAM) VALUE('SALES RESULT')

             DLTF       FILE(QTEMP/MBEWP30)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(MBEWP30) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/MBEWP30)

             DLTF       FILE(QTEMP/MBEWP31)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(MBEWP31) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/MBEWP31)

             OVRDBF     FILE(MBEWP30) TOFILE(QTEMP/MBEWP30)
             OVRDBF     FILE(MBEWP31) TOFILE(QTEMP/MBEWP31)

  /* GET SALES RESULT */
             CALL       PGM(MBER30)

  /* END ? */
             RTVMBRD    FILE(QTEMP/MBEWP30) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(ENDP))

  /* CREATE OUTPUT DATA */
             CALL       PGM(MBER31)

  /* OUTPUT TO CSV */
             CALL       PGM(APLC94) PARM('2' 'MBEWP31' 'QTEMP' &FNAM 'Y' ' ' 'Y')

ENDP:        ENDPGM

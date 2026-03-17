             PGM

/** IZAC79D ***********************************************/
/*  WIRE INVENTORY LOG FILE DOWNLOAD TO CSV               */
/*  LEC          2025.06.30                               */
/**********************************************************/

             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)
             DCL        VAR(&FDAT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&TDAT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&RCDS) TYPE(*DEC) LEN(10 0)

             DLTF       FILE(QTEMP/IZAWP79)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(IZAWP79) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/IZAWP79)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(IZAWP79) TOFILE(QTEMP/IZAWP79)
             CALL       PGM(IZAR79D)

             RTVMBRD    FILE(QTEMP/IZAWP79) NBRCURRCD(&RCDS)
             IF         COND(&RCDS *GT 0)   THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('WIRE INV SCAN FILE')
             CALL       PGM(APLC94) PARM('2' 'IZAWP79' 'QTEMP' &FNAM +
                          'Y' 'Y' 'Y')
                                            ENDDO
             ENDPGM

             PGM      PARM(&TOKU &NONY &NKOJ &NUKE)
             /** ABBC32 ********************************/
             /*  SALES STATISTIC AND FORECAST (CSV)    */
             /*  JW    2019.02.18                      */
             /******************************************/

             DCL        VAR(&TOKU) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(4)

             CHKOBJ     OBJ(QTEMP/ABBWP29) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDUPOBJ  OBJ(ABBWP29) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             ENDDO

             CLRPFM     FILE(QTEMP/ABBWP29)

             OVRDBF     FILE(ABBWP29) TOFILE(QTEMP/ABBWP29)
             OVRDBF     FILE(MBDWP02) TOFILE(QTEMP/MBDWP02)

             CALL       PGM(ABBR32) PARM(&TOKU &NONY &NKOJ &NUKE)

             CALL       PGM(ABBR33)

             ENDPGM

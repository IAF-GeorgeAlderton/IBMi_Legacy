             PGM
             /** ABBC31 ********************************/
             /*  TRANSFER FORECAST DATA TO IFS.CSV     */
             /*  JW1      2018.11.02                   */
             /******************************************/

             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&CSV )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ADDR)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SIRE)  TYPE(*CHAR) LEN(4)

             CHKOBJ     OBJ(QTEMP/ABBWP30) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(ABBWP30) +
                          FROMLIB(*LIBL) OBJTYPE(*FILE) TOLIB(QTEMP))

             CLRPFM     FILE(QTEMP/ABBWP30)
             OVRDBF     FILE(ABBWP29) TOFILE(QTEMP/ABBWP29)
             OVRDBF     FILE(ABBWP30) TOFILE(QTEMP/ABBWP30)

             CALL       PGM(ABBR31) PARM(&SIRE)

             CHGVAR     VAR(&TYPE) VALUE('2')
             CHGVAR     VAR(&FILE) VALUE('ABBWP30')
             CHGVAR     VAR(&LIBL) VALUE('QTEMP')
             CHGVAR     VAR(&FNAM) VALUE('SELECTED FORECAST' *BCAT &SIRE)
             CHGVAR     VAR(&CSV ) VALUE('Y')
             CHGVAR     VAR(&ADDR) VALUE(' ')
             CHGVAR     VAR(&MSG ) VALUE('Y')

             CALL   PGM(APLC94) PARM(&TYPE &FILE &LIBL &FNAM &CSV &ADDR &MSG)


             ENDPGM

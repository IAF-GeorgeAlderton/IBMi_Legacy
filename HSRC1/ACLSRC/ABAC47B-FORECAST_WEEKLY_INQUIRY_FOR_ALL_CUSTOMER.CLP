             PGM        PARM(&STDT)
/* ABAC47B ************************************************/
/* FORECAST WEEKLY INQUIRY FOR ALL CUSTOMERS (CSV)        */
/* J.WATANABAE  2021.08.26                                */
/**********************************************************/

             DCL        VAR(&STDT)  TYPE(*CHAR) LEN(8)

             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&CSV )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ADDR)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG )  TYPE(*CHAR) LEN(1)

             DLTF       FILE(QTEMP/ABAWP47B)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABAWP47B) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABAWP47B)

             OVRDBF     FILE(ABAWP47A) TOFILE(QTEMP/ABAWP47A)
             OVRDBF     FILE(ABAWP47B) TOFILE(QTEMP/ABAWP47B)
             CALL       PGM(ABAR47B) PARM(&STDT)

 /* DOWNLOAD TO CSV */
             CHGVAR     VAR(&TYPE) VALUE('2')
             CHGVAR     VAR(&FILE) VALUE('ABAWP47B')
             CHGVAR     VAR(&LIBL) VALUE('QTEMP')
             CHGVAR     VAR(&FNAM) VALUE('ALL CUSTOMER FORECAST (WEEKLY)')
             CHGVAR     VAR(&CSV ) VALUE('Y')
             CHGVAR     VAR(&ADDR) VALUE(' ')
             CHGVAR     VAR(&MSG ) VALUE('Y')
             CALL   PGM(APLC94) PARM(&TYPE &FILE &LIBL &FNAM &CSV &ADDR &MSG)

             DLTOVR     FILE(*ALL)

    /***     CPYF       FROMFILE(QTEMP/ABAWP47A) +                     ***/
    /***                  TOFILE(TWFILE1/ABAWP47A) MBROPT(*REPLACE) +  ***/
    /***                  FMTOPT(*NOCHK)                               ***/
    /***                                                               ***/
    /***     CPYF       FROMFILE(QTEMP/ABAWP47B) +                     ***/
    /***                  TOFILE(TWFILE1/ABAWP47B) MBROPT(*REPLACE) +  ***/
    /***                  FMTOPT(*NOCHK)                               ***/

             ENDPGM

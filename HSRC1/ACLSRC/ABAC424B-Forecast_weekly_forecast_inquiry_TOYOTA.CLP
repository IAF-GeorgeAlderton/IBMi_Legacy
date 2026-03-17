             PGM        PARM(&STDT)
/* ABAC424B ***********************************************/
/* FORECAST WEEKLY INQUIRY FOR TOYOTA (CSV)               */
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

             DLTF       FILE(QTEMP/ABAWP41B)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABAWP41B) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABAWP41B)

             OVRDBF     FILE(ABAWP41A) TOFILE(QTEMP/ABAWP41A)
             OVRDBF     FILE(ABAWP41B) TOFILE(QTEMP/ABAWP41B)
             CALL       PGM(ABAR424B) PARM(&STDT)

 /* DOWNLOAD TO CSV */
             CHGVAR     VAR(&TYPE) VALUE('2')
             CHGVAR     VAR(&FILE) VALUE('ABAWP41B')
             CHGVAR     VAR(&LIBL) VALUE('QTEMP')
             CHGVAR     VAR(&FNAM) VALUE('TOYOTA FORECAST (WEEKLY)')
             CHGVAR     VAR(&CSV ) VALUE('Y')
             CHGVAR     VAR(&ADDR) VALUE(' ')
             CHGVAR     VAR(&MSG ) VALUE('Y')
             CALL   PGM(APLC94) PARM(&TYPE &FILE &LIBL &FNAM &CSV &ADDR &MSG)

             DLTOVR     FILE(*ALL)

    /***     CPYF       FROMFILE(QTEMP/ABAWP41A) +                     ***/
    /***                  TOFILE(TWFILE1/ABAWP41A) MBROPT(*REPLACE) +  ***/
    /***                  FMTOPT(*NOCHK)                               ***/
    /***                                                               ***/
    /***     CPYF       FROMFILE(QTEMP/ABAWP41B) +                     ***/
    /***                  TOFILE(TWFILE1/ABAWP41B) MBROPT(*REPLACE) +  ***/
    /***                  FMTOPT(*NOCHK)                               ***/

             ENDPGM

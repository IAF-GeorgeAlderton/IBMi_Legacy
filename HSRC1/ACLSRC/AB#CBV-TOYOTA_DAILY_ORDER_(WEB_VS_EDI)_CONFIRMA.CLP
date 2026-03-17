  PGM
/** AB#CBV ************************************************/
/* TOYOTA DAILY ORDER (WEB VS EDI) CONFIRMATION           */
/* JW    2020.07.09                                       */
/**********************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)
             /*--------------------------------------------*/
             /*    CHECK ENVIRONMENT                        */
             /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             DLTF       FILE(QTEMP/AB#WPBV)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPBV) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WPBV)

             OVRDBF     FILE(AB#WPBV) TOFILE(QTEMP/AB#WPBV)
             CALL       PGM(AB#RBV)


             ENDPGM

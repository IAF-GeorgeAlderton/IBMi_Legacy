             PGM        PARM(&NONY &NOBN &NOHZ1 &NOHZ2 &NOHZ3)
/** AB#CBV2 ***********************************************/
/* TOYOTA DAILY ORDER (WEB VS EDI) DIFFERENCE             */
/* JW    2020.07.14                                       */
/**********************************************************/
             DCL        VAR(&NONY)  TYPE(*CHAR) LEN(04)
             DCL        VAR(&NOBN)  TYPE(*CHAR) LEN(02)
             DCL        VAR(&NOHZ1) TYPE(*CHAR) LEN(08)
             DCL        VAR(&NOHZ2) TYPE(*CHAR) LEN(08)
             DCL        VAR(&NOHZ3) TYPE(*CHAR) LEN(08)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(01)

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)
             /*--------------------------------------------*/
             /*    CHECK ENVIRONMENT                        */
             /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             DLTF       FILE(QTEMP/AB#WPBV2)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPBV2) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WPBV2)

             OVRDBF     FILE(AB#WPBV2) TOFILE(QTEMP/AB#WPBV2)
             CALL       PGM(AB#RBV2) PARM(&NONY &NOBN &NOHZ1 &NOHZ2 +
                          &NOHZ3 &RTN)

             DLTOVR     FILE(*ALL)

             ENDPGM

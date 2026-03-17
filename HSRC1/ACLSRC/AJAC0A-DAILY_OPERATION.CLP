             PGM
             /** AJAC01 ****************************/
             /*  ..DAILY OPERATION..               */
             /*    I-HASADA           97.08.09     */
             /**************************** AJAC01 **/
             DCL        VAR(&JJADS1) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PJRNRCV) TYPE(*CHAR) LEN(7)
             DCL        VAR(&QDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JFILE) TYPE(*CHAR) LEN(7)
             RTVDTAARA  DTAARA(JJADS1) RTNVAR(&JJADS1)
             RTVJOBA    DATE(&QDATE)


             CHGVAR     VAR(&PJRNRCV) VALUE(&JJADS1)
             CHGVAR     VAR(&JFILE) VALUE(J *CAT &QDATE)

             CRTJRNRCV  JRNRCV(HJRN1/&JFILE) TEXT(JRNRCV) AUT(*ALL)
             MONMSG     MSGID(CPF7010) EXEC(GOTO CMDLBL(END))
             CHGJRN     JRN(HJRN1/JRNAPICS) JRNRCV(HJRN1/&JFILE)

             CHGDTAARA  DTAARA(HJRN1/JJADS1) VALUE(&JFILE)

             DLTF       FILE(APSAVLIB/&PJRNRCV)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(APSAVLIB/&PJRNRCV) AUT(*ALL)

             SAVOBJ     OBJ(&PJRNRCV) LIB(HJRN1) DEV(*SAVF) +
                          OBJTYPE(*JRNRCV) SAVF(APSAVLIB/&PJRNRCV)

             DLTF       FILE(APSAVLIB/&PJRNRCV)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTJRNRCV  JRNRCV(HJRN1/&PJRNRCV)
             MONMSG     MSGID(CPF2105 CPF7023)

 END:        ENDPGM

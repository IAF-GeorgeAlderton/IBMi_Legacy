  PGM        PARM(&FROM &TO &NONY &SHIN)
/** AB#CC1 ************************************************/
/* IAF PART# DAILY SHIPPED CONTAINER INQUIRY              */
/* JW        2025.04.21                                   */
/**********************************************************/
             DCL        VAR(&FROM)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TO  )  TYPE(*CHAR) LEN(8)
             DCL        VAR(&NONY)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&SHIN)  TYPE(*CHAR) LEN(12)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)

             DLTF       FILE(QTEMP/AB#WPC2)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPC2) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WPC2)

             DLTF       FILE(QTEMP/AB#WPC2B)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPC2B) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WPC2B)

             OVRDBF     FILE(AB#WPC2)  TOFILE(QTEMP/AB#WPC2)
             OVRDBF     FILE(AB#WPC2B) TOFILE(QTEMP/AB#WPC2B)
             CALL       PGM(AB#RC2 ) PARM(&FROM &TO &NONY &SHIN)

 /* DOWNLOAD */
             CHGVAR     VAR(&FNAM) VALUE('SHIPPED CONTAINER LIST')
             CALL       PGM(APLC94) PARM('2' 'AB#WPC2B' 'QTEMP' &FNAM +
                          'Y' ' ' 'Y')

             ENDPGM

             PGM

             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)

             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID)

             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             DLTF       FILE(QTEMP/INVWP41)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HWFILE1/INVWP41) +
                          TOFILE(QTEMP/INVWP41) CRTFILE(*YES)

             DLTF       FILE(QTEMP/AB#WPS3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HWFILE1/AB#WPS3) +
                          TOFILE(QTEMP/AB#WPS3) CRTFILE(*YES)

             DLTF       FILE(QTEMP/AB#WPS4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HWFILE1/AB#WPS4) +
                          TOFILE(QTEMP/AB#WPS4) CRTFILE(*YES)

             CLRPFM     FILE(QTEMP/INVWP41)
             CLRPFM     FILE(QTEMP/AB#WPS3)
             CLRPFM     FILE(QTEMP/AB#WPS4)

             /* INVPP40 -> INVWP41 */
             CALL       PGM(INVR41) PARM(' ' '  ' '  ' ' ')

             /* FCEPP01 -> QTEMP/INVPP40 */
             DLTF       FILE(QTEMP/INVPP40)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(INVPP40) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             OVRDBF     FILE(INVPP40) TOFILE(QTEMP/INVPP40)
             CALL       PGM(INVR4E)

             /* INVPP40 -> INVWP41 */
             CALL       PGM(INVR41) PARM(' ' '  ' '  ' ' ')
             DLTOVR     FILE(INVPP40)

             CALL       PGM(INVR42)
             CALL       PGM(INVR43)

             DLTF       FILE(HWFILE1/INVWP41T)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/INVWP41T) RCDLEN(2015) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(OUTPUT) TOFILE(INVWP41T)

             CALL       PGM(INVR45)

             CHGVAR     VAR(&@LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&@FILE) VALUE('INVWP41T')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/INVWP41T.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')

             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)

             STRPCCMD   PCCMD(&@SAVE) PAUSE(*NO)

             DLTF       FILE(HWFILE1/INVWP47)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/INVWP47) RCDLEN(2015) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(OUTPUT) TOFILE(INVWP47)
             CALL       PGM(INVR47)

             CHGVAR     VAR(&@LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&@FILE) VALUE('INVWP47')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/INVWP47.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')

             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)

             STRPCCMD   PCCMD(&@SAVE) PAUSE(*NO)

             ENDPGM

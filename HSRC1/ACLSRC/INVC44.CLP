             PGM

             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)

             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)

             RTVNETA    SYSNAME(&SYS)

             CHGVAR     VAR(&@LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&@FILE) VALUE('INVWP41S')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/INVWP41S.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')

             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)

             STRPCCMD   PCCMD(&@SAVE) PAUSE(*NO)

             ENDPGM

             PGM

             DCL        VAR(&FROM) TYPE(*CHAR) LEN(10) VALUE('ARPGSRC')
             DCL        VAR(&TO  ) TYPE(*CHAR) LEN(10) VALUE('ARPGSRC')

             CLRPFM     FILE(HSRC2/&TO) MBR(*ALL)
             MONMSG     MSGID(CPF3133)

 /* COPY SOURCE FILE */
             CPYSRCF    FROMFILE(HSRC1/&FROM) TOFILE(HSRC2/&TO) +
                          FROMMBR(*ALL) TOMBRID(*FROMMBR) +
                          MBROPT(*REPLACE)

        /**  MONMSG     MSGID(CPF2817)  **/

             ENDPGM

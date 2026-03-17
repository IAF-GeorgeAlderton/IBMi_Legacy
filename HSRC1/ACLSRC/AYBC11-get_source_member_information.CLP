             PGM        PARM(&LIB &FILE &MBR)
             /** AY020C ****************************/
             /* GET SOURCE MEMBER INFORMATION      */
             /* JW(SRA)          2015.11.10        */
             /**************************************/

             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)

             DLTF       FILE(@FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(@FILE) RCDLEN(102) +
                          IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000 1000 3) LVLCHK(*NO)

             CLRPFM     FILE(AYBWP10)
             CLRPFM     FILE(AYBWP11)
             OVRDBF     FILE(@FILE) TOFILE(&LIB/&FILE) MBR(&MBR)
             CALL       PGM(AYBR11)

             ENDPGM

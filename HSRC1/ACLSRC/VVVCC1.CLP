             PGM

             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)

             DCL        VAR(&MOJI) TYPE(*CHAR) LEN(20)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(2)

             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)

             RTVNETA    SYSNAME(&SYS)

             CHGVAR     VAR(&FILE) VALUE('FCEPP01')

             CHGVAR     VAR(&MOJI) VALUE(' ')
             CHGVAR     VAR(&MOJI) VALUE(&FILE)

             CALL       PGM(INPR03) PARM('FILE' &MOJI '07' &RTN)
             IF         COND(&RTN *EQ '01') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

             CHGVAR     VAR(&FILE) VALUE(&MOJI)

             DLTF       FILE(VVVWPC1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/VVVWPC1) RCDLEN(256)

             CALL       PGM(VVVRC1) PARM(&FILE)

             CHGVAR     VAR(&@LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&@FILE) VALUE('VVVWPC1')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/VVVWPC1.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')

             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)







@END:
             ENDPGM

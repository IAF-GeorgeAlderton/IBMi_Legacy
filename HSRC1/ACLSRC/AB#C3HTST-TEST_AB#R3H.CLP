             PGM

             DCL        VAR(&SIRE) TYPE(*CHAR) LEN(4)   VALUE('5152')
             DCL        VAR(&SIRK) TYPE(*CHAR) LEN(1)   VALUE('0')
             DCL        VAR(&NOHZ) TYPE(*DEC)  LEN(8 0) VALUE(20210602)
             DCL        VAR(&REDT) TYPE(*DEC)  LEN(8 0) VALUE(20210602)
             DCL        VAR(&NOBI) TYPE(*DEC)  LEN(2 0) VALUE(01)
             DCL        VAR(&DOCK) TYPE(*CHAR) LEN(4)   VALUE('OW  ')
             DCL        VAR(&INV#) TYPE(*CHAR) LEN(11)

             DLTF       FILE(AB#WPF0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AB#WPF0) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AB#WP30) TOFILE(HWFILE1/AB#WPF0)

             CALL       PGM(AB#R3H) PARM(&SIRE &SIRK &NOHZ &REDT +
                          &NOBI &DOCK &INV#)

             ENDPGM

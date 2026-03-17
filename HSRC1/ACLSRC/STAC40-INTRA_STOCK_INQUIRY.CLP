             PGM        PARM(&P@SHN1 &P@SHN2 &P@SHN3)
             /** STAC40 *******************************************/
             /* INQ INTRA STOCK DATA                              */
             /*   SAKAKI.         2020.02.14                      */
             /* JW1       2021.02.19 USE QTEMP FOR WORK FILE      */
             /*****************************************************/
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC)     TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&P@SORT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&P@ERR)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&STAWP40) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAM)    TYPE(*CHAR) LEN(30)
             DCL        VAR(&P@SHN1)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&P@SHN2)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&P@SHN3)  TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)

             CHGVAR     VAR(&WS3)  VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')

             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             CHGVAR     VAR(&STAWP40) VALUE('STAWP40' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP00:
             DLTF       FILE(&WLIB/&STAWP40)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&STAWP40) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(STAWP40) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(STAWP40) TOFILE(&WLIB/&STAWP40)

             CALL       PGM(STAR40) PARM(&P@SHN1 &P@SHN2 &P@SHN3)

             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(#END))

             OVRDBF     FILE(STAWP40) TOFILE(&WLIB/&STAWP40)
             CALL       PGM(STAR41) PARM(&P@SHN1 &P@SHN2 &P@SHN3)
 #END:
             ENDPGM

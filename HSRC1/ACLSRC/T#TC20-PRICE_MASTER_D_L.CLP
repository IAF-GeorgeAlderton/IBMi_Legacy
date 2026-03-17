             PGM
             /** T#TC20 ************************/
             /* PRICE MASTER D/L               */
             /************************ T#TC20 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
        /*SEND MAIL SET */
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB2)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&T#TWP20) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)

             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(ALBC01) PARM(&US &PLIB &WLIB)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&TO1) VALUE('KAZUKI.KOBAYASHI@IAFI.COM')
             CHGVAR     VAR(&SUB) VALUE('PRICE DATA    ' *CAT &US)
             CHGVAR     VAR(&FNAME) VALUE('SALES-DATA.CSV')
             CHGVAR     VAR(&WLIB2) VALUE(&WLIB *CAT '  ')

             CHGVAR     VAR(&T#TWP20) VALUE('T#TWP20' *CAT &WS3)

             DLTF       FILE(&WLIB/&T#TWP20)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&T#TWP20) RCDLEN(102) +
                          OPTION(*NOLIST) SIZE(100000 1000 9) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(T#TWP20) TOFILE(&WLIB/&T#TWP20)
             CALL       PGM(T#TR20) PARM(&TO1)

             RTVMBRD    FILE(&WLIB/&T#TWP20) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(END))

             CALL       PGM(APLC30) PARM(&TO1 &SUB &WLIB2 +
                          &T#TWP20 &FNAME)
  END:
             DLTOVR     FILE(*ALL)
             ENDPGM
